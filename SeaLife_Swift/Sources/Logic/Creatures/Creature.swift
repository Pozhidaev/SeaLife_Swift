//
//  Creature.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import Foundation

public class Creature: CreatureProtocol
{
    public let uuid = UUID()
    public var position: WorldPosition = .zero()
    public var direction: Direction = .none
    
    public unowned var world: WorldProtocol
    public unowned var visualDelegate: WorldVisualDelegate

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
    
    public required init(turnHelperClass: TurnHelperProtocol.Type,
                         visualDelegate: any WorldVisualDelegate,
                         world: any WorldProtocol)
    {
        self.turnHelperClass = turnHelperClass
        self.visualDelegate = visualDelegate
        self.world = world
        
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
        timer.start()
    }
    public func pause() {
        timer.pause()
        state.setPause()
    }
    public func stop() {
        timer.stop()
        state.setDead()
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

        switch turn {
        case .empty(creature: _, cell: _):
            performEmpty(turn: turn, lockedCells: lockedCells, completion: completion)
        case .move(creature: _, startCell: _, targetCell: _):
            performMove(turn: turn, lockedCells: lockedCells, completion: completion)
        case .eat(creature: _, startCell: _, targetCell: _, targetCreature: _):
            performEat(turn: turn, lockedCells: lockedCells, completion: completion)
        case .reproduce(creature: _, startCell: _, targetCell: _):
            performReproduce(turn: turn, lockedCells: lockedCells, completion: completion)
        case .born(newCreature: _, cell: _):
            fatalError("creature can't perform born turn itself")
        case .die(creature: _, cell: _):
            performDie(turn: turn, lockedCells: lockedCells, completion: completion)
        }
    }
    
    internal func beforeEveryTurn() { fatalError("must be overriden") }
    
    internal func afterEveryTurn() { fatalError("must be overriden") }
    
    internal func possibleTurnPositions(from position: WorldPosition) -> Set<WorldPosition> { fatalError("must be overriden") }
    
    internal func decideTurn(for cell: WorldCell?, possibleCells: Set<WorldCell>) -> Turn { fatalError("must be overriden") }
    
    //MARK: Private
    
    private func performEmpty(turn: Turn,
                              lockedCells: Set<WorldCell>,
                              completion: @escaping ()->())
    {
        world.unlock(cells: lockedCells)
        
        visualDelegate.performAnimations(for: turn) {
            completion()
        }
    }
    
    private func performEat(turn: Turn,
                            lockedCells: Set<WorldCell>,
                            completion: @escaping ()->())
    {
        guard case let .eat(creature: _, startCell: startCell, targetCell: targetCell, targetCreature: targetCreature) = turn else {
            assertionFailure("Turn is wrong type \(turn)")
            return
        }

        var tempLockedCells = lockedCells
        
        targetCreature.stop()
        world.remove(creature: targetCreature, at: targetCell)
        
        world.move(creature: self, fromCell: startCell, toCell: targetCell)
        
        tempLockedCells.remove(targetCell)
        world.unlock(cells: tempLockedCells)
        
        weak var world = self.world
        visualDelegate.performAnimations(for: turn) { [weak self, world] in
            let nextTurn = Turn.die(creature: targetCreature, cell: targetCell)
            completion()
            self?.visualDelegate.performAnimations(for: nextTurn) {
                world?.unlock(cell: targetCell)
            }
        }
    }
    
    private func performMove(turn: Turn,
                             lockedCells: Set<WorldCell>,
                             completion: @escaping ()->())
    {
        guard case let .move(creature: _, startCell: startCell, targetCell: targetCell) = turn else {
            assertionFailure("Turn is wrong type \(turn)")
            return
        }
        
        var tempLockedCells = lockedCells
        
        world.move(creature: self, fromCell: startCell, toCell: targetCell)
        
        tempLockedCells.remove(targetCell)
        world.unlock(cells: tempLockedCells)

        visualDelegate.performAnimations(for: turn) {
            
            self.world.unlock(cell: targetCell)
            completion()
        }
    }
    
    private func performReproduce(turn: Turn,
                                  lockedCells: Set<WorldCell>,
                                  completion: @escaping ()->())
    {
        guard case let .reproduce(creature: _, startCell: startCell, targetCell: targetCell) = turn else {
            assertionFailure("Turn is wrong type \(turn)")
            return
        }
        
        var tempLockedCells = lockedCells
        
        tempLockedCells.remove(startCell)
        tempLockedCells.remove(targetCell)
        world.unlock(cells: tempLockedCells)

        let newCreature = CreatureFactory.creature(from: self)
        world.add(creature: newCreature, at: targetCell)
        
        weak var world = self.world
        visualDelegate.performAnimations(for: turn) { [weak self, world] in
            world?.unlock(cell: startCell)
            
            let nextTurn = Turn.born(newCreature: newCreature, cell: targetCell)
            completion()
            
            self?.visualDelegate.performAnimations(for: nextTurn) {
                world?.unlock(cell: targetCell)
                if case .paused(fromState: _) = newCreature.state.state {
                    newCreature.state.state = .paused(fromState: .idle)
                } else {
                    newCreature.start()
                }
            }
        }
    }
    
    private func performDie(turn: Turn,
                            lockedCells: Set<WorldCell>,
                            completion: @escaping ()->())
    {
        guard case let .die(creature: _, cell: cell) = turn else {
            assertionFailure("Turn is wrong type \(turn)")
            return
        }
        var tempLockedCells = lockedCells
        
        stop()
        
        tempLockedCells.remove(cell)
        world.unlock(cells: tempLockedCells)
        
        weak var world = self.world
        visualDelegate.performAnimations(for: turn) { [world] in
            world?.remove(creature: self, at: cell)
            world?.unlock(cell: cell)
            completion()
        }
    }
}
