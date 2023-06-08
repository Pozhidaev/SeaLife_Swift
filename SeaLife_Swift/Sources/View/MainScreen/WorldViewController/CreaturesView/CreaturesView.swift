import UIKit

public class CreaturesView: UIView, WorldVisualDelegate
{
    // MARK: - Private vers

    private var cellSize: CGSize = .zero {
        didSet {
            let enumerator = animatorsDict.objectEnumerator()
            while case let animator as CreatureAnimator = enumerator?.nextObject() {
                animator.cellSize = cellSize
            }
        }
    }

    private let animatorsDict = NSMapTable<NSUUID, CreatureAnimator>(valueOptions: .weakMemory)

    // MARK: - WorldVisualDelegate

    public var animationSpeed: Double = .zero { didSet {
        if animationSpeed == oldValue {
            return
        }

        let enumerator = animatorsDict.objectEnumerator()
        while case let animator as CreatureAnimator = enumerator?.nextObject() {
            animator.animationSpeed = animationSpeed
        }
    } }

    public func reset()
    {
        animatorsDict.removeAllObjects()
        subviews.forEach { $0.removeFromSuperview() }
    }

    public func add(creature: any CreatureProtocol, at position: WorldPosition)
    {
        let visualComponent = visualComponent(for: type(of: creature))

        visualComponent.center = CGPoint(x: cellSize.width * (CGFloat(position.x) + 0.5),
                                         y: cellSize.height * (CGFloat(position.y) + 0.5))
        addSubview(visualComponent)

        let animator = CreatureAnimator(visualComponent: visualComponent)
        add(animator: animator, for: creature.uuid)

        creature.animator = animator
    }

    public func remove(creature: any CreatureProtocol)
    {
        creature.animator?.visualComponent.removeFromSuperview()

        animatorsDict.removeObject(forKey: NSUUID(uuidString: creature.uuid.uuidString))
    }

    public func redraw(toCellSize: CGSize)
    {
        let fromCellSize = cellSize != CGSize.zero ? cellSize : toCellSize

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

    // MARK: - Private methods

    private func visualComponent(for creatureType: any CreatureProtocol.Type) -> UIImageView
    {
        let image = UIImage.image(for: creatureType)
        let imageView = UIImageView(image: image)

        var frame: CGRect = .zero
        frame.size = CGSize(width: self.cellSize.width, height: self.cellSize.height)
        var delta: CGFloat = .zero
        if frame.width > Constants.UI.imageViewMinSizeForReducing {
            delta = frame.width * Constants.UI.imageViewReducingCoeficient
        }
        imageView.frame = frame.insetBy(dx: delta, dy: delta)

        return imageView
    }

    private func add(animator: CreatureAnimator, for creatureUUID: UUID)
    {
        animator.cellSize = cellSize
        animator.animationSpeed = animationSpeed

        let key = NSUUID(uuidString: creatureUUID.uuidString)
        animatorsDict.setObject(animator, forKey: key)
    }
}
