//
//  IComponentsFactory.swift
//  AwesomeCustomTransition
//
//  Created by Ruslan Timchenko on 28/03/2018.
//  Copyright © 2018 Ruslan Timchenko. All rights reserved.
//

import Foundation

public protocol IComponentsFactory {
    /// Create pinned bar view
    func createPinnedBarView() -> PinnedBarView
    
    /// Create header button
    func createHeaderButton() -> HeaderButton
    
    /// Create cover image view
    func createCoverImageView() -> CoverImageView
}
