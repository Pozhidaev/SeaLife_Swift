//
//  WorldViewControllerDelegate.swift
//  SeaLife_Swift
//
//  Created by Sergey Pozhidaev on 20.05.2023.
//

import Foundation

protocol WorldViewControllerDelegate: AnyObject
{
    func worldViewController(_ worldViewController:WorldViewController,
                             didCompleteWith:WorldCompletionReason)

}
