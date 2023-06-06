//
//  WorldProtocol.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import Foundation

public protocol WorldProtocol: AnyObject
{
    var worldInfo: WorldInfo { get }
    var isPlaying: Bool { get }

    var speed: Double { get set }
    
    var delegate: (any WorldDelegate)? { get set }
    var visualDelegate: (any WorldVisualDelegate)? { get set }
    
    init(worldInfo: WorldInfo)
    
    //control
    func play()
    func stop()
    func reset()
    
    //creatures
    func creature(for creatureType:any CreatureProtocol.Type) -> Creature
    func createInitialCreatures()
    func add(creature: any CreatureProtocol, at cell: WorldCell)
    func remove(creature: any CreatureProtocol, at cell: WorldCell)
    func move(creature: any CreatureProtocol, fromCell: WorldCell, toCell: WorldCell)

    //methods return cells that are not locked, and lock them
    func cell(for position: WorldPosition) -> WorldCell?
    func cells(for positions: Set<WorldPosition>) -> Set<WorldCell>

    func unlock(cell: WorldCell)
    func unlock(cells: Set<WorldCell>)
}
