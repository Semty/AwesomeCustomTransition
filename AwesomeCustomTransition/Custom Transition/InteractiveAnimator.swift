//
//  InteractiveAnimator.swift
//  AwesomeCustomTransition
//
//  Created by Ruslan Timchenko on 28/03/2018.
//  Copyright © 2018 Ruslan Timchenko. All rights reserved.
//

import Foundation
import UIKit

protocol InteractiveAnimatorDelegate : class {
    func presentInteractive()
}

class InteractiveAnimator: UIPercentDrivenInteractiveTransition {
    
    private var view: UIView
    
    weak var delegate: InteractiveAnimatorDelegate?
    
    // MARK: - Initialization
    
    init(attachTo view: UIView) {
        self.view = view
        super.init()
        setPanGesture(view: view)
    }
    
    // MARK: - Helpful Private Functions
    
    private func setPanGesture(view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(gesture:)))
        view.addGestureRecognizer(gesture)
    }
    
    // MARK: - Actions
    
    @objc private func panGestureAction(gesture: UIPanGestureRecognizer) {
        let viewTranslation = gesture.translation(in: view)
        let viewVelocity = gesture.velocity(in: view)
        
        let translationProgress = -viewTranslation.y / (UIScreen.main.bounds.height - Constant.tabBarHeight - Constant.statusBarHeight - Constant.pinnedBarHeight)
        let velocitySpeed = -viewVelocity.y
        
        let isUpSwipe = velocitySpeed > 0

        print("PROGRESS = \(translationProgress)")
        print("SPEED = \(velocitySpeed)")
        
        switch gesture.state {
        case .began:
            if isUpSwipe {
                delegate?.presentInteractive()
            }
        case .changed:
            if translationProgress > 0 {
                update(translationProgress)
                if translationProgress > Constant.openTranslationProgressEnd {
                    finish()
                }
            }
        case .cancelled:
            cancel()
        case .ended:
            if translationProgress > Constant.openTranslationProgressNotReturn {
                finish()
            } else if velocitySpeed > Constant.openVelocitySpeedNotReturn {
                finish()
            } else {
                cancel()
            }
            break
        default:
            break
        }
    }
}
