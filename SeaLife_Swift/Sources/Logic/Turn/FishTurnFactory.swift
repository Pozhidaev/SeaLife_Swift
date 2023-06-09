//
//  FishTurnFactory.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 09.06.2023.
//

import Foundation

public final class FishTurnFactory: TurnFactoryProtocol
{
    static func movePositionsFrom(position: WorldPosition) -> Set<WorldPosition>
    {
        [position.right(), position.left(), position.up(), position.down()]
    }

    static func reproducePositionsFrom(position: WorldPosition) -> Set<WorldPosition>
    {
        movePositionsFrom(position: position)
    }

    public static func possibleTurnPositions(from position: WorldPosition) -> Set<WorldPosition>
    {
        let movePositions = movePositionsFrom(position: position)
        let reproducePositions = reproducePositionsFrom(position: position)
        return movePositions.union(reproducePositions)
    }
}
