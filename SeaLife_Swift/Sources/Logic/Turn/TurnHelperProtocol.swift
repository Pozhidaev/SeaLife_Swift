//
//  TurnHelperProtocol.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import Foundation

public protocol TurnHelperProtocol
{
    // positions rules
    static func movePositionsFrom(position: WorldPosition) -> Set<WorldPosition>
    static func reproducePositionsFrom(position: WorldPosition) -> Set<WorldPosition>
    static func eatPositionsFrom(position: WorldPosition) -> Set<WorldPosition>

    // turn rules
    static func canMoveFilter(cell: WorldCell) -> Bool
    static func canReproduceFilter(cell: WorldCell) -> Bool
    static func canEatFilterFor(creature: any CreatureProtocol) -> (WorldCell) -> Bool
}
