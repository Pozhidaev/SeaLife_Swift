//
//  OrcaCreature.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import Foundation

class OrcaCreature: Creature
{
    var hungerPoints: Int = Constants.Creature.orcaAllowedHungerPoins
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
        hungerPoints -= 1
    }

    override func afterEveryTurn()
    {
        if reproductivePoints >= Constants.Creature.orcaReproductionPeriod {
            reproductivePoints = 0
        }
    }

    override func decideTurn(for cell: WorldCell?, possibleCells: Set<WorldCell>) -> Turn
    {
        guard let cell else {
            return Turn.empty(creature: self, cell: nil)
        }

        // check live
        if hungerPoints < 0 {
            return Turn.die(creature: self, cell: cell)
        }

        // try reproduce
        if reproductivePoints >= Constants.Creature.orcaReproductionPeriod
        {
            if let targetCell = possibleCells.filter({ cell in cell.creature == nil }).randomElement() {
                return Turn.reproduce(creature: self,
                                      startCell: cell,
                                      targetCell: targetCell)
            }
        }

        // try eat
        if let targetCell = possibleCells.filter({
            ($0.creature != nil) && ($0.creature as? FishCreature) != nil
           }).randomElement(),
           let targetCreature = targetCell.creature
        {
            hungerPoints = Constants.Creature.orcaAllowedHungerPoins

            return Turn.eat(creature: self,
                            startCell: cell,
                            targetCell: targetCell,
                            targetCreature: targetCreature)
        }

        // try move
        if let targetCell = possibleCells.filter({ cell in cell.creature == nil }).randomElement()
        {
            return Turn.move(creature: self,
                             startCell: cell,
                             targetCell: targetCell)
        }

        // empty
        return Turn.empty(creature: self, cell: cell)
    }
}
