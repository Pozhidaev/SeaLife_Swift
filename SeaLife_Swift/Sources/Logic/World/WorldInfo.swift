//
//  WorldInfo.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 21.05.2023.
//

import Foundation

public struct WorldInfo {
    let fishCount: Int
    let orcaCount: Int
    let verticalSize: Int
    let horizontalSize: Int
    
    static func defaultInfo() -> WorldInfo
    {
        return WorldInfo(fishCount: Constants.World.defaultfishCount,
                         orcaCount: Constants.World.defaultOrcaCount,
                         verticalSize: Constants.World.verticalSizeDefault,
                         horizontalSize: Constants.World.horizontalSizeDefault)
    }
    
    func isValid(position: WorldPosition) -> Bool
    {
        return (position.x >= 0)
        && (position.x < self.horizontalSize)
        && (position.y >= 0)
        && (position.y < self.verticalSize)
    }
    
    func size() -> (width: Int, height: Int)
    {
        return (horizontalSize, verticalSize)
    }
}
