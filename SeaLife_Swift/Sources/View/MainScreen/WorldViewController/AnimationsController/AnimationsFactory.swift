//
//  AnimationsFactory.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import UIKit

class AnimationsFactory
{
    static func emptyAnimations(layer: CALayer,
                                duration: Double) -> Array<CAAnimation>
    {
        let rotate1Transform = CATransform3DRotate(layer.transform, (Double.pi / 4) * 0.2, 0.0, 0.0, 1.0)
        let rotate1Animation = CABasicAnimation(keyPath:kTransformKey)
        rotate1Animation.fromValue = NSValue(caTransform3D:layer.transform)
        rotate1Animation.toValue = NSValue(caTransform3D:rotate1Transform)
        rotate1Animation.duration = duration / 3.0

        let rotate2Transform = CATransform3DRotate(layer.transform, -(Double.pi / 4) * 0.4, 0.0, 0.0, 1.0)
        let rotate2Animation = CABasicAnimation(keyPath:kTransformKey)
        rotate2Animation.fromValue = NSValue(caTransform3D:rotate1Transform)
        rotate2Animation.toValue = NSValue(caTransform3D:rotate2Transform)
        rotate2Animation.duration = duration / 3.0

        let rotate3Animation = CABasicAnimation(keyPath:kTransformKey)
        rotate3Animation.fromValue = NSValue(caTransform3D:rotate2Transform)
        rotate3Animation.toValue = NSValue(caTransform3D:layer.transform)
        rotate3Animation.duration = duration / 3.0
        
        rotate3Animation.setValue(layer.transform, forKey: kAnimationFinalTransform)
        return [rotate1Animation, rotate2Animation, rotate3Animation]
    }
                                                 
    static func moveAnimations(fromDirection: Direction,
                               toDirection: Direction,
                               layer: CALayer,
                               duration: Double,
                               cellSize:CGSize) -> Array<CAAnimation>
    {
        let rotateCount = fromDirection.rawValue - toDirection.rawValue
        let rotateTransform = CATransform3DRotate(layer.transform, (Double.pi / 2) * Double(rotateCount), 0.0, 0.0, 1.0)
        let rotateAnimation = CABasicAnimation(keyPath:kTransformKey)
        rotateAnimation.fromValue = NSValue(caTransform3D:layer.transform)
        rotateAnimation.toValue = NSValue(caTransform3D:rotateTransform)
        rotateAnimation.duration = duration / 2.0
        
        let moveTransform = CATransform3DTranslate(rotateTransform, cellSize.width, 0.0, 0.0)
        let moveAnimation = CABasicAnimation(keyPath:kTransformKey)
        moveAnimation.fromValue = NSValue(caTransform3D:rotateTransform)
        moveAnimation.toValue = NSValue(caTransform3D:moveTransform)
        moveAnimation.duration = duration / 2.0
        
        moveAnimation.setValue(rotateTransform, forKey: kAnimationFinalTransform)
        return [rotateAnimation, moveAnimation]
    }
    
    static func reproduceAnimations(fromDirection: Direction,
                                    toDirection: Direction,
                                    layer: CALayer,
                                    duration: Double,
                                    cellSize:CGSize) -> Array<CAAnimation>
    {
        let rotateCount = fromDirection.rawValue - toDirection.rawValue
        let rotateTransform = CATransform3DRotate(layer.transform, (Double.pi / 2) * Double(rotateCount), 0.0, 0.0, 1.0)
        let rotateAnimation = CABasicAnimation(keyPath:kTransformKey)
        rotateAnimation.fromValue = NSValue(caTransform3D:layer.transform)
        rotateAnimation.toValue = NSValue(caTransform3D:rotateTransform)
        rotateAnimation.duration = duration / 3.0
        
        let scaleUpTransform = CATransform3DScale(rotateTransform, 1.3, 1.3, 1.0)
        let scaleUpAnimation = CABasicAnimation(keyPath:kTransformKey)
        scaleUpAnimation.fromValue = NSValue(caTransform3D:rotateTransform)
        scaleUpAnimation.toValue = NSValue(caTransform3D:scaleUpTransform)
        scaleUpAnimation.duration = duration / 3.0
        
        let scaleDownAnimation = CABasicAnimation(keyPath:kTransformKey)
        scaleDownAnimation.fromValue = NSValue(caTransform3D:scaleUpTransform)
        scaleDownAnimation.toValue = NSValue(caTransform3D:rotateTransform)
        scaleDownAnimation.duration = duration / 3.0
        
        scaleDownAnimation.setValue(rotateTransform, forKey: kAnimationFinalTransform)
        return [rotateAnimation, scaleUpAnimation, scaleDownAnimation]
    }
    
    static func eatAnimations(fromDirection: Direction,
                              toDirection: Direction,
                              layer: CALayer,
                              duration: Double,
                              cellSize:CGSize) -> Array<CAAnimation>
    {
        let rotateCount = fromDirection.rawValue - toDirection.rawValue
        let rotateTransform = CATransform3DRotate(layer.transform, (Double.pi / 2) * Double(rotateCount), 0.0, 0.0, 1.0)
        let rotateAnimation = CABasicAnimation(keyPath:kTransformKey)
        rotateAnimation.fromValue = NSValue(caTransform3D:layer.transform)
        rotateAnimation.toValue = NSValue(caTransform3D:rotateTransform)
        rotateAnimation.duration = duration / 2.0
        
        let moveTransform = CATransform3DTranslate(rotateTransform, cellSize.width, 0.0, 0.0)
        let moveAnimation = CABasicAnimation(keyPath:kTransformKey)
        moveAnimation.fromValue = NSValue(caTransform3D:rotateTransform)
        moveAnimation.toValue = NSValue(caTransform3D:moveTransform)
        moveAnimation.duration = duration / 2.0
        
        moveAnimation.setValue(rotateTransform, forKey: kAnimationFinalTransform)
        return [rotateAnimation, moveAnimation]
    }
    static func bornAnimations(duration: Double,
                               cellSize:CGSize) -> Array<CAAnimation>
    {
        let transform = CATransform3DMakeScale(0.2, 0.2, 1.0)
        let animation = CABasicAnimation(keyPath:kTransformKey)
        animation.fromValue = NSValue(caTransform3D:transform)
        animation.toValue = NSValue(caTransform3D:CATransform3DIdentity)
        animation.duration = duration
        
        animation.setValue(CATransform3DIdentity, forKey: kAnimationFinalTransform)
        return [animation]
    }
    static func dieAnimations(layer: CALayer,
                              duration: Double,
                              cellSize:CGSize) -> Array<CAAnimation>
    {
        let transform = CATransform3DScale(layer.transform, 0.2, 0.2, 1.0)
        let animation = CABasicAnimation(keyPath:kTransformKey)
        animation.fromValue = NSValue(caTransform3D:layer.transform)
        animation.toValue = NSValue(caTransform3D:transform)
        animation.duration = duration
        
        animation.setValue(transform, forKey: kAnimationFinalTransform)
        return [animation]
    }
}
