//
//  UIImage+Creature.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import UIKit

extension UIImage
{
    static func image(for creature: any CreatureProtocol) -> UIImage?
    {
        if type(of: creature) == OrcaCreature.self {
            let image = UIImage(named:"Orca")
            return image
        } else if type(of: creature) == FishCreature.self {
            let image = UIImage(named:"Fish")
            return image
        }
        return nil
    }
}
