//
//  MenuViewController.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import UIKit

let kUnwindToMainScreenSegueIdentifier = "kUnwindToMainScreenSegueIdentifier"

class MenuViewController: UIViewController
{
    private lazy var fishCountView = { SliderView.fromNib() }()
    private lazy var orcaCountView = { SliderView.fromNib() }()
    private lazy var horizontalCountView = { SliderView.fromNib() }()
    private lazy var verticalCountView = { SliderView.fromNib() }()

    private var startButton = UIButton()
    private var cancelButton = UIButton()

    private var horizontalSize: Int = Constants.World.horizontalSizeDefault
    private var verticalSize: Int = Constants.World.verticalSizeDefault
    private var orcaCount: Int = Constants.World.defaultOrcaCount
    private var fishCount: Int = Constants.World.defaultfishCount

    public private(set) var worldInfo: WorldInfo = WorldInfo.defaultInfo()
    
    //MARK: Lifecycle

    override func loadView()
    {
        let view = UIView()
        view.backgroundColor = UIColor.cyan;
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = Constants.UI.defaultElementsSpacing
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(fishCountView)
        stackView.addArrangedSubview(orcaCountView)
        stackView.addArrangedSubview(horizontalCountView)
        stackView.addArrangedSubview(verticalCountView)
        
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        
        var verticalMultiplier = 3.0
        if modalPresentationStyle == .fullScreen {
            verticalMultiplier = 10.0
            let marginsSpace = Constants.UI.defaultElementsSpacing
            view.layoutMargins = UIEdgeInsets(top: 0.0, left: marginsSpace * 10, bottom: 0.0, right: marginsSpace * 10)
        }

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: verticalMultiplier),

            startButton.topAnchor.constraint(greaterThanOrEqualTo: stackView.bottomAnchor),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cancelButton.topAnchor.constraint(greaterThanOrEqualTo: startButton.bottomAnchor, constant: Constants.UI.defaultElementsSpacing),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            
            view.layoutMarginsGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: cancelButton.bottomAnchor , multiplier: verticalMultiplier),
        ])
        
        self.view = view
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "MenuBackgroundColor")
        view.layer.borderWidth = Constants.UI.MenuScreen.menuViewBorderWidth
        view.layer.borderColor = UIColor(named: "MenuFrameColor")?.cgColor
        view.layer.cornerRadius = Constants.UI.MenuScreen.menuViewCornerRadius
        
        setupStartButton()
        setupCancelButton()

        setupSliders()

        recalculateCreatures()
        updateSliders()
    }
    
    func setupStartButton()
    {
        startButton.layer.cornerRadius = Constants.UI.defaultCornerRadius;
        startButton.backgroundColor = UIColor(named: "MenuStartButtonColor")
        startButton.contentEdgeInsets = UIEdgeInsets(top: Constants.UI.defaultElementsSpacing * 2.0,
                                                          left: Constants.UI.defaultElementsSpacing * 4.0,
                                                          bottom: Constants.UI.defaultElementsSpacing * 2.0,
                                                          right: Constants.UI.defaultElementsSpacing * 4.0);
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "MenuStartButtonTitle") ?? UIColor.darkText,
            .font: UIFont.systemFont(ofSize: 24.0)
        ]
        let attributedTitle = NSAttributedString(string: NSLocalizedString("Menu.Button.Start", comment:""), attributes: attributes)
        startButton.setAttributedTitle(attributedTitle, for: .normal)
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
    }
    
    func setupCancelButton()
    {
        cancelButton.layer.cornerRadius = Constants.UI.defaultCornerRadius;
        cancelButton.backgroundColor = UIColor(named: "MenuStartButtonColor")
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: Constants.UI.defaultElementsSpacing * 2.0,
                                                           left: Constants.UI.defaultElementsSpacing * 4.0,
                                                           bottom: Constants.UI.defaultElementsSpacing * 2.0,
                                                           right: Constants.UI.defaultElementsSpacing * 4.0);
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "MenuStartButtonTitle") ?? UIColor.darkText,
            .font: UIFont.systemFont(ofSize: 24.0)
        ]
        let attributedTitle = NSAttributedString(string: NSLocalizedString("Menu.Button.Cancel", comment:""), attributes: attributes)
        cancelButton.setAttributedTitle(attributedTitle, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
    }
    
    
    func setupSliders()
    {
        self.fishCountView.titleLabel.text = NSLocalizedString("Menu.FishCount.Title", comment:"")
        self.orcaCountView.titleLabel.text = NSLocalizedString("Menu.OrcaCount.Title", comment:"")
        self.horizontalCountView.titleLabel.text = NSLocalizedString("Menu.XSize.Title", comment:"")
        self.verticalCountView.titleLabel.text = NSLocalizedString("Menu.YSize.Title", comment:"")

        fishCountView.slider.addTarget(self, action: #selector(sliderValueChange), for: .valueChanged)
        orcaCountView.slider.addTarget(self, action: #selector(sliderValueChange), for: .valueChanged)
        horizontalCountView.slider.addTarget(self, action: #selector(sliderValueChange), for: .valueChanged)
        verticalCountView.slider.addTarget(self, action: #selector(sliderValueChange), for: .valueChanged)

        fishCountView.slider.minimumValue = .zero
        orcaCountView.slider.minimumValue = .zero
        
        horizontalCountView.slider.minimumValue = Float(Constants.World.horizontalSizeMin)
        horizontalCountView.slider.maximumValue = Float(Constants.World.horizontalSizeMax)
        verticalCountView.slider.minimumValue = Float(Constants.World.verticalSizeMin)
        verticalCountView.slider.maximumValue = Float(Constants.World.verticalSizeMax)
    }
    
    //MARK: Actions
    
    @IBAction func sliderValueChange(_ sender: UISlider)
    {
        let value = sender.value
        
        if (sender == fishCountView.slider) {
            setValidFishValue(from: value)
        } else if (sender == orcaCountView.slider) {
            setValidOrcaValue(from: value)
        } else if (sender == horizontalCountView.slider) {
            setValidHorizontalSize(from: value)
        } else if (sender == verticalCountView.slider) {
            setValidVerticalSize(from: value)
        }
        
        recalculateCreatures()
        updateSliders()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton)
    {
        dismiss(animated: true)
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton)
    {
        worldInfo = WorldInfo(fishCount: fishCount,
                              orcaCount: orcaCount,
                              verticalSize: verticalSize,
                              horizontalSize: horizontalSize)
        performSegue(withIdentifier: kUnwindToMainScreenSegueIdentifier, sender: nil)
    }
    
    //MARK: Private
    
    func recalculateCreatures()
    {
        let worldArea = horizontalSize * verticalSize
        fishCountView.slider.maximumValue = Float(worldArea)
        orcaCountView.slider.maximumValue = Float(worldArea)
        
        let totalCreaturesCount = fishCount + orcaCount

        if totalCreaturesCount > worldArea {
            let ratio = (Double(fishCount) / Double(orcaCount) )
            
            let roundedRation = floor(ratio * 100.0) / 100.0
            orcaCount = Int( Double(worldArea) / Double(1.0 + roundedRation) )
            fishCount = worldArea - orcaCount
        }
    }
    
    func setValidFishValue(from value:Float)
    {
        let worldArea = horizontalSize * verticalSize
        
        let fishCount = min(Int(value), worldArea)
        var orcaCount = orcaCount
        
        let totalCount = fishCount + orcaCount
        if totalCount > worldArea {
            orcaCount = worldArea - fishCount
        }
        
        self.orcaCount = orcaCount
        self.fishCount = fishCount
    }
    
    func setValidOrcaValue(from value:Float)
    {
        let worldArea = horizontalSize * verticalSize

        var fishCount = fishCount
        let orcaCount = min(Int(value), worldArea)
        
        let totalCount = fishCount + orcaCount
        if totalCount > worldArea {
            fishCount = worldArea - orcaCount
        }
        
        self.orcaCount = orcaCount
        self.fishCount = fishCount
    }
    
    func setValidHorizontalSize(from value: Float)
    {
        setValidateSizesFrom(horizontalSize: Double(value),
                             verticalSize: Double(value) * Double(Constants.World.worldSizeApectRatio))
    }
    
    func setValidVerticalSize(from value: Float)
    {
        setValidateSizesFrom(horizontalSize: Double(value) / Double(Constants.World.worldSizeApectRatio),
                             verticalSize: Double(value))
    }
  
    func setValidateSizesFrom(horizontalSize: Double, verticalSize: Double)
    {
        var tVertical = Float(verticalSize)
        var tHorizontal = Float(horizontalSize)
        
        tVertical = Float( min(Constants.World.verticalSizeMax,
                               Int( tHorizontal * Constants.World.worldSizeApectRatio)))
        tHorizontal = Float( min(Constants.World.horizontalSizeMax,
                                 Int( tVertical / Constants.World.worldSizeApectRatio)))
        tVertical = Float( max(Constants.World.verticalSizeMin,
                               Int( tHorizontal * Constants.World.worldSizeApectRatio)))
        tHorizontal = Float( max(Constants.World.horizontalSizeMin,
                                 Int( tVertical / Constants.World.worldSizeApectRatio)))
        
        self.horizontalSize = Int(lroundf(tHorizontal))
        self.verticalSize = Int(lroundf(tVertical))
    }
    
    func updateSliders()
    {
        fishCountView.slider.value = Float(fishCount)
        orcaCountView.slider.value = Float(orcaCount)
        horizontalCountView.slider.value = Float(horizontalSize)
        verticalCountView.slider.value = Float(verticalSize)
    }
}
