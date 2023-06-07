//
//  CreatureAnimator.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import UIKit

let kAnimationKey = "kAnimationKey"
let kAnimationFinalTransform = "kAnimationFinalTransform"
let kTransformKey = "transform"

public class CreatureAnimator: NSObject
{
    public var cellSize: CGSize = .zero
    public var animationSpeed: Double = .zero
    
    //MARK: - Private vars

    private var animations = Array<CAAnimation>()
    private var completion: (() -> ())? = {}

    public let visualComponent: UIImageView

    //MARK: - Memory
    
    init(visualComponent: UIImageView)
    {
        self.visualComponent = visualComponent
    }

    //MARK: - Public methods

    public func play()
    {
        Utils.SafeDispatchMain {
            self.visualComponent.layer.activate()
        }
    }
    public func pause()
    {
        Utils.SafeDispatchMain {
            self.visualComponent.layer.pause()
        }
    }
    
    public func performAnimations(for turn: Turn,
                                  completionQueue: DispatchQueue,
                                  completion: @escaping ()->())
    {
        Utils.SafeDispatchMain { [weak self] in
            guard let self else {
                completion()
                return
            }
            self._performAnimations(for: turn) {
                if (turn.directions.to != .none && turn.directions.to != .multy) {
                    turn.creature.direction = turn.directions.to
                }
                completionQueue.async {
                    completion()
                }
            }
        }
    }
    
    //MARK: - Private methods
    
    private func _performAnimations(for turn: Turn, completion: @escaping ()->())
    {
        let layer = visualComponent.layer
        
        if layer.animation(forKey: kAnimationKey) != nil {
            layer.removeAllAnimations()
        }
        if layer.speed == 0 {
            layer.activate()
        }
        
        let animations = animations(for: turn, layer: layer)
        for animation: CAAnimation in animations {
            animation.delegate = self
        }
        guard let lastAnimation = animations.last as? CABasicAnimation else {
            assertionFailure("lastAnimation is empty for turn \(turn)")
            completion()
            return
        }
        lastAnimation.isRemovedOnCompletion = false
        lastAnimation.fillMode = CAMediaTimingFillMode.forwards

        let finalTransform = lastAnimation.value(forKey: kAnimationFinalTransform) as? CATransform3D
        assert(finalTransform != nil)
        
        let animationCompletion = { [weak layer, weak self] in
            layer?.removeAllAnimations()
            
            layer?.transform = finalTransform ?? CATransform3DIdentity
            
            let cellSize = self?.cellSize ?? .zero
            let centerX = CGFloat(turn.finalPosition.x) * cellSize.width + cellSize.width / 2.0;
            let centerY = CGFloat(turn.finalPosition.y) * cellSize.height + cellSize.height / 2.0;
            layer?.position = CGPoint(x: centerX, y: centerY)
            
            completion()
        }

        self.completion = animationCompletion

        self.animations = animations

        startNextAnimation()
    }
    
    private func startNextAnimation()
    {
        guard let nextAnimation = animations.first else {
            defer { completion = nil }
            completion?()
            return
        }

        animations.removeFirst()
        
        Utils.SafeDispatchMain {
            if self.visualComponent.layer.animation(forKey: kAnimationKey) != nil {
                self.visualComponent.layer.removeAnimation(forKey: kAnimationKey)
            }
            self.visualComponent.layer.add(nextAnimation, forKey: kAnimationKey)
        }
    }
    
    private func animations(for turn: Turn, layer: CALayer) -> Array<CAAnimation>
    {
        switch turn {
        case .empty:
            return AnimationsFactory.emptyAnimations(layer: layer,
                                                     duration: animationSpeed)
        case .move:
            return AnimationsFactory.moveAnimations(fromDirection: turn.directions.from,
                                                    toDirection: turn.directions.to,
                                                    layer: layer,
                                                    duration: animationSpeed,
                                                    cellSize: cellSize)
        case .eat:
            return AnimationsFactory.eatAnimations(fromDirection: turn.directions.from,
                                                   toDirection: turn.directions.to,
                                                   layer: layer,
                                                   duration: animationSpeed,
                                                   cellSize: cellSize)
        case .reproduce:
            return AnimationsFactory.reproduceAnimations(fromDirection: turn.directions.from,
                                                         toDirection: turn.directions.to,
                                                         layer: layer,
                                                         duration: animationSpeed,
                                                         cellSize: cellSize)
        case .born:
            return AnimationsFactory.bornAnimations(duration: animationSpeed,
                                                    cellSize: cellSize)
        case .die:
            return AnimationsFactory.dieAnimations(layer: layer,
                                                   duration: animationSpeed,
                                                   cellSize: cellSize)
        }
    }
    
    func animationsInterrupted()
    {
        animations.removeAll()
        defer { completion = nil }
        completion?()
        return
    }
}

extension CreatureAnimator: CAAnimationDelegate
{
    public func animationDidStart(_ anim: CAAnimation)
    {
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
    {
        if flag {
            startNextAnimation()
        } else {
            animationsInterrupted()
        }
    }
}
