import UIKit

public class CreaturesView: UIView
{
    //MARK: Private vers

    private var cellSize: CGSize = .zero {
        didSet { animationController.cellSize = cellSize }
    }

    private var imageViewsDictionary = [UUID: UIImageView]()
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
        imageViewsDictionary.removeAll()
        animationController.reset()
        
        subviews.forEach { $0.removeFromSuperview() }
    }

    public func setAnimationsSpeed(_ speed: Double)
    {
        animationController.animationSpeed = speed
    }
    
    public func createImageViews(for creatures: Set<Creature>)
    {
        for creature in creatures {
            createImageView(for: creature)
        }
    }
    
    public func createImageView(for creature: any CreatureProtocol)
    {
        let image = UIImage.image(for: creature)
        let imageView = UIImageView(image: image)

        var frame: CGRect = .zero
        frame.size = CGSizeMake(self.cellSize.width, self.cellSize.height)
        frame.origin = CGPointMake(self.cellSize.width * CGFloat(creature.position.x),
                                   self.cellSize.height * CGFloat(creature.position.y))
        var delta: CGFloat = .zero
        if frame.width > Constants.UI.imageViewMinSizeForReducing {
            delta = frame.width * Constants.UI.imageViewReducingCoeficient
        }
        imageView.frame = CGRectInset(frame, delta, delta)

        imageViewsDictionary[creature.uuid] = imageView
        addSubview(imageView)
    }
    
    public func removeImageView(for creature: any CreatureProtocol)
    {
        guard let imageView: UIImageView = imageViewsDictionary[creature.uuid] else {
            fatalError("image view must exist before removing")
        }
        imageView.removeFromSuperview()
        imageViewsDictionary[creature.uuid] = nil
        animationController.removeAllAnimations(for: creature)
    }

    public func redraw(toCellSize: CGSize)
    {
        let fromCellSize = cellSize != CGSizeZero ? cellSize : toCellSize

        let xCoeficient = toCellSize.width / fromCellSize.width
        let yCoeficient = toCellSize.height / fromCellSize.height
        
        for imageView in imageViewsDictionary.values {
            var bounds = imageView.bounds
            bounds.size = CGSize(width: bounds.size.width * xCoeficient, height: bounds.size.height * yCoeficient)
            imageView.bounds = bounds
            var center = imageView.center
            center = CGPoint(x: center.x * xCoeficient, y: center.y * yCoeficient)
            imageView.center = center
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
                self.createImageView(for: newCreature)
            }
        case .die(creature: let creature, cell: _):
            animationCompletion = {
                self.removeImageView(for: creature)
            }
        }
        
        Utils.SafeDispatchMain {
            animationPreparation()
            
            guard let imageView = self.imageViewsDictionary[turn.creature.uuid] else {
//                assertionFailure("CreaturesView: view for creature is nil before turn")
                animationCompletion()
                completion()
                return
            }
            self.animationController.performAnimations(for: turn, layer: imageView.layer) {
                if (turn.directions.to != .none && turn.directions.to != .multy) {
                    turn.creature.direction = turn.directions.to
                }
                animationCompletion()
                completion()
            }
        }
    }
}
