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
    
    init(attachTo view: UIView) {
        self.view = view
        super.init()
        setPanGesture(view: view)
    }
    
    private func setPanGesture(view: UIView) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(tapGestureAction(gesture:)))
        view.addGestureRecognizer(gesture)
    }
    
    @objc private func tapGestureAction(gesture: UIPanGestureRecognizer) {
        let viewTransition = gesture.translation(in: view)
        let progress = -viewTransition.y / (UIScreen.main.bounds.height - Constant.tabBarHeight - Constant.statusBarHeight)
        switch gesture.state {
        case .began:
            delegate?.presentInteractive()
        case .changed:
            if progress > Constant.openProgressNotReturn {
                finish()
            } else {
                update(progress)
            }
        case .cancelled:
            cancel()
        case .ended:
            if progress > Constant.openProgressNotReturn {
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
