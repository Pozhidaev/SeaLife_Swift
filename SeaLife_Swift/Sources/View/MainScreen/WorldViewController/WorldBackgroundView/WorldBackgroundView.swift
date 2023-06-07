//
//  WorldBackgroundView.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import UIKit

class WorldBackgroundView : UIView
{
    public var sizeInCells: (width: Int, height: Int) = (width: .zero, height: .zero)
    
    override func draw(_ rect: CGRect) {
        guard sizeInCells.width != .zero && sizeInCells.height != .zero else {
            return
        }
        
        let borderLineWidth: CGFloat = Constants.UI.WorldBackground.worldBackgroundViewBorderLineWidth
        let cellLineWidth: CGFloat = Constants.UI.WorldBackground.worldBackgroundViewCellLineWidth

        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)

        context?.setFillColor(Colors.WorldBackgroundView.backgroundColor.color.cgColor)
        context?.fill(rect)

        if (UIDevice.current.userInterfaceIdiom == .phone && sizeInCells.height <= Constants.UI.WorldBackground.worldBackgroundViewMaxVerticalSizeForDrawingGridIphone) ||
            (UIDevice.current.userInterfaceIdiom == .pad && sizeInCells.height <= Constants.UI.WorldBackground.worldBackgroundViewMaxVerticalSizeForDrawingGridIpad) {
            context?.setStrokeColor(Colors.WorldBackgroundView.cellsFrameColor.color.cgColor)
            context?.setLineWidth(cellLineWidth)
            
            let cellWidth: CGFloat = CGRectGetWidth(bounds) / CGFloat(sizeInCells.width)
            let cellHeight: CGFloat = CGRectGetHeight(bounds) / CGFloat(sizeInCells.height)
            
            for y_stepper in 0...sizeInCells.height {
                let y = min(CGFloat(y_stepper) * cellHeight, CGRectGetHeight(self.bounds) - cellLineWidth)
                context?.move(to: CGPoint(x:  0.0, y: y))
                context?.addLine(to: CGPoint(x: CGRectGetWidth(self.bounds), y: y))
                context?.strokePath()
            }
            
            for x_stepper in 0...sizeInCells.width {
                let x = min(CGFloat(x_stepper) * cellWidth, CGRectGetWidth(self.bounds) - cellLineWidth)
                context?.move(to: CGPoint(x: x, y: 0.0))
                context?.addLine(to: CGPoint(x: x, y: CGRectGetHeight(self.bounds)))
                context?.strokePath()
            }
        }

        context?.setStrokeColor(Colors.WorldBackgroundView.frameColor.color.cgColor)
        context?.setLineWidth(borderLineWidth)
        context?.stroke(rect)
    }
}
