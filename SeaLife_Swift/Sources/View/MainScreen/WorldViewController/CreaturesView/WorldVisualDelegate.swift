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
    
    func redraw(toCellSize: CGSize)

    func add(creature: any CreatureProtocol,
             at position: WorldPosition)
    func remove(creature: any CreatureProtocol)
}
