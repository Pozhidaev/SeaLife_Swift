//
//  Constants.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import Foundation

// swiftlint:disable type_name
// swiftlint:disable nesting
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
            static let borderLineWidth   = 2.0
            static let cellLineWidth     = 1.0
            static let maxVerticalSizeForDrawingGridIphone  = 15
            static let maxVerticalSizeForDrawingGridIpad    = 50
        }

        static let imageViewMinSizeForReducing         = 10.0
        static let imageViewReducingCoeficient         = 0.1

    }

    enum World
    {
        static let worldSizeApectRatio: Float      = 1.5

        static let horizontalSizeMin: Int          = 1
        static let horizontalSizeMax: Int          = 50
        static let horizontalSizeDefault: Int      = 12

        static let verticalSizeMin: Int            = 1
        static let verticalSizeMax: Int            = 50
        static let verticalSizeDefault: Int        = 18

        static let defaultfishCount                = 120
        static let defaultOrcaCount                = 50
    }

    enum Speed
    {
        static let creatureSlowestSpeed: Double    = 2.0
        static let creatureFastestSpeed: Double    = 0.1
        static let creatureDefaultSpeed: Double    = 0.1

        static let animationSlowestSpeed: Double   = 4.0
        static let animationFastestSpeed: Double   = 0.1
        static let animationDefaultSpeed: Double   = 0.4
    }

    enum Creature
    {
        static let orcaReproductionPeriod = 5
        static let fishReproductionPeriod = 7

        static let orcaAllowedHungerPoins = 4
    }
}
// swiftlint:enable type_name
// swiftlint:enable nesting
