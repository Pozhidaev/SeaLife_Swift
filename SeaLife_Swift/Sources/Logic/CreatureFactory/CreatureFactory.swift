//
//  CreatureFactory.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import Foundation

class CreatureFactory
{
    static let timerParentQueue = DispatchQueue(label: "Timer Paranet Queue", attributes: .concurrent)

    static func turnHelperType(for creatureType: any CreatureProtocol.Type) -> TurnHelperProtocol.Type
    {
        switch creatureType {
        case is OrcaCreature.Type: return TurnHelper.self
        case is FishCreature.Type: return TurnHelper.self
        default:
            fatalError("Unpredictable creature type \(creatureType.self)")
        }
    }

    static func creature<T: CreatureProtocol>(uuid: UUID = UUID(), type: T.Type, deps: CreatureDeps) -> T
    {
        let creature = type.init(uuid: uuid, deps: deps)

        creature.setTimerTargetQueue(timerParentQueue)

        return creature
    }

    static func orcaCreature(deps: CreatureDeps) -> OrcaCreature
    {
        let creature = OrcaCreature.init(deps: deps)
        return creature
    }

    static func fishCreature(deps: CreatureDeps) -> FishCreature
    {
        let creature = FishCreature.init(deps: deps)
        return creature
    }
}
