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
    static let openProgressNotReturn: CGFloat = 0.01
    static let closedProgressNotReturn: CGFloat = 0.35
    static let pinnedBarHeight: CGFloat = 120
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    static let homeScaleX: CGFloat = 0.95
    
    static var homeScaleY: CGFloat {
        if UIScreen.main.nativeBounds.height == .iphoneX {
            return 0.91
        } else {
            return 0.935
        }
    }
    
    static var pinnedBarInfoTopPadding: CGFloat {
        if UIScreen.main.nativeBounds.height == .iphoneX {
            return 50
        } else {
            return 40
        }
    }
    
    static var tabBarHeight: CGFloat {
        if UIScreen.main.nativeBounds.height == .iphoneX {
            return 120 + 34
        } else {
            return 120
        }
    
    }
}
