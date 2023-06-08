//
//  WorldCell.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import Foundation

public class WorldCell
{
    public let position: WorldPosition
    public weak var creature: (any CreatureProtocol)?

    init(position: WorldPosition) {
        self.position = position
    }
}

extension WorldCell: Equatable
{
    public static func == (lhs: WorldCell, rhs: WorldCell) -> Bool
    {
        return lhs.position == rhs.position
    }
}

extension WorldCell: Hashable
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(position)
    }
}

extension WorldCell: CustomDebugStringConvertible
{
    public var debugDescription: String {
        return debugDescription(indent: 0, caption: "\n======= Cell =======\n")
    }

    public func debugDescription(indent: Int = 0, caption: String = "") -> String {
        let indentString = String(repeating: " ", count: indent)

        var description = String()
        description.append("\(indentString)Position: \(position)\n")
//        description.append("\(indentString)Creature: \(String(describing: creature))\n")
        return description
    }
}
