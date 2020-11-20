//
//  UIDevice+Extension.swift
//  AwesomeCustomTransition
//
//  Created by Ruslan Timchenko on 20.11.2020.
//  Copyright © 2020 Ruslan Timchenko. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    private static var keyWindow: UIWindow? {
        return UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first
    }

    static var safeAreaTopInset: CGFloat {
        let window = keyWindow
        if #available(iOS 12, *) {
            return window?.safeAreaInsets.top ?? 0
        } else if Screen.isIn(iPhones: [.iPhone5, .iPhone8, .iPhonePlus]) {
            if let top = window?.safeAreaInsets.top, top > 0 {
                return top
            } else {
                return UIApplication.shared.statusBarFrame.height
            }
        }
        return window?.safeAreaInsets.top ?? 0
    }

    static var safeAreaBottomInset: CGFloat {
        let window = keyWindow
        return window?.safeAreaInsets.bottom ?? 0
    }

    static var hasNotch: Bool {
        let bottom = keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
