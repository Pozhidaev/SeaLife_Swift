//
//  WorldPosition.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import Foundation

public struct WorldPosition: Hashable {
    // swiftlint:disable identifier_name
    let x: Int
    let y: Int
    // swiftlint:enable identifier_name

    func right() -> WorldPosition { WorldPosition(x: x + 1, y: y) }
    func left() -> WorldPosition { WorldPosition(x: x - 1, y: y) }
    func up() -> WorldPosition { WorldPosition(x: x, y: y - 1) }
    func down() -> WorldPosition { WorldPosition(x: x, y: y + 1) }

    func direction(from otherPosition: WorldPosition) -> Direction {
        // swiftlint:disable statement_position
        if x < otherPosition.x { return Direction.left }
        else if x > otherPosition.x { return Direction.right }
        else if y < otherPosition.y { return Direction.up }
        else if y > otherPosition.y { return Direction.down }
        else { return Direction.none }
        // swiftlint:enable statement_position
    }

    static func zero() -> WorldPosition {
        return WorldPosition(x: 0, y: 0)
    }
}
