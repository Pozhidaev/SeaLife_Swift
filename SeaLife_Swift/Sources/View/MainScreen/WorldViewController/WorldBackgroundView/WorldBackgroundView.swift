//
//  WorldBackgroundView.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import UIKit

class WorldBackgroundView: UIView
{
    public var sizeInCells: (width: Int, height: Int) = (width: .zero, height: .zero)

    override func draw(_ rect: CGRect) {
        guard sizeInCells.width != .zero && sizeInCells.height != .zero else {
            return
        }

        let borderLineWidth: CGFloat = Constants.UI.WorldBackground.borderLineWidth
        let cellLineWidth: CGFloat = Constants.UI.WorldBackground.cellLineWidth

        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)

        context?.setFillColor(Colors.WorldBackgroundView.backgroundColor.color.cgColor)
        context?.fill(rect)

        if (UIDevice.current.userInterfaceIdiom == .phone &&
            sizeInCells.height <= Constants.UI.WorldBackground.maxVerticalSizeForDrawingGridIphone) ||
            (UIDevice.current.userInterfaceIdiom == .pad &&
             sizeInCells.height <= Constants.UI.WorldBackground.maxVerticalSizeForDrawingGridIpad)
        {
            context?.setStrokeColor(Colors.WorldBackgroundView.cellsFrameColor.color.cgColor)
            context?.setLineWidth(cellLineWidth)

            let cellWidth: CGFloat = bounds.width / CGFloat(sizeInCells.width)
            let cellHeight: CGFloat = bounds.height / CGFloat(sizeInCells.height)

            for yStepper in 0...sizeInCells.height {
                let yPosition = min(CGFloat(yStepper) * cellHeight, self.bounds.height - cellLineWidth)
                context?.move(to: CGPoint(x: 0.0, y: yPosition))
                context?.addLine(to: CGPoint(x: self.bounds.width, y: yPosition))
                context?.strokePath()
            }

            for xStepper in 0...sizeInCells.width {
                let xPosition = min(CGFloat(xStepper) * cellWidth, self.bounds.width - cellLineWidth)
                context?.move(to: CGPoint(x: xPosition, y: 0.0))
                context?.addLine(to: CGPoint(x: xPosition, y: self.bounds.height))
                context?.strokePath()
            }
        }

        context?.setStrokeColor(Colors.WorldBackgroundView.frameColor.color.cgColor)
        context?.setLineWidth(borderLineWidth)
        context?.stroke(rect)
    }
}
