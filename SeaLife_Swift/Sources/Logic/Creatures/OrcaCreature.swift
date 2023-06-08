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

    override func possibleTurnPositions(from position: WorldPosition) -> Set<WorldPosition>
    {
        // return Set([position.left()])
        let movePositions = turnHelperClass.movePositionsFrom(position: position)
        let reproducePositions = turnHelperClass.reproducePositionsFrom(position: position)
        let eatPositions = turnHelperClass.eatPositionsFrom(position: position)
        return movePositions.union(reproducePositions).union(eatPositions)
    }

    override func decideTurn(for cell: WorldCell?, possibleCells: Set<WorldCell>) -> Turn
    {
        guard let cell else {
            return Turn.empty(creature: self, cell: nil)
        }

        var turn: Turn?

        // check live
        if hungerPoints < 0 {
            turn = Turn.die(creature: self, cell: cell)
        }
        // try reproduce
        if turn == nil {
            if reproductivePoints >= Constants.Creature.orcaReproductionPeriod {
                if let targetCell = possibleCells.filter(turnHelperClass.canReproduceFilter).randomElement() {
                    turn = Turn.reproduce(creature: self,
                                          startCell: cell,
                                          targetCell: targetCell)
                }
            }
        }
        // try eat
        if turn == nil  {
            if let targetCell = possibleCells.filter(turnHelperClass.canEatFilterFor(creature: self)).randomElement(),
               let targetCreature = targetCell.creature {
                turn = Turn.eat(creature: self,
                                startCell: cell,
                                targetCell: targetCell,
                                targetCreature: targetCreature)
            }
            if turn != nil {
                hungerPoints = Constants.Creature.orcaAllowedHungerPoins
            }
        }
        // try move
        if turn == nil  {
            if let targetCell = possibleCells.filter(turnHelperClass.canMoveFilter).randomElement() {
                turn = Turn.move(creature: self,
                                 startCell: cell,
                                 targetCell: targetCell)
            }
        }
        // empty
        guard let turn else {
            return Turn.empty(creature: self, cell: cell)
        }

        return turn
    }
}
