//
//  MainScreenViewController.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import UIKit

class WorldScreenViewController : UIViewController, UIAlertViewDelegate
{
    let segueIdPresentMenuScreenFullScreen = "kSegueIdPresentMenuScreenFullScreen"
    let segueIdPresentMenuScreenFormSheet = "kSegueIdPresentMenuScreenFormSheet"
    
    //MARK: - Outlets
    
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var menuButton: UIButton!
    
    @IBOutlet private weak var controlPanel: UIView!
    
    @IBOutlet private weak var creaturesSpeedSlider: UISlider!
    @IBOutlet private weak var animationSpeedSlider: UISlider!
    
    @IBOutlet private weak var creaturesSpeedTitleLabel: UILabel!
    @IBOutlet private weak var creaturesSpeedLabel: UILabel!

    @IBOutlet private weak var animationSpeedTitleLabel: UILabel!
    @IBOutlet private weak var animationSpeedLabel: UILabel!

    //MARK: - Private vars
    
    private var worldViewController: WorldViewController?
    
    private var isPlaying: Bool = false
    private var configured: Bool = false
    private var worldInfo: WorldInfo?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named:"MainScreenBackgroundColor")
        
        setupControlPanel()
        
        let animationSpeed: Double = Constants.Speed.animationDefaultSpeed
        worldViewController?.animationSpeed = animationSpeed
        animationSpeedSlider.value = Float(Constants.Speed.animationFastestSpeed + (Constants.Speed.animationSlowestSpeed - animationSpeed))

        let creaturesSpeed: Double = Constants.Speed.creatureDefaultSpeed
        worldViewController?.creaturesSpeed = creaturesSpeed
        creaturesSpeedSlider.value = Float(Constants.Speed.creatureFastestSpeed + (Constants.Speed.creatureSlowestSpeed - creaturesSpeed))
    }

    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if (!configured) {
            showMenu(fullScreen: true)
        }
    }
    
    //MARK: - Actions
    
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
        showMenu(fullScreen:false)
    }
    
    @IBAction func creatureSpeedSliderChanged(_ sender: UISlider)
    {
        let speed = Constants.Speed.creatureSlowestSpeed - (Double(sender.value) - Constants.Speed.creatureFastestSpeed)
        creaturesSpeedLabel.text = "\(speed)"
        worldViewController?.creaturesSpeed = speed
    }

    @IBAction func animationSpeedSliderChanged(_ sender: UISlider)
    {
        let speed = Constants.Speed.animationSlowestSpeed - (Double(sender.value) - Constants.Speed.animationFastestSpeed)
        animationSpeedLabel.text = "\(speed)"
        worldViewController?.animationSpeed = speed
    }
    
    //MARK: - Private methods
    
    private func showMenu(fullScreen: Bool)
    {
        if fullScreen {
            performSegue(withIdentifier:segueIdPresentMenuScreenFullScreen, sender:nil)
        } else {
            performSegue(withIdentifier:segueIdPresentMenuScreenFormSheet, sender:nil)
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
        
        let playTitle = NSLocalizedString("Button.Play", comment: "")
        let pauseTitle = NSLocalizedString("Button.Pause", comment: "")
        let title = isPlaying ? pauseTitle : playTitle
        playButton.setTitle(title, for: .normal)
    }
    
    //MARK: - Private methods - Config View
    
    private func setupControlPanel()
    {
        controlPanel.backgroundColor = UIColor(named:"MainScreenControlPanelBackgroundColor")
        controlPanel.layer.borderColor = UIColor(named:"MainScreenControlPanelFrameColor")?.cgColor
        controlPanel.layer.borderWidth = Constants.UI.MainScreen.controlPanelViewBorderWidth
        controlPanel.layer.cornerRadius = Constants.UI.defaultCornerRadius
        
        setupButtons()

        setupSliders()
    }

    private func setupSliders()
    {
        creaturesSpeedSlider.minimumValue = Float(Constants.Speed.creatureFastestSpeed)
        creaturesSpeedSlider.maximumValue = Float(Constants.Speed.creatureSlowestSpeed)
        creaturesSpeedSlider.tintColor = UIColor(named:"MainScreenSliderTintColor")
        creaturesSpeedLabel.text = "\(Constants.Speed.creatureDefaultSpeed)"
        creaturesSpeedTitleLabel.text = NSLocalizedString("MainScreen.CreaturesSpeed", comment: "");

        animationSpeedSlider.minimumValue = Float(Constants.Speed.animationFastestSpeed)
        animationSpeedSlider.maximumValue = Float(Constants.Speed.animationSlowestSpeed)
        animationSpeedSlider.tintColor = UIColor(named:"MainScreenSliderTintColor")
        animationSpeedLabel.text = "\(Constants.Speed.animationDefaultSpeed)"
        animationSpeedTitleLabel.text = NSLocalizedString("MainScreen.AnimationSpeed", comment: "");
    }
    
    private func setupButtons()
    {
        playButton.layer.cornerRadius = Constants.UI.defaultCornerRadius
        resetButton.layer.cornerRadius = Constants.UI.defaultCornerRadius
        menuButton.layer.cornerRadius = Constants.UI.defaultCornerRadius
        
        resetButton.backgroundColor = UIColor(named:"MainScreenResetButtonColor")
        menuButton.backgroundColor = UIColor(named:"MainScreenMenuButtonColor")
        playButton.backgroundColor = UIColor(named:"MainScreenPlayButtonColor")

        playButton.setTitle(NSLocalizedString("Button.Play", comment: ""), for: .normal)
        resetButton.setTitle(NSLocalizedString("Button.Reset", comment: ""), for: .normal)
        menuButton.setTitle(NSLocalizedString("Button.Menu", comment: ""), for: .normal)
    }
    
    //MARK: - Segues
    
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
        
        if segue.identifier == "WorldViewControllerSegue" {
            worldViewController = segue.destination as? WorldViewController
            worldViewController?.delegate = self
        }
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
            switch (reason) {
            case .empty: message = "World become empty"
            case .full: message = "World become full with no move"
            }
            
            let alertController = UIAlertController(title: nil,
                                                    message: message,
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok",
                                         style: .destructive) {_ in
                self?.worldViewController?.reset()
            }
            alertController.addAction(okAction)
            self?.present(alertController, animated: true)
        }
    }
    
}
