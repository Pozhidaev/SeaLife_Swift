//
//  CALayer+Extensions.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 05.06.2023.
//

import UIKit

extension CALayer
{
    func pause() {
        let pausedTime: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil)
        self.speed = .zero
        self.timeOffset = pausedTime
    }
    
    func activate() {
        let pausedTime: CFTimeInterval = self.timeOffset
        self.speed = 1.0;
        self.timeOffset = .zero;
        self.beginTime = .zero;
        let timeSincePause: CFTimeInterval = self.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.beginTime = timeSincePause
    }

}
