//
//  Screen+Sizes.swift
//  AwesomeCustomTransition
//
//  Created by Ruslan Timchenko on 20.11.2020.
//  Copyright © 2020 Ruslan Timchenko. All rights reserved.
//

import Foundation
import UIKit

public struct Screen {
    public static let scale = UIScreen.main.scale
    public static let bounds = UIScreen.main.bounds
    public static let size = bounds.size
    public static let width = size.width
    public static let height = size.height
}

extension Screen {
    
    enum iPhone: String {
        case unknown
        case iPhone5
        case iPhone8
        case iPhonePlus
        case iPhonePro
        case iPhone12
        case iPhoneProMax
    }
    
    static var currentIPhone: iPhone {
        switch (width, height) {
        case (320, 568):
            return .iPhone5
        case (375, 667):
            return .iPhone8
        case (414, 736):
            return .iPhonePlus
        case (375, 812):
            return .iPhonePro
        case (414, 896), (428, 926):
            return .iPhoneProMax
        case (390, 844):
            return .iPhone12
        default:
            return .unknown
        }
    }
    
    static func isIn(iPhones: [iPhone]) -> Bool {
        let current = Screen.currentIPhone
        
        for iPhone in iPhones {
            if current.rawValue == iPhone.rawValue {
                return true
            }
        }
        
        return false
    }
    
    static var isIPhone5: Bool {
        return currentIPhone == .iPhone5
    }
    
    static var isBig: Bool {
        return Screen.isIn(iPhones: [.iPhonePlus, .iPhonePro, .iPhoneProMax, .iPhone12])
    }
    
    static var isNotchable: Bool {
        return Screen.isIn(iPhones: [.iPhonePro, .iPhoneProMax, .iPhone12])
    }
}
