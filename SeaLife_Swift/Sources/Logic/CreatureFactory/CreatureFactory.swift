//
//  CreatureFactory.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import Foundation

class CreatureFactory
{
    static let timerParentQueue = DispatchQueue.global(qos: .default)
    static let creaturesParentQueue = DispatchQueue.global(qos: .userInitiated)

    static func turnFactoryType(for creatureType: any CreatureProtocol.Type) -> TurnFactoryProtocol.Type
    {
        switch creatureType {
        case is OrcaCreature.Type: return OrcaTurnFactory.self
        case is FishCreature.Type: return FishTurnFactory.self
        default:
            fatalError("Unpredictable creature type \(creatureType.self)")
        }
    }

    static func creature<T: CreatureProtocol>(uuid: UUID = UUID(),
                                              type: T.Type,
                                              world: World) -> T
    {
        let deps = CreatureDeps(
            world: world,
            turnFactoryType: turnFactoryType(for: type),
            timersTargetQueue: timerParentQueue,
            creaturesTargetQueue: creaturesParentQueue
        )

        let creature = type.init(uuid: uuid, deps: deps)

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
