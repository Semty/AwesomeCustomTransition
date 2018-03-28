//
//  Extension+UIView.swift
//  AwesomeCustomTransition
//
//  Created by Ruslan Timchenko on 28/03/2018.
//  Copyright © 2018 Ruslan Timchenko. All rights reserved.
//

import Foundation
import UIKit

protocol UIViewLoading {}

extension UIView: UIViewLoading {}

extension UIViewLoading where Self: UIView {
    
    static func isLoadableFromNib() -> Bool {
        let bundle = Bundle(for: self)
        return bundle.path(forResource: nibName(), ofType: "nib") != nil
    }
    
    static func fromNib() -> Self {
        let bundle = Bundle(for: self)
        
        guard let viewFromNib = bundle.loadNibNamed(nibName(), owner: self, options: nil)?.first as? Self else {
            fatalError("Can't load Nib with name \(nibName)")
        }
        return viewFromNib
    }
    
    static func nibName() -> String {
        var nibName = self.className
        if let index = nibName.index(of: "<") {
            nibName = String(nibName[..<index])
        }
        return nibName
    }
}
