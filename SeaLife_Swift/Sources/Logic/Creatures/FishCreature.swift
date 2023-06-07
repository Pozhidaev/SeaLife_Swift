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
    
    //MARK: Memory

    public required init(uuid: UUID = UUID(), deps: CreatureDeps)
    {
        super.init(deps: deps)
        direction = .right
    }
    
    //MARK: Methods

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

    override func possibleTurnPositions(from position: WorldPosition) -> Set<WorldPosition>
    {
        //return Set([position.right()])
        let movePositions = turnHelperClass.movePositionsFrom(position: position)
        let reproducePositions = turnHelperClass.reproducePositionsFrom(position: position)
        return movePositions.union(reproducePositions)
    }

    override func decideTurn(for cell: WorldCell?, possibleCells: Set<WorldCell>) -> Turn
    {
        guard let cell else {
            return Turn.empty(creature: self, cell: cell)
        }

        var turn: Turn?
        
        //try reproduce
        if turn == nil {
            if reproductivePoints >= Constants.Creature.fishReproductionPeriod {
                if let targetCell = possibleCells.filter(turnHelperClass.canReproduceFilter).randomElement() {
                    turn = Turn.reproduce(creature: self,
                                          startCell: cell,
                                          targetCell: targetCell)
                }
            }
        }
        //try move
        if turn == nil  {
            if let targetCell = possibleCells.filter(turnHelperClass.canMoveFilter).randomElement() {
                turn = Turn.move(creature: self,
                                 startCell: cell,
                                 targetCell: targetCell)
            }
        }
        //empty
        guard let turn else {
            return Turn.empty(creature: self, cell: cell)
        }

        return turn
    }
}
