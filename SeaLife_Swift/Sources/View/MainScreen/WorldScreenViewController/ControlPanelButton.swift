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

    private func setup()
    {
        layer.cornerRadius = Constants.UI.defaultCornerRadius

        backgroundColor = Colors.MainScreen.ControlPanel.resetButtonColor.color

        setTitleColor(Colors.MainScreen.ControlPanel.buttonsTitleColor.color, for: .normal)
        setTitleColor(Colors.MainScreen.ControlPanel.buttonsDisabledTitleColor.color, for: .disabled)
    }
}
