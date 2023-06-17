//
//  ControlPanelButton.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 11.06.2023.
//

import UIKit

class ControlPanelButton: UIButton
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        setup()
    }

    func redraw()
    {
        layer.borderColor = Colors.MainScreen.ControlPanel.buttonsFrame.color.cgColor
    }

    private func setup()
    {
        layer.cornerRadius = Constants.UI.defaultCornerRadius
        layer.borderWidth = Constants.UI.defaultBorderWidth
        layer.borderColor = Colors.MainScreen.ControlPanel.buttonsFrame.color.cgColor

        backgroundColor = Colors.MainScreen.ControlPanel.resetButtonColor.color

        setTitleColor(Colors.MainScreen.ControlPanel.buttonsTitleColor.color, for: .normal)
        setTitleColor(Colors.MainScreen.ControlPanel.buttonsDisabledTitleColor.color, for: .disabled)
    }
}
