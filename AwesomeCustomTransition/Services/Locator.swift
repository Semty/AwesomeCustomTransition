//
//  Locator.swift
//  AwesomeCustomTransition
//
//  Created by Ruslan Timchenko on 28/03/2018.
//  Copyright © 2018 Ruslan Timchenko. All rights reserved.
//

import Foundation

public final class Locator {
    static public let shared = Locator()
    
    private init () {}
    
    /// create components factory
    func componentsFactory() -> IComponentsFactory {
        return ComponentsFactory()
    }
}
