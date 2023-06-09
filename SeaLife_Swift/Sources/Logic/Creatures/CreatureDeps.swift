//
//  CreatureDeps.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 06.06.2023.
//

import Foundation

public struct CreatureDeps
{
    unowned var world: any WorldProtocol
    var turnHelperClass: TurnHelperProtocol.Type
    var turnFactoryType: TurnFactoryProtocol.Type
}
