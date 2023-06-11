//
//  Creature.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import UIKit

public class Creature: CreatureProtocol
{
    public let uuid: UUID
    public var position: WorldPosition = .zero()
    public var direction: Direction = .none

    public unowned let world: WorldProtocol

    public var animator: CreatureAnimator?

    public var state: CreatureState = CreatureState()

    // MARK: Private vars

    private let timer: CreatureTimerProtocol
    private let queue = DispatchQueue(label: "CreatureQueue")

    internal let turnFactoryType: TurnFactoryProtocol.Type

    // MARK: Memory

    init()
    {
        fatalError("must call init(uuid:, deps:)")
    }

    public required init(uuid: UUID = UUID(), deps: CreatureDeps)
    {
        self.turnFactoryType = deps.turnFactoryType
        self.world = deps.world
        self.uuid = uuid

        timer = CreatureTimer()

        timer.handler = { [weak self] in
            self?.queue.async {
                let turnBlockItem = DispatchWorkItem(block: { [weak self] in
                    self?.performTurn(completion: {
                        self?.state.setNextOnCompletion()
                    })
                })
                self?.state.setNextOnHandle(item: turnBlockItem)
            }
        }
    }

    // MARK: Public methods

    public func setTimerTargetQueue(_ queue: DispatchQueue) {
        timer.setTargetQueue(queue)
    }
    public func setSpeed(_ speed: Double) {
        timer.setSpeed(speed)
    }
    public func start() {
        state.setActive()
        animator?.play()
        timer.start()
    }
    public func pause() {
        state.setPause()
        animator?.pause()
        timer.pause()
    }
    public func stop() {
        state.setDead()
        timer.stop()
    }

    // MARK: Private

    internal func performTurn(completion: @escaping () -> Void)
    {
        var possibleTurnCells = Set<WorldCell>()
        var lockedCells = Set<WorldCell>()

        let currentCell = world.cell(for: position) // self cell may be busy by other creature turn
        if let currentCell {
            lockedCells.insert(currentCell)

            let turnPositions = turnFactoryType.possibleTurnPositions(from: position)
            possibleTurnCells = world.cells(for: turnPositions)
            lockedCells.formUnion(possibleTurnCells)
        }

        beforeEveryTurn()
        let turn = decideTurn(for: currentCell, possibleCells: possibleTurnCells)
        afterEveryTurn()

        lockedCells.subtract(turn.busyCells)
        world.unlock(cells: lockedCells)

        switch turn {
        case .empty:
            performEmpty(turn: turn, completion: completion)
        case .move:
            performMove(turn: turn, completion: completion)
        case .eat:
            performEat(turn: turn, completion: completion)
        case .reproduce:
            performReproduce(turn: turn, completion: completion)
        case .born:
            fatalError("creature can't perform born turn itself")
        case .die:
            performDie(turn: turn, completion: completion)
        }
    }

    internal func beforeEveryTurn() { fatalError("must be overriden") }

    internal func afterEveryTurn() { fatalError("must be overriden") }

    internal func decideTurn(for cell: WorldCell?, possibleCells: Set<WorldCell>) -> Turn { fatalError("must be overriden") }

    // MARK: Private

    private func performEmpty(turn: Turn,
                              completion: @escaping () -> Void)
    {
        animator?.performAnimations(for: turn, completionQueue: queue) {
            completion()
        }
    }

    private func performEat(turn: Turn,
                            completion: @escaping () -> Void)
    {
        guard case let .eat(creature: creature, startCell: startCell, targetCell: targetCell, targetCreature: targetCreature) = turn else {
            fatalError("Turn is wrong type \(turn)")
        }

        world.move(creature: creature, fromCell: startCell, toCell: targetCell)

        world.unlock(cell: startCell)

        targetCreature.state.setDead()

        let completionQueue = queue
        animator?.performAnimations(for: turn, completionQueue: completionQueue)
        { [weak self] in
            guard let self else { return }

            let nextTurn = Turn.die(creature: targetCreature, cell: targetCell)

            completion()

            targetCreature.animator?.performAnimations(for: nextTurn, completionQueue: completionQueue)
            { [weak targetCreature, weak world = self.world] in

                if let targetCreature {
                    world?.removeFromVisual(creature: targetCreature)
                    world?.remove(creature: targetCreature, at: nil)
                }

                world?.unlock(cell: targetCell)
            }
        }
    }

    private func performMove(turn: Turn,
                             completion: @escaping () -> Void)
    {
        guard case let .move(creature: creature, startCell: startCell, targetCell: targetCell) = turn else {
            fatalError("Turn is wrong type \(turn)")
        }

        world.move(creature: creature, fromCell: startCell, toCell: targetCell)

        world.unlock(cell: startCell)

        animator?.performAnimations(for: turn, completionQueue: queue)
        { [weak world = self.world] in
            world?.unlock(cell: targetCell)

            completion()
        }
    }

    private func performReproduce(turn: Turn,
                                  completion: @escaping () -> Void)
    {
        guard case let .reproduce(creature: creature, startCell: startCell, targetCell: targetCell) = turn else {
            fatalError("Turn is wrong type \(turn)")
        }

        let newCreature = world.creature(for: type(of: creature))
        world.add(creature: newCreature, at: targetCell)

        animator?.performAnimations(for: turn, completionQueue: queue)
        { [weak self, weak world = self.world] in
            guard let self else { return }

            world?.unlock(cell: startCell)

            completion()

            world?.addToVisual(creature: newCreature, at: targetCell)

            let nextTurn = Turn.born(newCreature: newCreature, cell: targetCell)
            newCreature.animator?.performAnimations(for: nextTurn, completionQueue: self.queue)
            { [weak newCreature] in

                newCreature?.world.unlock(cell: targetCell)

                // when paused and presenting something fullscreen animations
                // completed and newcreature appear here in paused-initial state
                // so set it paused-idle so it can start performing later
                if case .paused = newCreature?.state.state {
                    newCreature?.state.state = .paused(fromState: .idle)
                } else {
                    newCreature?.start()
                }
            }
        }
    }

    private func performDie(turn: Turn,
                            completion: @escaping () -> Void)
    {
        guard case let .die(creature: _, cell: cell) = turn else {
            fatalError("Turn is wrong type \(turn)")
        }

        stop()

        animator?.performAnimations(for: turn, completionQueue: DispatchQueue.main)
        { [weak self, weak world = self.world] in
            guard let self else { return }

            world?.removeFromVisual(creature: self)
            world?.remove(creature: self, at: cell)

            world?.unlock(cell: cell)

            completion()
        }
    }
}
