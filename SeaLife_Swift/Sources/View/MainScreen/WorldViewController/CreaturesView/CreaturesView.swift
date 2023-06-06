import UIKit

public class CreaturesView: UIView
{
    //MARK: Private vers

    private var cellSize: CGSize = .zero {
        didSet { animationController.cellSize = cellSize }
    }

    private lazy var animationController = {
        let animationController = AnimationsController()
        animationController.cellSize = self.cellSize
        return animationController
    }()
}

extension CreaturesView: WorldVisualDelegate
{
    public func play()
    {
        animationController.play()
    }
    public func stop()
    {
        animationController.stop()
    }
    
    public func reset()
    {
        animationController.reset()
        
        subviews.forEach { $0.removeFromSuperview() }
    }

    public func setAnimationsSpeed(_ speed: Double)
    {
        animationController.animationSpeed = speed
    }
    
    public func place(visualComponent: UIImageView,
                      for creature: any CreatureProtocol,
                      at position: WorldPosition)
    {
        visualComponent.center = CGPointMake(cellSize.width * (CGFloat(position.x) + 0.5),
                                             cellSize.height * (CGFloat(position.y) + 0.5))
        addSubview(visualComponent)
    }
    
    public func visualComponent(for creatureType: any CreatureProtocol.Type) -> UIImageView
    {
        let image = UIImage.image(for: creatureType)
        let imageView = UIImageView(image: image)

        var frame: CGRect = .zero
        frame.size = CGSizeMake(self.cellSize.width, self.cellSize.height)
        var delta: CGFloat = .zero
        if frame.width > Constants.UI.imageViewMinSizeForReducing {
            delta = frame.width * Constants.UI.imageViewReducingCoeficient
        }
        imageView.frame = CGRectInset(frame, delta, delta)
        
        return imageView
    }
    
    public func removeVisualComponent(for creature: any CreatureProtocol)
    {
        creature.visualComponent.removeFromSuperview()
        animationController.removeAllAnimations(for: creature)
    }

    public func redraw(toCellSize: CGSize)
    {
        let fromCellSize = cellSize != CGSizeZero ? cellSize : toCellSize

        let xCoeficient = toCellSize.width / fromCellSize.width
        let yCoeficient = toCellSize.height / fromCellSize.height
        
        for view in self.subviews {
            var bounds = view.bounds
            bounds.size = CGSize(width: bounds.size.width * xCoeficient, height: bounds.size.height * yCoeficient)
            view.bounds = bounds
            var center = view.center
            center = CGPoint(x: center.x * xCoeficient, y: center.y * yCoeficient)
            view.center = center
        }
        
        cellSize = toCellSize
    }
    
    public func performAnimations(for turn: Turn, completion: @escaping ()->())
    {
        var animationPreparation: ()->() = {}
        var animationCompletion: ()->() = {}
        
        switch turn {
        case .empty(creature: _, cell: _):
            break
        case .move(creature: _, startCell: _, targetCell: _):
            break
        case .eat(creature: _, startCell: _, targetCell: _, targetCreature: _):
            break
        case .reproduce(creature: _, startCell: _, targetCell: _):
            break
        case .born(newCreature: let newCreature, cell: _):
            animationPreparation = {
                self.place(visualComponent: newCreature.visualComponent,
                           for: newCreature,
                           at: newCreature.position)
            }
        case .die(creature: let creature, cell: _):
            animationCompletion = {
                self.removeVisualComponent(for: creature)
            }
        }
        
        Utils.SafeDispatchMain {
            animationPreparation()
            
            let layer = turn.creature.visualComponent.layer
            self.animationController.performAnimations(
                for: turn,
                layer: layer
            ) {
                if (turn.directions.to != .none && turn.directions.to != .multy) {
                    turn.creature.direction = turn.directions.to
                }
                animationCompletion()
                completion()
            }
        }
    }
}
