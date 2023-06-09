//
//  TurnFactoryProtocol.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 09.06.2023.
//

import Foundation

public protocol TurnFactoryProtocol
{
    static func possibleTurnPositions(from position: WorldPosition) -> Set<WorldPosition>
}
