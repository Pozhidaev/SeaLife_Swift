//
//  World.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import UIKit

public enum WorldCompletionReason {
    case empty
    case full
}

class World: WorldProtocol
{
    public private(set) var worldInfo: WorldInfo
    public private(set) var isPlaying: Bool = false

    public var speed: Double = 0 { didSet {
        withCreaturesLocked { creatures.forEach{ $0.setSpeed(speed) } }
    } }

    public weak var delegate: (any WorldDelegate)?
    public weak var visualDelegate: (any WorldVisualDelegate)?

    // MARK: Private vars

    private var creatures: Set<Creature> = Set()
    private var cells: [WorldCell] = Array()

    private var lockedCells: Set<WorldCell> = Set()

    private var lockedCellsLock: NSRecursiveLock = NSRecursiveLock()
    private var creaturesLock: NSRecursiveLock = NSRecursiveLock()
    private var cellsLock: NSRecursiveLock = NSRecursiveLock()

    // MARK: Memory

    required init(worldInfo: WorldInfo)
    {
        self.worldInfo = worldInfo
        self.cells = createCells(sizeX: worldInfo.horizontalSize, sizeY: worldInfo.verticalSize)
    }

    // MARK: Public methods

    public func play()
    {
        withCreaturesLocked {
            creatures.forEach{$0.start()}
        }
        isPlaying = true
    }

    public func stop()
    {
        withCreaturesLocked {
            creatures.forEach{$0.pause()}
        }
        isPlaying = false
    }

    public func reset()
    {
        stop()

        creatures.removeAll()
        lockedCells.removeAll()
        cells.forEach { $0.creature = nil }

        visualDelegate?.reset()

        createInitialCreatures()
    }

    // MARK: Cell methods

    public func unlock(cell: WorldCell)
    {
        unlock(cells: Set([cell]))
    }

    public func unlock(cells: Set<WorldCell>)
    {
        withLockedCellsLocked { cells.forEach { self.lockedCells.remove($0) } }
    }

    public func cell(for position: WorldPosition) -> WorldCell?
    {
        return cells(for: Set([position])).first
    }

    public func cells(for positions: Set<WorldPosition>) -> Set<WorldCell>
    {
        var tempCells = Set<WorldCell>()

        let indexes = IndexSet(positions
            .filter{worldInfo.isValid(position: $0)}
            .map{$0.y * worldInfo.horizontalSize + $0.x})
        indexes.forEach { tempCells.insert(cells[$0]) }

        withLockedCellsLocked {
            tempCells.subtract(lockedCells)
            lockedCells.formUnion(tempCells)
        }

        return tempCells
    }

    // MARK: Creature methods

    public func creature(for creatureType: any CreatureProtocol.Type) -> any CreatureProtocol
    {
        let creature = CreatureFactory.creature(type: creatureType, world: self)
        return creature
    }

    public func createInitialCreatures()
    {
        // For testing
//        let creature1 = creature(for: FishCreature.self)
//        let cell1 = cells.filter{ $0.position == WorldPosition(x: 0, y: 10)}.first!
//        add(creature: creature1, at: cell1)
//        addToVisual(creature: creature1, at: cell1)
//        let creature2 = creature(for: OrcaCreature.self)
//        let cell2 = cells.filter{ $0.position == WorldPosition(x: 5, y: 10)}.first!
//        add(creature: creature2, at: cell2)
//        addToVisual(creature: creature2, at: cell2)
//        return;

        let fishCreatures = (0..<worldInfo.fishCount).map{_ in
            return creature(for: FishCreature.self)
        }

        let orcaCreatures = (0..<worldInfo.orcaCount).map{_ in
            return creature(for: OrcaCreature.self)
        }

        var creatures: [any CreatureProtocol] = []
        creatures += fishCreatures
        creatures += orcaCreatures

        var freeCells = cells.shuffled()
        for creature in creatures {
            let cell = freeCells.removeLast()
            add(creature: creature, at: cell)
            addToVisual(creature: creature, at: cell)
            creature.state.setActive()
        }
    }

    public func add(creature: any CreatureProtocol, at cell: WorldCell)
    {
        assert(cell.creature == nil)
        creature.position = cell.position
        creature.setSpeed(speed)

        withCellsLocked {
            cell.creature = creature
        }

        withCreaturesLocked {
            guard let tCreature = creature as? Creature else { fatalError("type mismatch") }
            creatures.insert(tCreature)
        }
    }

    public func addToVisual(creature: any CreatureProtocol, at cell: WorldCell)
    {
        Utils.performOnMainAndWait {
            self.visualDelegate?.add(creature: creature, at: cell.position)
        }
    }

    public func remove(creature: any CreatureProtocol, at cell: WorldCell?)
    {
        if let cell {
            withCellsLocked {
                cell.creature = nil
            }
        }

        withCreaturesLocked {
            guard let tCreature = creature as? Creature else { fatalError("type mismatch") }
            creatures.remove(tCreature)

            if creatures.count == 0 {
                stop()
                delegate?.worldDidFinished(with: .empty)
            }
        }
    }

    public func removeFromVisual(creature: any CreatureProtocol)
    {
        Utils.performOnMainAndWait {
            self.visualDelegate?.remove(creature: creature)
        }
    }

    public func move(creature: any CreatureProtocol, fromCell: WorldCell, toCell: WorldCell)
    {
        withCellsLocked {
            toCell.creature = creature
            fromCell.creature = nil
            creature.position = toCell.position
        }
    }

    // MARK: Private methods

    private func withLockedCellsLocked(_ closure: () -> Void)
    {
        lockedCellsLock.lock()
        closure()
        lockedCellsLock.unlock()
    }
    private func withCellsLocked(_ closure: () -> Void)
    {
        cellsLock.lock()
        closure()
        cellsLock.unlock()
    }
    private func withCreaturesLocked(_ closure: () -> Void)
    {
        creaturesLock.lock()
        closure()
        creaturesLock.unlock()
    }

    private func createCells(sizeX: Int, sizeY: Int) -> [WorldCell]
    {
        return (0..<(sizeX * sizeY)).map{
            let cellPosition = WorldPosition(x: $0 % worldInfo.horizontalSize,
                                             y: $0 / worldInfo.horizontalSize)
            return WorldCell(position: cellPosition)
        }
    }
}
