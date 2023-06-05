//
//  CreatureProtocol.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import Foundation

public protocol CreatureProtocol: AnyObject, Equatable, Hashable, CustomDebugStringConvertible
{
    var uuid: UUID { get }
    var position: WorldPosition { get set }
    var direction: Direction { get set }
    
    var world: WorldProtocol { get set }
    var visualDelegate: WorldVisualDelegate { get set }
    
    var state: CreatureState { get set }
    
    init(turnHelperClass: TurnHelperProtocol.Type,
         visualDelegate: any WorldVisualDelegate,
         world: any WorldProtocol)

    func setTimerTargetQueue(_ queue: DispatchQueue)
    func setSpeed(_ speed: Double)
    
    func start()
    func pause()
    func stop()
}

extension CreatureProtocol
{
    public var debugDescription: String {
        return debugDescription(indent: 0, caption: "\n======= Creature =======\n")
    }
    
    public func debugDescription(indent: Int = 0, caption: String = "") -> String {
        let indentString = String(repeating: " ", count: indent)

        var description = String()
        description.append(caption)
        description.append("\(indentString)Uuid: \(uuid)\n")
        description.append("\(indentString)Position: \(position)\n")
        description.append("\(indentString)Direction: \(direction)\n")
        return description
    }
}

extension CreatureProtocol
{
    public static func == (lhs: Self, rhs: Self) -> Bool
    {
        return lhs.uuid == rhs.uuid
    }
}

extension CreatureProtocol
{
    public func hash(into hasher: inout Hasher)
    {
        hasher.combine(uuid)
    }
}
