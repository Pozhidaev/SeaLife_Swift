//
//  CreatureVisualComponent.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 09.06.2023.
//

import UIKit

public class CreatureVisualComponent
{
    let imageName: String
    let content: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()

    // MARK: - Public computed properties

    var layer: CALayer { content.layer }
    var view: UIView { content }

    var center: CGPoint {
        get { content.center }
        set { content.center = newValue }
    }
    var bounds: CGRect {
        get { content.bounds }
        set { content.bounds = newValue }
    }

    // MARK: - Memory

    init(imageName: String, size: CGSize)
    {
        self.imageName = imageName

        let convertedSize = convertedSize(from: size)
        content.image = UIImage(named: imageName)?.resized(to: convertedSize)
        content.sizeToFit()
    }

    // MARK: - Public Methods

    func redraw(to newSize: CGSize)
    {
        let convertedSize = convertedSize(from: newSize)
        content.image = UIImage(named: imageName)?.resized(to: convertedSize)

        let oldCenter = center
        content.sizeToFit()
        center = oldCenter
    }

    func redraw()
    {
        redraw(to: bounds.size)
    }

    // MARK: - Private Methods

    func convertedSize(from size: CGSize) -> CGSize
    {
        var correctedSize = size
        if correctedSize.width > Constants.UI.imageViewMinSizeForReducing {
            correctedSize.width *= 1.0 - Constants.UI.imageViewReducingCoeficient
            correctedSize.height *= 1.0 - Constants.UI.imageViewReducingCoeficient
        }
        return correctedSize
    }
}
