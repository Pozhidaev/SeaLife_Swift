//
//  CreatureDeps.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 06.06.2023.
//

import UIKit

public struct CreatureDeps
{
    unowned var world: any WorldProtocol
    var visualComponent: UIImageView
    var animator: AnimationsController
    var turnHelperClass: TurnHelperProtocol.Type
}
