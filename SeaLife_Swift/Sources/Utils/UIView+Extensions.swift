//
//  UIView+Extensions.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import UIKit

protocol XibLoadable
{
    static func fromNib(named: String?) -> Self
}

extension XibLoadable where Self: UIView
{
    static func fromNib(named: String? = nil) -> Self
    {
        let bundleName = Bundle(for: Self.self)
        let nibName = named ?? "\(Self.self)"
        let nib = UINib(nibName: nibName, bundle: bundleName)
        let viewArray = nib.instantiate(withOwner: self)

        guard let contentView = viewArray.first as? Self else {
            fatalError("view of type \(Self.self) not found in \(nib)")
        }
        return contentView
    }
}
