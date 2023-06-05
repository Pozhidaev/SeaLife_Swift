//
//  CreatureTimer.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import Foundation

public class CreatureTimer: CreatureTimerProtocol
{
    let milisecondsPerSec: Float = 1000
    
    private let timer: DispatchSourceTimer
    private let timerQueue: DispatchQueue = DispatchQueue(label: "timer")
    
    private var timerPausedCounter: Int
    
    public var handler: ()->() = {} { didSet {
        let workItem = DispatchWorkItem.init { self.handler() }
        timer.setEventHandler(handler: workItem)
    } }
    
    required init()
    {
        timer = DispatchSource.makeTimerSource(queue: timerQueue)
        timerPausedCounter = 0
        
        let startTime = DispatchTime.now()
        let intervalTime = DispatchTimeInterval.seconds(.zero)
        timer.schedule(deadline: startTime, repeating: intervalTime)
    }
    
    deinit
    {
        if timerPausedCounter <= 0 {
            for _ in timerPausedCounter...0 {
                timer.resume()
            }
        }
    }
    
    //MARK: Public
    
    public func setTargetQueue(_ targetQueue: DispatchQueue)
    {
        timerQueue.setTarget(queue: targetQueue)
    }
    
    public func setSpeed(_ speed: Double)
    {
        let intervalTime = DispatchTimeInterval.milliseconds( Int(Float(speed) * milisecondsPerSec) )
        let randomDelta = DispatchTimeInterval.milliseconds( Int(arc4random_uniform(UInt32(Float(speed) * milisecondsPerSec))) )
        let startTime = DispatchTime.now().advanced(by: randomDelta).advanced(by: intervalTime)
        timer.schedule(deadline: startTime, repeating: intervalTime)
    }
    
    public func start()
    {
        if timerPausedCounter <= 0 {
            timerPausedCounter += 1
            timer.resume()
        }
    }
    
    public func stop()
    {
        timer.cancel()
    }
    
    public func pause()
    {
        if timerPausedCounter > 0 {
            timerPausedCounter -= 1
            timer.suspend()
        }
    }

}
