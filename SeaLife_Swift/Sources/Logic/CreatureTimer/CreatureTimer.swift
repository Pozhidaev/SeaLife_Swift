//
//  CreatureTimer.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import Foundation

public class CreatureTimer: CreatureTimerProtocol
{
    let milisecondsPerSec: Double = 1000

    private let timer: DispatchSourceTimer
    private let queue: DispatchQueue

    private var timerPausedCounter: Int

    public var handler: () -> Void = {} { didSet {
        let workItem = DispatchWorkItem.init { [weak self] in
            self?.handler()
        }
        timer.setEventHandler(handler: workItem)
    } }

    required init(targetQueue: DispatchQueue)
    {
        self.queue = DispatchQueue(label: "timer_private_queue", attributes: .initiallyInactive)
        self.queue.setTarget(queue: targetQueue)
        self.queue.activate()

        self.timer = DispatchSource.makeTimerSource(queue: queue)
        self.timerPausedCounter = 0

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

    // MARK: Public

    public func setSpeed(_ speed: Double)
    {
        let intervalTime = DispatchTimeInterval.milliseconds( Int(speed * milisecondsPerSec) )
        let randomDelta = DispatchTimeInterval.milliseconds( Int.random(in: 0...Int(speed * milisecondsPerSec) ) )
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
