//
//  SliderView.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import UIKit

public class SliderView : UIView, xibLoadable
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var minimumValueLabel: UILabel!
    @IBOutlet weak var maximumValueLabel: UILabel!
    @IBOutlet weak var slider: UISlider!

    private let valueKey = "value"
    private let minimumValueKey = "minimumValue"
    private let maximumValueKey = "maximumValue"

    public override func awakeFromNib()
    {
        super.awakeFromNib()
        
        slider.addObserver(self, forKeyPath: valueKey, context: nil)
        slider.addObserver(self, forKeyPath: minimumValueKey, context: nil)
        slider.addObserver(self, forKeyPath: maximumValueKey, context: nil)
        
        layer.cornerRadius = Constants.UI.defaultCornerRadius
        backgroundColor = UIColor(named: "SliderViewBackgroundColor")
        
        titleLabel.textColor = UIColor(named: "SliderViewTextColor")
        valueLabel.textColor = UIColor(named: "SliderViewTextColor")
        minimumValueLabel.textColor = UIColor(named: "SliderViewTextColor")
        maximumValueLabel.textColor = UIColor(named: "SliderViewTextColor")
        slider.tintColor = UIColor(named: "SliderViewSliderTintColor")
    }
    
    public override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?)
    {
        switch keyPath {
        case valueKey:
            let value = (object as? UISlider)?.value
            if let value {
                self.valueLabel.text = "\(value)"
            } else {
                self.valueLabel.text = NSLocalizedString("SliderView.Value.Unknown", comment: "")
            }
        case minimumValueKey:
            let value = (object as? UISlider)?.minimumValue
            if let value {
                self.minimumValueLabel.text = "\(value)"
            } else {
                self.minimumValueLabel.text = NSLocalizedString("SliderView.Minimum.Unknown", comment: "")
            }
        case maximumValueKey:
            let value = (object as? UISlider)?.maximumValue
            if let value {
                self.maximumValueLabel.text = "\(value)"
            } else {
                self.maximumValueLabel.text = NSLocalizedString("SliderView.Maximum.Unknown", comment: "")
            }
        default: break
        }
    }
}
