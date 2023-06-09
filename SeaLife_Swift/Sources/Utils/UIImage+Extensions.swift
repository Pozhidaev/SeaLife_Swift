//
//  UIImage+Extensions.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 09.06.2023.
//

import UIKit

extension UIImage
{
    func resized(to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
