//
//  WorldVisualDelegate.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import UIKit

public protocol WorldVisualDelegate: AnyObject
{
    var animationSpeed: Double { get set}
        
    func reset()

    func animator(for creatureType: any CreatureProtocol.Type, creatureUUID: UUID) -> CreatureAnimator

    func visualComponent(for creatureType: any CreatureProtocol.Type) -> UIImageView

    func placeVisualComponent(of creature: any CreatureProtocol,
                              at position: WorldPosition)

    func removeVisualComponent(for creature: any CreatureProtocol)
    
    func redraw(toCellSize: CGSize)
}
