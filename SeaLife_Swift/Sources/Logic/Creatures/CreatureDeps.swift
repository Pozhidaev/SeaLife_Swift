//
//  CreatureDeps.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 06.06.2023.
//

import Foundation

public struct CreatureDeps
{
    var world: (any WorldProtocol)
    var turnFactoryType: TurnFactoryProtocol.Type

    var timersTargetQueue: DispatchQueue
    var creaturesTargetQueue: DispatchQueue
}
