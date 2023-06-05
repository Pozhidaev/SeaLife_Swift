//
//  CreatureFactory.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import Foundation

class CreatureFactory
{
    static func creature(from creature: Creature) -> Creature
    {
        let newCreature = type(of: creature).init(
            turnHelperClass: TurnHelper.self,
            visualDelegate: creature.visualDelegate,
            world: creature.world
        )
        return newCreature
    }
    
    static func creature<T: CreatureProtocol>(type: T.Type, visualDelegate: any WorldVisualDelegate, world: any WorldProtocol) -> T
    {
        let newCreature = type.init(turnHelperClass: TurnHelper.self, visualDelegate: visualDelegate, world: world)
        return newCreature
    }
    
//    static func orcaCreature(visualDelegate: any WorldVisualDelegate, world: any WorldProtocol) -> OrcaCreature
//    {
//        return OrcaCreature(turnHelperClass: TurnHelper.self,
//                            visualDelegate: visualDelegate,
//                            world: world)
//    }
//    
//    static func fishCreature(visualDelegate: any WorldVisualDelegate, world: any WorldProtocol) -> FishCreature
//    {
//        return FishCreature(turnHelperClass: TurnHelper.self)
//    }
}
