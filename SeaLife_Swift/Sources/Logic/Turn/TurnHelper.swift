//
//  TurnHelper.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import Foundation

class TurnHelper: TurnHelperProtocol
{
    static func movePositionsFrom(position: WorldPosition) -> Set<WorldPosition>
    {
        [position.right(), position.left(), position.up(), position.down()]
    }

    static func reproducePositionsFrom(position: WorldPosition) -> Set<WorldPosition>
    {
        movePositionsFrom(position: position)
    }

    static func eatPositionsFrom(position: WorldPosition) -> Set<WorldPosition>
    {
        movePositionsFrom(position: position)
    }
}

extension TurnHelper
{
    static func canMoveFilter(cell: WorldCell) -> Bool
    {
        cell.creature == nil
    }

    static func canReproduceFilter(cell: WorldCell) -> Bool
    {
        cell.creature == nil
    }

    static func canEatFilterFor(creature: any CreatureProtocol) -> (WorldCell) -> Bool
    {
        return { (cell: WorldCell) in
            if creature as? OrcaCreature != nil && cell.creature as? FishCreature != nil {
                return true
            }
            return false
        }
    }
}
