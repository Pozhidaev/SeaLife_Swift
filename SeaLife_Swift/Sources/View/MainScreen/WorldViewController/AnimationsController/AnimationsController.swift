//
//  AnimationsController.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import UIKit

let kAnimationCompletionKey = "kAnimationCompletionKey"
let kAnimationPreparationKey = "kAnimationPreparationKey"

let kAnimationKey = "kAnimationKey"
let kAnimationUUIDKey = "kAnimationUUIDKey"

let kAnimationFinalTransform = "kAnimationFinalTransform"
let kTransformKey = "transform"

public class AnimationsController: NSObject
{
    public var cellSize: CGSize = .zero
    public var animationSpeed: Double = .zero
    
    //MARK: Private vars

    private var animationsDictionary = [UUID: Array<CAAnimation>]()
    private var completionsDictionary = [UUID: () -> ()]();
    private var layersDictionary = [UUID: CALayer]();

    //MARK: Public methods

    public func play()
    {
        layersDictionary.values.forEach{ $0.activate() }
    }
    public func stop()
    {
        layersDictionary.values.forEach{ $0.pause() }
    }
    
    public func reset()
    {
        animationsDictionary.removeAll()
        completionsDictionary.removeAll()
        layersDictionary.removeAll()
    }
    
    public func removeAllAnimations(for creature: any CreatureProtocol)
    {
        animationsDictionary[creature.uuid] = nil
        completionsDictionary[creature.uuid] = nil
        layersDictionary[creature.uuid] = nil
    }
    
    public func performAnimations(for turn: Turn, completion: @escaping ()->())
    {
        Utils.SafeDispatchMain {
            let layer = turn.creature.visualComponent.layer
            self.performAnimations(
                for: turn,
                layer: layer
            ) {
                if (turn.directions.to != .none && turn.directions.to != .multy) {
                    turn.creature.direction = turn.directions.to
                }
                completion()
            }
        }
    }
    
    public func performAnimations(for turn: Turn, layer: CALayer, completion: @escaping ()->())
    {
        if layer.animation(forKey: kAnimationKey) != nil {
            layer.removeAllAnimations()
        }
        if layer.speed == 0 {
            layer.activate()
        }
        
        let animations = animations(for: turn, layer: layer)
        for animation: CAAnimation in animations {
            animation.delegate = self
            animation.setValue(turn.creature.uuid, forKey: kAnimationUUIDKey)
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

        layersDictionary[turn.creature.uuid] = layer

        completionsDictionary[turn.creature.uuid] = animationCompletion
        
        animationsDictionary[turn.creature.uuid] = animations

        startNextAnimations(for: turn.creature.uuid)
    }
    
    //MARK: Private methods
    
    private func startNextAnimations(for creatureUUID: UUID)
    {
        guard let animationsArray = animationsDictionary[creatureUUID],
              let nextAnimation = animationsArray.first else
        {
            layersDictionary[creatureUUID] = nil
            animationsDictionary[creatureUUID] = nil
            if let completion = completionsDictionary[creatureUUID] {
                completionsDictionary[creatureUUID] = nil
                completion()
            }
            return
        }

        animationsDictionary[creatureUUID] = Array(animationsArray.dropFirst())
        Utils.SafeDispatchMain {
            guard let layer = self.layersDictionary[creatureUUID] else {
                fatalError("Layer is nil for creature uuid \(creatureUUID)")
            }
            if layer.animation(forKey: kAnimationKey) != nil {
                layer.removeAllAnimations()
            }
            layer.add(nextAnimation, forKey: kAnimationKey)
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
    
}

extension AnimationsController: CAAnimationDelegate
{
    public func animationDidStart(_ anim: CAAnimation)
    {
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
    {
        guard let creatureUUID: UUID = anim.value(forKey: kAnimationUUIDKey) as? UUID else {
            assertionFailure("creatureUUID value is nil in animation \(anim)")
            return
        }

        startNextAnimations(for: creatureUUID)
    }
}
