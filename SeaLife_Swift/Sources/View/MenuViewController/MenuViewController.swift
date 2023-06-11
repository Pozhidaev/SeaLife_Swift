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
    public private(set) var worldInfo: WorldInfo = WorldInfo.defaultInfo()

    // MARK: - Private variables

    private lazy var fishCountView = { SliderView.fromNib() }()
    private lazy var orcaCountView = { SliderView.fromNib() }()
    private lazy var horizontalCountView = { SliderView.fromNib() }()
    private lazy var verticalCountView = { SliderView.fromNib() }()

    private var startButton = UIButton()

    private var horizontalSize: Int = Constants.World.horizontalSizeDefault
    private var verticalSize: Int = Constants.World.verticalSizeDefault
    private var orcaCount: Int = Constants.World.defaultOrcaCount
    private var fishCount: Int = Constants.World.defaultfishCount

    private var compactHeightConstraints: [NSLayoutConstraint] = []
    private var regularConstraints: [NSLayoutConstraint] = []

    // MARK: - Lifecycle

    override func loadView()
    {
        let view = UIView()
        view.backgroundColor = UIColor.cyan

        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.UI.defaultElementsSpacing
        view.addSubview(stackView)

        stackView.addArrangedSubview(fishCountView)
        stackView.addArrangedSubview(orcaCountView)
        stackView.addArrangedSubview(horizontalCountView)
        stackView.addArrangedSubview(verticalCountView)

        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)

        var regularVerticalMultiplier = 3.0
        if modalPresentationStyle == .fullScreen {
            regularVerticalMultiplier = 10.0
        }
        regularConstraints = [
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: regularVerticalMultiplier),
            stackView.widthAnchor.constraint(equalTo: view.readableContentGuide.widthAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.readableContentGuide.centerXAnchor),

            self.startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: self.startButton.bottomAnchor, multiplier: regularVerticalMultiplier)
        ]

        compactHeightConstraints = [
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.startButton.leadingAnchor, constant: -Constants.UI.defaultElementsSpacing),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            self.startButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            self.startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]

        if traitCollection.verticalSizeClass == .compact {
            NSLayoutConstraint.activate(compactHeightConstraints)
        } else {
            NSLayoutConstraint.activate(regularConstraints)
        }

        self.view = view
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupView()

        recalculateCreatures()

        updateSliders()
    }

    func setupView()
    {
        view.backgroundColor = Colors.MenuView.backgroundColor.color
        view.layer.borderWidth = Constants.UI.MenuScreen.menuViewBorderWidth
        view.layer.borderColor = Colors.MenuView.frameColor.color.cgColor
        view.layer.cornerRadius = Constants.UI.MenuScreen.menuViewCornerRadius

        setupStartButton()

        setupSliders()
    }

    func setupStartButton()
    {
        startButton.layer.cornerRadius = Constants.UI.defaultCornerRadius
        startButton.backgroundColor = Colors.MenuView.startButtonColor.color
        startButton.contentEdgeInsets = UIEdgeInsets(top: Constants.UI.defaultElementsSpacing * 2.0,
                                                          left: Constants.UI.defaultElementsSpacing * 4.0,
                                                          bottom: Constants.UI.defaultElementsSpacing * 2.0,
                                                          right: Constants.UI.defaultElementsSpacing * 4.0)

        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Colors.MenuView.startButtonTitleColor.color,
            .font: UIFont.systemFont(ofSize: 24.0)
        ]
        let attributedTitle = NSAttributedString(string: Strings.Menu.Button.start, attributes: attributes)
        startButton.setAttributedTitle(attributedTitle, for: .normal)
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
    }

    func setupSliders()
    {
        fishCountView.titleLabel.text = Strings.Menu.FishCount.title
        orcaCountView.titleLabel.text = Strings.Menu.OrcaCount.title
        horizontalCountView.titleLabel.text = Strings.Menu.XSize.title
        verticalCountView.titleLabel.text = Strings.Menu.YSize.title

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

    // MARK: - Actions

    @IBAction func sliderValueChange(_ sender: UISlider)
    {
        let value = sender.value

        if sender == fishCountView.slider {
            setValidFishValue(from: value)
        } else if sender == orcaCountView.slider {
            setValidOrcaValue(from: value)
        } else if sender == horizontalCountView.slider {
            setValidHorizontalSize(from: value)
        } else if sender == verticalCountView.slider {
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

    // MARK: - Private

    private func recalculateCreatures()
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

    private func setValidFishValue(from value: Float)
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

    private func setValidOrcaValue(from value: Float)
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

    private func setValidHorizontalSize(from value: Float)
    {
        setValidateSizesFrom(horizontalSize: Double(value),
                             verticalSize: Double(value) * Double(Constants.World.worldSizeApectRatio))
    }

    private func setValidVerticalSize(from value: Float)
    {
        setValidateSizesFrom(horizontalSize: Double(value) / Double(Constants.World.worldSizeApectRatio),
                             verticalSize: Double(value))
    }

    private func setValidateSizesFrom(horizontalSize: Double, verticalSize: Double)
    {
        var tVertical = Int(verticalSize)
        var tHorizontal = Int(horizontalSize)

        tVertical = min(Constants.World.verticalSizeMax, Int((Float(tHorizontal) * Constants.World.worldSizeApectRatio).rounded()))
        tHorizontal = min(Constants.World.horizontalSizeMax, Int((Float(tVertical) / Constants.World.worldSizeApectRatio).rounded()))
        tVertical = max(Constants.World.verticalSizeMin, Int((Float(tHorizontal) * Constants.World.worldSizeApectRatio).rounded()))
        tHorizontal = max(Constants.World.horizontalSizeMin, Int((Float(tVertical) / Constants.World.worldSizeApectRatio).rounded()))

        self.horizontalSize = tHorizontal
        self.verticalSize = tVertical
    }

    private func updateSliders()
    {
        fishCountView.slider.value = Float(fishCount)
        orcaCountView.slider.value = Float(orcaCount)
        horizontalCountView.slider.value = Float(horizontalSize)
        verticalCountView.slider.value = Float(verticalSize)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.willTransition(to: newCollection, with: coordinator)
        
        if newCollection.verticalSizeClass != traitCollection.verticalSizeClass {
            if newCollection.verticalSizeClass == .compact {
                NSLayoutConstraint.deactivate(regularConstraints)
                NSLayoutConstraint.activate(compactHeightConstraints)
            } else {
                NSLayoutConstraint.deactivate(compactHeightConstraints)
                NSLayoutConstraint.activate(regularConstraints)
            }
       }
        
    }
}
