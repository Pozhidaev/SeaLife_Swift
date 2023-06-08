//
//  Utils.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import Foundation

class Utils
{
    static func safeDispatchMain(_ block: @escaping () -> Void)
    {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async {
                block()
            }
        }
    }

    static func performOnMainAndWait(_ performBlock: @escaping () -> Void)
    {
        let group = DispatchGroup()
        group.enter()
        self.safeDispatchMain {
            performBlock()
            group.leave()
        }
        group.wait()
    }
}
