//
//  Constant.swift
//  AwesomeCustomTransition
//
//  Created by Ruslan Timchenko on 28/03/2018.
//  Copyright © 2018 Ruslan Timchenko. All rights reserved.
//

import Foundation
import UIKit

enum Constant {
    static let openTranslationProgressNotReturn: CGFloat = 0.10
    static let openTranslationProgressEnd: CGFloat = 0.20
    static let openVelocitySpeedNotReturn: CGFloat = 100.0
    static let closedProgressNotReturn: CGFloat = 0.35
    static let pinnedBarHeight: CGFloat = 120
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    static let homeScaleX: CGFloat = 0.95
    
    static var homeScaleY: CGFloat {
        if UIDevice.hasNotch {
            return 0.915
        } else {
            return 0.935
        }
    }
    
    static var pinnedBarInfoTopPadding: CGFloat {
//        if UIScreen.main.nativeBounds.height == .iphoneX {
//            // 30 - it's like a zero; 44 - it's default status bar height
//            return 44
//        } else {
//            // 20 - it's like a zero; 20 - it's default status bar height
//            return 31
//        }
        return UIDevice.safeAreaTopInset
    }
    
    static var tabBarHeight: CGFloat {
        if UIDevice.hasNotch {
            return 120 + UIDevice.safeAreaBottomInset
        } else {
            return 120
        }
    }
}
