//
//  WorldDelegate.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import Foundation

public protocol WorldDelegate: AnyObject
{
    func worldDidFinished(with reason: WorldCompletionReason)
}
