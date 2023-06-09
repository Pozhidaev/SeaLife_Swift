//
//  UIImage+Creature.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import UIKit

extension UIImage
{
    static func image(for creatureType: any CreatureProtocol.Type) -> UIImage?
    {
        switch creatureType {
        case is OrcaCreature.Type:
            return Images.orca.image
        case is FishCreature.Type:
            return Images.fish.image
        default:
            assertionFailure("Image not exist for creature type \(creatureType)")
        }
        return nil
    }

    static func name(for creatureType: any CreatureProtocol.Type) -> String?
    {
        switch creatureType {
        case is OrcaCreature.Type:
            return Images.orca.name
        case is FishCreature.Type:
            return Images.fish.name
        default:
            assertionFailure("Image not exist for creature type \(creatureType)")
        }
        return nil
    }
}
