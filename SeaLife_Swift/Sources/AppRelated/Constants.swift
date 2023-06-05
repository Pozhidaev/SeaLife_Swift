//
//  Constants.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import Foundation

enum Constants
{
    enum UI
    {
        static let defaultCornerRadius: CGFloat      = 8.0
        static let defaultElementsSpacing: CGFloat   = 8.0

        enum MainScreen
        {
            static let controlPanelViewBorderWidth   = 1.0
        }
        
        enum MenuScreen
        {
            static let menuViewBorderWidth: CGFloat  = 1.0
            static let menuViewCornerRadius: CGFloat = 16.0
        }
        
        enum WorldBackground
        {
            static let worldBackgroundViewBorderLineWidth   = 2.0
            static let worldBackgroundViewCellLineWidth     = 1.0
            static let worldBackgroundViewMaxVerticalSizeForDrawingGridIphone  = 15
            static let worldBackgroundViewMaxVerticalSizeForDrawingGridIpad    = 50
        }
        
        static let imageViewMinSizeForReducing         = 10.0
        static let imageViewReducingCoeficient         = 0.1
        
    }

    enum World
    {
        static let worldSizeApectRatio: Float      = 1.5
        
        static let horizontalSizeMin: Int          = 1
        static let horizontalSizeMax: Int          = 50
        static let horizontalSizeDefault: Int      = 10
        
        static let verticalSizeMin: Int            = 1
        static let verticalSizeMax: Int            = 50
        static let verticalSizeDefault: Int        = 15
        
        static let defaultfishCount                = 50
        static let defaultOrcaCount                = 10
    }
    
    enum Speed
    {
        static let creatureSlowestSpeed: Double    = 2.0
        static let creatureFastestSpeed: Double    = 0.1
        static let creatureDefaultSpeed: Double    = 0.5

        static let animationSlowestSpeed: Double   = 4.0
        static let animationFastestSpeed: Double   = 0.1
        static let animationDefaultSpeed: Double   = 0.5
    }

    enum Creature
    {
        static let orcaReproductionPeriod = 4
        static let fishReproductionPeriod = 10

        static let orcaAllowedHungerPoins = 3
    }
}

