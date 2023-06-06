//
//  WorldVisualDelegate.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import Foundation

public protocol WorldVisualDelegate: AnyObject
{
    func play()
    func stop()
    func reset()
    
    func setAnimationsSpeed(_ speed: Double)
    
    func createImageViews(for creatures: Set<Creature>)
    func createImageView(for creature: any CreatureProtocol)
    func removeImageView(for creature: any CreatureProtocol)
    
    func performAnimations(for turn: Turn, completion: @escaping ()->())
    
    func redraw(fromCellSize: CGSize, toCellSize: CGSize)
}
