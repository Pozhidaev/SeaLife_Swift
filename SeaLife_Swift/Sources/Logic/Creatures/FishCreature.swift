//
//  FishCreature.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import Foundation

class FishCreature: Creature
{
    var reproductivePoints: Int = .zero

    // MARK: Memory

    public required init(uuid: UUID = UUID(), deps: CreatureDeps)
    {
        super.init(deps: deps)
        direction = .right
    }

    // MARK: Methods

    override func beforeEveryTurn()
    {
        reproductivePoints += 1
    }

    override func afterEveryTurn()
    {
        if reproductivePoints >= Constants.Creature.fishReproductionPeriod {
            reproductivePoints = 0
        }
    }

    override func decideTurn(for cell: WorldCell?, possibleCells: Set<WorldCell>) -> Turn
    {
        guard let cell else {
            return Turn.empty(creature: self, cell: nil)
        }

        // try reproduce
        if reproductivePoints >= Constants.Creature.fishReproductionPeriod
        {
            if let targetCell = possibleCells.filter({ cell in cell.creature == nil }).randomElement() {
                return Turn.reproduce(creature: self,
                                      startCell: cell,
                                      targetCell: targetCell)
            }
        }

        // try move
        if let targetCell = possibleCells.filter({ cell in cell.creature == nil }).randomElement() {
            return Turn.move(creature: self,
                             startCell: cell,
                             targetCell: targetCell)
        }

        // empty
        return Turn.empty(creature: self, cell: cell)
    }
}
