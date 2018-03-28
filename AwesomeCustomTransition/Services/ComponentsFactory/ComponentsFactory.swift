//
//  ComponentsFactory.swift
//  AwesomeCustomTransition
//
//  Created by Ruslan Timchenko on 28/03/2018.
//  Copyright © 2018 Ruslan Timchenko. All rights reserved.
//

import Foundation

public final class ComponentsFactory: IComponentsFactory {
    public func createPinnedBarView() -> PinnedBarView {
        return PinnedBarView.fromNib()
    }
    
    public func createHeaderButton() -> HeaderButton {
        return HeaderButton.fromNib()
    }
    
    public func createCoverImageView() -> CoverImageView {
        return CoverImageView.fromNib()
    }
}
