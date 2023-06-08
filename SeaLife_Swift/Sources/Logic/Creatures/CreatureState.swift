//
//  CreatureState.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 23.05.2023.
//

import Foundation

public indirect enum CreatureStateEnum {
    case initial
    case idle
    case performing
    case haveNext(item: DispatchWorkItem)
    case paused(fromState: CreatureStateEnum)
    case dead
}

public final class CreatureState
{
    public var state: CreatureStateEnum = .initial

    // on completion |haveNext|->|performing|->|idle|
    public func setNextOnCompletion()
    {
        switch state {
        case .initial:
            break
        case .idle:
            break
        case .performing:
            state = .idle
        case .haveNext(let item):
            state = .performing
            item.perform()
        case .paused:
            state = .paused(fromState: .idle)
        case .dead:
            break
        }
    }

    // on handle turn |idle|->|performing|->|haveNext|
    public func setNextOnHandle(item: DispatchWorkItem)
    {
        switch state {
        case .initial:
            break
        case .idle:
            state = .performing
            item.perform()
        case .performing:
            state = .haveNext(item: item)
        case .haveNext:
            break
        case .paused:
            break
        case .dead:
            break
        }
    }

    public func setDead()
    {
        state = .dead
    }

    public func setActive()
    {
        if case .initial = state {
            state = .idle
            return
        }
        if case .paused(fromState: let fromState) = state {
            state = fromState
        }
    }

    public func setPause()
    {
        if case .paused = state {
            return
        }
        state = .paused(fromState: state)
    }

    var isInitial: Bool {
        if case .initial = state {
            return true
        }
        return false
    }
}
