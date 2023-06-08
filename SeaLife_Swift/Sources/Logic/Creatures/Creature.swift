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

    //MARK: Private vars
    
    private let timer: CreatureTimerProtocol
    private let queue = DispatchQueue(label: "CreatureQueue")
    
    internal let turnHelperClass: TurnHelperProtocol.Type
    
    //MARK: Memory
    
    init()
    {
        fatalError("must call initWithTurnHelperClass")
    }
    
    public required init(uuid: UUID = UUID(), deps: CreatureDeps)
    {
        self.turnHelperClass = deps.turnHelperClass
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
    
    //MARK: Public methods
    
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
    
    //MARK: Private
    
    internal func performTurn(completion: @escaping ()->())
    {
        var possibleTurnCells = Set<WorldCell>()
        var lockedCells = Set<WorldCell>()
        
        let currentCell = world.cell(for: position) //self cell may be busy by other creature turn
        if let currentCell {
            lockedCells.insert(currentCell)
            
            let turnPositions = possibleTurnPositions(from: position)
            possibleTurnCells = world.cells(for: turnPositions)
            lockedCells.formUnion(possibleTurnCells)
        }
        
        beforeEveryTurn()
        let turn = decideTurn(for: currentCell, possibleCells: possibleTurnCells)
        afterEveryTurn()

        lockedCells.subtract(turn.busyCells)
        world.unlock(cells: lockedCells)
        
        switch turn {
        case .empty(creature: _, cell: _):
            performEmpty(turn: turn, completion: completion)
        case .move(creature: _, startCell: _, targetCell: _):
            performMove(turn: turn, completion: completion)
        case .eat(creature: _, startCell: _, targetCell: _, targetCreature: _):
            performEat(turn: turn, completion: completion)
        case .reproduce(creature: _, startCell: _, targetCell: _):
            performReproduce(turn: turn, completion: completion)
        case .born(newCreature: _, cell: _):
            fatalError("creature can't perform born turn itself")
        case .die(creature: _, cell: _):
            performDie(turn: turn, completion: completion)
        }
    }
    
    internal func beforeEveryTurn() { fatalError("must be overriden") }
    
    internal func afterEveryTurn() { fatalError("must be overriden") }
    
    internal func possibleTurnPositions(from position: WorldPosition) -> Set<WorldPosition> { fatalError("must be overriden") }
    
    internal func decideTurn(for cell: WorldCell?, possibleCells: Set<WorldCell>) -> Turn { fatalError("must be overriden") }
    
    //MARK: Private
    
    private func performEmpty(turn: Turn,
                              completion: @escaping ()->())
    {
        animator?.performAnimations(for: turn, completionQueue: queue) {
            completion()
        }
    }
    
    private func performEat(turn: Turn,
                            completion: @escaping ()->())
    {
        guard case let .eat(creature: _, startCell: startCell, targetCell: targetCell, targetCreature: targetCreature) = turn else {
            assertionFailure("Turn is wrong type \(turn)")
            return
        }
        
        targetCreature.stop()
        
        world.move(creature: self, fromCell: startCell, toCell: targetCell)
        
        world.unlock(cell: startCell)

        animator?.performAnimations(for: turn, completionQueue: queue) { [weak self] in
            guard let self else { return }
            
            let nextTurn = Turn.die(creature: targetCreature, cell: targetCell)

            completion()
            
            targetCreature.animator?.performAnimations(for: nextTurn, completionQueue: queue) { [weak targetCreature] in
                guard let targetCreature else { return }

                targetCreature.world.unlock(cell: targetCell)
                targetCreature.world.remove(creature: targetCreature, at: nil)
            }
        }
    }
    
    private func performMove(turn: Turn,
                             completion: @escaping ()->())
    {
        guard case let .move(creature: _, startCell: startCell, targetCell: targetCell) = turn else {
            assertionFailure("Turn is wrong type \(turn)")
            return
        }
        
        world.move(creature: self, fromCell: startCell, toCell: targetCell)
        
        world.unlock(cell: startCell)

        animator?.performAnimations(for: turn, completionQueue: queue) { [weak self] in
            guard let self else { return }
            
            self.world.unlock(cell: targetCell)
            
            completion()
        }
    }
    
    private func performReproduce(turn: Turn,
                                  completion: @escaping ()->())
    {
        guard case let .reproduce(creature: _, startCell: startCell, targetCell: targetCell) = turn else {
            assertionFailure("Turn is wrong type \(turn)")
            return
        }
        
        animator?.performAnimations(for: turn, completionQueue: queue) { [weak self] in
            guard let self else { return }
            
            self.world.unlock(cell: startCell)

            let newCreature = self.world.creature(for: type(of: self))
            self.world.add(creature: newCreature, at: targetCell)
            
            completion()

            let nextTurn = Turn.born(newCreature: newCreature, cell: targetCell)
            newCreature.animator?.performAnimations(for: nextTurn, completionQueue: self.queue) { [weak newCreature] in
                guard let newCreature else { return }
                
                newCreature.world.unlock(cell: targetCell)
                
                if case .paused(fromState: _) = newCreature.state.state {
                    newCreature.state.state = .paused(fromState: .idle)
                } else {
                    newCreature.start()
                }
            }
        }
    }
    
    private func performDie(turn: Turn,
                            completion: @escaping ()->())
    {
        guard case let .die(creature: _, cell: cell) = turn else {
            assertionFailure("Turn is wrong type \(turn)")
            return
        }
        
        stop()
        
        animator?.performAnimations(for: turn, completionQueue: DispatchQueue.main) { [weak self] in
            guard let self else { return }
            
            self.world.remove(creature: self, at: cell)
            
            self.world.unlock(cell: cell)
            
            completion()
        }
    }
}
