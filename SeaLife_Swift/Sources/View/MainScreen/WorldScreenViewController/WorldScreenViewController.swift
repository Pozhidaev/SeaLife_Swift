//
//  MainScreenViewController.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import UIKit

class WorldScreenViewController: UIViewController, UIAlertViewDelegate
{
    let segueIdPresentMenuScreenFullScreen = "kSegueIdPresentMenuScreenFullScreen"
    let segueIdPresentMenuScreenFormSheet = "kSegueIdPresentMenuScreenFormSheet"

    let segueIdWorldViewControllerSegue = "WorldViewControllerSegue"

    // MARK: - Outlets

    @IBOutlet private weak var playButton: ControlPanelButton!
    @IBOutlet private weak var resetButton: ControlPanelButton!
    @IBOutlet private weak var menuButton: ControlPanelButton!

    @IBOutlet private weak var controlPanel: UIView!

    @IBOutlet private weak var creaturesSpeedSlider: UISlider!
    @IBOutlet private weak var animationSpeedSlider: UISlider!

    @IBOutlet private weak var creaturesSpeedTitleLabel: UILabel!
    @IBOutlet private weak var creaturesSpeedLabel: UILabel!

    @IBOutlet private weak var animationSpeedTitleLabel: UILabel!
    @IBOutlet private weak var animationSpeedLabel: UILabel!

    // MARK: - Private vars

    private var worldViewController: WorldViewController?

    private var isPlaying: Bool = false
    private var configured: Bool = false
    private var worldInfo: WorldInfo?

    private let speedFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.positiveSuffix = Strings.Time.second
        return formatter
    }()

    // MARK: - Life Cycle

    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupView()
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)

        let animationSpeed: Double = Constants.Speed.animationDefaultSpeed
        worldViewController?.setAnimationsSpeed(animationSpeed)
        animationSpeedSlider.value = Float(Constants.Speed.animationFastestSpeed + (Constants.Speed.animationSlowestSpeed - animationSpeed))

        let creaturesSpeed: Double = Constants.Speed.creatureDefaultSpeed
        worldViewController?.creaturesSpeed = creaturesSpeed
        creaturesSpeedSlider.value = Float(Constants.Speed.creatureFastestSpeed + (Constants.Speed.creatureSlowestSpeed - creaturesSpeed))

        if !configured {
            showMenu(fullScreen: true)
        }
    }

    // MARK: - Actions

    @IBAction func play(_ sender: UIButton)
    {
        if isPlaying {
            stop()
        } else {
            play()
        }
    }

    @IBAction func resetWorld(_ sender: UIButton)
    {
        stop()
        worldViewController?.reset()
    }

    @IBAction func showMenu(_ sender: UIButton)
    {
        stop()
        showMenu(fullScreen: false)
    }

    @IBAction func creatureSpeedSliderChanged(_ sender: UISlider)
    {
        let speed = Constants.Speed.creatureSlowestSpeed - (Double(sender.value) - Constants.Speed.creatureFastestSpeed)
        creaturesSpeedLabel.text = speedFormatter.string(from: speed as NSNumber)
        worldViewController?.creaturesSpeed = speed
    }

    @IBAction func animationSpeedSliderChanged(_ sender: UISlider)
    {
        let speed = Constants.Speed.animationSlowestSpeed - (Double(sender.value) - Constants.Speed.animationFastestSpeed)
        animationSpeedLabel.text = speedFormatter.string(from: speed as NSNumber)
        worldViewController?.setAnimationsSpeed(speed)
    }

    // MARK: - Private methods

    private func showMenu(fullScreen: Bool)
    {
        if fullScreen {
            performSegue(withIdentifier: segueIdPresentMenuScreenFullScreen, sender: nil)
        } else {
            performSegue(withIdentifier: segueIdPresentMenuScreenFormSheet, sender: nil)
        }
    }

    private func play()
    {
        worldViewController?.play()
        isPlaying = true
        updateControls()
    }

    private func stop()
    {
        worldViewController?.stop()
        isPlaying = false
        updateControls()
    }

    private func updateControls()
    {
        resetButton.isEnabled = !isPlaying

        let playTitle = Strings.Button.play
        let pauseTitle = Strings.Button.pause
        let title = isPlaying ? pauseTitle : playTitle
        playButton.setTitle(title, for: .normal)
    }

    // MARK: - Private methods - Config View

    private func setupView()
    {
        self.view.backgroundColor = Colors.MainScreen.backgroundColor.color

        setupControlPanel()
    }

    private func setupControlPanel()
    {
        controlPanel.backgroundColor = Colors.MainScreen.ControlPanel.backgroundColor.color
        controlPanel.layer.borderColor = Colors.MainScreen.ControlPanel.frameColor.color.cgColor
        controlPanel.layer.borderWidth = Constants.UI.MainScreen.controlPanelViewBorderWidth
        controlPanel.layer.cornerRadius = Constants.UI.defaultCornerRadius

        setupButtons()

        setupSliders()
    }

    private func setupSliders()
    {
        creaturesSpeedSlider.minimumValue = Float(Constants.Speed.creatureFastestSpeed)
        creaturesSpeedSlider.maximumValue = Float(Constants.Speed.creatureSlowestSpeed)
        creaturesSpeedSlider.tintColor = Colors.MainScreen.ControlPanel.sliderTintColor.color
        creaturesSpeedLabel.text = speedFormatter.string(from: Constants.Speed.creatureDefaultSpeed as NSNumber)
        creaturesSpeedLabel.textColor = Colors.MainScreen.ControlPanel.textColor.color
        creaturesSpeedTitleLabel.text = Strings.MainScreen.creaturesSpeed
        creaturesSpeedTitleLabel.textColor = Colors.MainScreen.ControlPanel.textColor.color

        animationSpeedSlider.minimumValue = Float(Constants.Speed.animationFastestSpeed)
        animationSpeedSlider.maximumValue = Float(Constants.Speed.animationSlowestSpeed)
        animationSpeedSlider.tintColor = Colors.MainScreen.ControlPanel.sliderTintColor.color
        animationSpeedLabel.text = speedFormatter.string(from: Constants.Speed.animationDefaultSpeed as NSNumber)
        animationSpeedLabel.textColor = Colors.MainScreen.ControlPanel.textColor.color
        animationSpeedTitleLabel.text = Strings.MainScreen.animationSpeed
        animationSpeedTitleLabel.textColor = Colors.MainScreen.ControlPanel.textColor.color
    }

    private func setupButtons()
    {
        playButton.setTitle(Strings.Button.play, for: .normal)
        resetButton.setTitle(Strings.Button.reset, for: .normal)
        menuButton.setTitle(Strings.Button.menu, for: .normal)
    }

    // MARK: - Segues

    @IBAction func unwindToMainScreenViewController(unwindSegue: UIStoryboardSegue)
    {
        // if there will be many place for unwinding from, it better to move logic
        // in prepare for segue and compare segue identifiers
        guard let sourceViewController = unwindSegue.source as? MenuViewController else {
            return
        }
        let worldInfo = sourceViewController.worldInfo
        worldViewController?.createWorld(with: worldInfo)
        configured = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == segueIdWorldViewControllerSegue {
            worldViewController = segue.destination as? WorldViewController
            worldViewController?.delegate = self
        }
    }

    // MARK: - UIContentContainer

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.willTransition(to: newCollection, with: coordinator)

        controlPanel.layer.borderColor = Colors.MainScreen.ControlPanel.frameColor.color.cgColor
        playButton.redraw()
        resetButton.redraw()
        menuButton.redraw()
    }
}

extension WorldScreenViewController: WorldViewControllerDelegate
{
    func worldViewController(_ worldViewController: WorldViewController,
                             didCompleteWith reason: WorldCompletionReason)
    {
        DispatchQueue.main.async { [weak self] in
            self?.stop()

            var message: String
            switch reason {
            case .empty: message = Strings.World.Finish.empty
            case .full: message = Strings.World.Finish.full
            }

            let alertController = UIAlertController(title: nil,
                                                    message: message,
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: Strings.Button.ok,
                                         style: .destructive) {_ in
                self?.worldViewController?.reset()
            }
            alertController.addAction(okAction)
            self?.present(alertController, animated: true)
        }
    }
}
