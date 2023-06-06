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
            return UIImage(named:"Orca")
        case is FishCreature.Type:
            return UIImage(named:"Fish")
        default:
            assertionFailure("Image not exist for creature type \(creatureType)")
        }
        return nil
    }
}
