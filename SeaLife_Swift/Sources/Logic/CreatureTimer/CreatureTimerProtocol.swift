//
//  CreatureTimerProtocol.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import Foundation

protocol CreatureTimerProtocol: AnyObject
{
    init(targetQueue: DispatchQueue)

    var handler: () -> Void { get set }

    func setSpeed(_ speed: Double)

    func start()
    func stop()
    func pause()
}
