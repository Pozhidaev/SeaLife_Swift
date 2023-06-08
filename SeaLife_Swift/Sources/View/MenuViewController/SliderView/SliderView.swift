//
//  SliderView.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import UIKit

public class SliderView: UIView, XibLoadable
{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var minimumValueLabel: UILabel!
    @IBOutlet weak var maximumValueLabel: UILabel!
    @IBOutlet weak var slider: UISlider!

    private var valueObservation: NSKeyValueObservation?
    private var minValueObservation: NSKeyValueObservation?
    private var maxValueObservation: NSKeyValueObservation?

    private let formatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    func labelUpdateHandler(_ label: UILabel) -> (UISlider, NSKeyValueObservedChange<Float>) -> Void
    {
        return { [weak self] _, changes in
            if let value = changes.newValue {
                label.text = self?.formatter.string(from: value as NSNumber)
            } else {
                label.text = Strings.SliderView.Value.unknown
            }
        }
    }

    public override func awakeFromNib()
    {
        super.awakeFromNib()

        valueObservation = slider.observe(\.value, options: [.new, .initial], changeHandler: labelUpdateHandler(valueLabel))
        minValueObservation = slider.observe(\.minimumValue, options: [.new, .initial], changeHandler: labelUpdateHandler(minimumValueLabel))
        maxValueObservation = slider.observe(\.maximumValue, options: [.new, .initial], changeHandler: labelUpdateHandler(maximumValueLabel))

        layer.cornerRadius = Constants.UI.defaultCornerRadius
        backgroundColor = Colors.SliderView.backgroundColor.color

        titleLabel.textColor = Colors.SliderView.textColor.color
        valueLabel.textColor = Colors.SliderView.textColor.color
        minimumValueLabel.textColor = Colors.SliderView.textColor.color
        maximumValueLabel.textColor = Colors.SliderView.textColor.color
        slider.tintColor = Colors.SliderView.tintColor.color
    }
}
