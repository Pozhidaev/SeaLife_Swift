//
//  Turn.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import Foundation

public enum Turn {
    case empty(creature: any CreatureProtocol, cell: WorldCell?)
    case move(creature: any CreatureProtocol, startCell: WorldCell, targetCell: WorldCell)
    case eat(creature: any CreatureProtocol, startCell: WorldCell, targetCell: WorldCell, targetCreature: any CreatureProtocol)
    case reproduce(creature: any CreatureProtocol, startCell: WorldCell, targetCell: WorldCell)
    case born(newCreature: any CreatureProtocol, cell: WorldCell)
    case die(creature: any CreatureProtocol, cell: WorldCell)
    
    public var directions: (from: Direction, to: Direction)
    {
        switch self {
        case .empty(creature: let creature, cell: _):
            return (creature.direction, .none)
        case .move(creature: let creature, startCell: let startCell, targetCell: let targetCell):
            return (creature.direction, targetCell.position.direction(from: startCell.position))
        case .eat(creature: let creature, startCell: let startCell, targetCell: let targetCell, targetCreature: _):
            return (creature.direction, targetCell.position.direction(from: startCell.position))
        case .reproduce(creature: let creature, startCell: let startCell, targetCell: let targetCell):
            return (creature.direction, targetCell.position.direction(from: startCell.position))
        case .born(newCreature: let creature, cell: _):
            return (creature.direction, .none)
        case .die(creature: let creature, cell: _):
            return (creature.direction, .none)
        }
    }
    
    public var creature: any CreatureProtocol
    {
        switch self {
        case .empty(creature: let creature, cell: _):
            return creature
        case .move(creature: let creature, startCell: _, targetCell: _):
            return creature
        case .eat(creature: let creature, startCell: _, targetCell: _, targetCreature: _):
            return creature
        case .reproduce(creature: let creature, startCell: _, targetCell: _):
            return creature
        case .born(newCreature: let newCreature, cell: _):
            return newCreature
        case .die(creature: let creature, cell: _):
            return creature
        }
    }
    
    public var finalPosition: WorldPosition
    {
        switch self {
        case .empty(creature: let creature, cell: _):
            return creature.position
        case .move(creature: _, startCell: _, targetCell: let targetCell):
            return targetCell.position
        case .eat(creature: _, startCell: _, targetCell: let targetCell, targetCreature: _):
            return targetCell.position
        case .reproduce(creature: let creature, startCell: _, targetCell: _):
            return creature.position
        case .born(newCreature: _, cell: let cell):
            return cell.position
        case .die(creature: _, cell: let cell):
            return cell.position
        }
    }
};
