//
//  WorldViewController.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import UIKit

class WorldViewController: UIViewController
{
    public var creaturesSpeed: Double = 0 { didSet {
        world?.speed = creaturesSpeed
    } }
    public var animationSpeed: Double = 0 { didSet {
        creaturesView.animationSpeed = Double(animationSpeed)
    } }
    
    public weak var delegate: (any WorldViewControllerDelegate)?
    
    //MARK: Private vars
    
    private let backgroundView: WorldBackgroundView = {
        let view = WorldBackgroundView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .redraw
        return view
    }()
    
    private let creaturesView: CreaturesView = {
        let view = CreaturesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private var world: WorldProtocol?
    
    //MARK: Lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.addSubview(backgroundView)
        view.addSubview(creaturesView)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            creaturesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            creaturesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            creaturesView.topAnchor.constraint(equalTo: view.topAnchor),
            creaturesView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if world != nil {
            redrawCreatureView();
        }
    }
    
    //MARK: Public Methods
    
    public func play()
    {
        world?.play()
        creaturesView.play()
    }
    
    public func stop()
    {
        world?.stop()
        creaturesView.stop()
    }
    
    public func reset()
    {
        world?.reset()
    }
    
    public func createWorld(with worldInfo:WorldInfo)
    {
        world?.stop()
        
        world = World(worldInfo: worldInfo)
        world?.speed = creaturesSpeed
        world?.delegate = self
        world?.visualDelegate = creaturesView
        
        backgroundView.sizeInCells = worldInfo.size()
        backgroundView.setNeedsDisplay()
        
        creaturesView.reset()
        redrawCreatureView()
        
        world?.createInitialCreatures()
    }
    
    //MARK: Private Methods
    
    func redrawCreatureView()
    {
        guard let world else {
            return
        }
        let cellWidth = view.bounds.size.width / CGFloat(world.worldInfo.horizontalSize)
        let cellHeight = view.bounds.size.height / CGFloat(world.worldInfo.verticalSize)
        let newSize = CGSize(width: cellWidth, height: cellHeight)
        let oldSize = creaturesView.cellSize != .zero ? creaturesView.cellSize : newSize
        creaturesView.cellSize = newSize
        creaturesView.redraw(fromCellSize: oldSize, toCellSize: newSize)
    }
}

extension WorldViewController: WorldDelegate
{
    func worldDidFinished(with reason:WorldCompletionReason)
    {
        delegate?.worldViewController(self, didCompleteWith: reason)
    }
}

extension WorldViewController //UIContentContainer
{
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: nil, completion: {
            [weak self] UIViewControllerTransitionCoordinatorContext in
                guard let self, let world = self.world else {
                    return
                }
                let wasPlaying = world.isPlaying
                if wasPlaying { self.stop() }
                redrawCreatureView()
                if wasPlaying { self.play() }
        })
    }
}
