//
//  WorldVisualDelegate.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import UIKit

public protocol WorldVisualDelegate: AnyObject
{
    func play()
    func stop()
    func reset()
    
    func setAnimationsSpeed(_ speed: Double)
    
    func visualComponent(for creatureType: any CreatureProtocol.Type) -> UIImageView

    func place(visualComponent: UIImageView,
               for creature: any CreatureProtocol,
               at position: WorldPosition)

    func removeVisualComponent(for creature: any CreatureProtocol)

    func performAnimations(for turn: Turn, completion: @escaping ()->())
    
    func redraw(toCellSize: CGSize)
}
