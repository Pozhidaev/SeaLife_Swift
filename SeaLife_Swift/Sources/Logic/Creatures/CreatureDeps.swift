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
    unowned var visualDelegate: any WorldVisualDelegate
    var visualComponent: UIImageView
    var turnHelperClass: TurnHelperProtocol.Type
}
