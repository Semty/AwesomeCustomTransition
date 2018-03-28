//
//  PresentationController.swift
//  AwesomeCustomTransition
//
//  Created by Ruslan Timchenko on 28/03/2018.
//  Copyright © 2018 Ruslan Timchenko. All rights reserved.
//

import Foundation
import UIKit

// for present
class PresentationController: UIPresentationController {
    
    var duration: TimeInterval = 0.6
    var isPresenting = false
    var fakeTabbar: UIView?
    
    private var blackLayer: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.0
        return view
    }()
    
    override func presentationTransitionWillBegin() {
        guard let fromView = presentingViewController.view else { return }
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        guard let presentingVC = presentingViewController as? MainTabBarController else { return }
        guard let contentesView = presentingVC.selectedViewController?.view else { return }
        
        blackLayer.frame = fromView.frame
        contentesView.addSubview(blackLayer)
        coordinator.animate(alongsideTransition: { (context) in
            self.blackLayer.alpha = 0.5
        }) { (_) in
            
        }
    }
}

// for dismiss
extension PresentationController {
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        coordinator.animate(alongsideTransition: { (context) in
            self.blackLayer.alpha = 0.0
        }) { (context) in
            if !context.isCancelled {
                self.blackLayer.removeFromSuperview()
            }
        }
    }
}

extension PresentationController: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let presented = presentedView else { return }
        guard let container = containerView else { return }
        
        guard let presentedVC = presentedViewController as? InfoCardViewController else { return }
        guard let presentingVC = presentingViewController as? MainTabBarController else { return }
        guard let contentesView = presentingVC.selectedViewController?.view else { return }
        if isPresenting {
            fakeTabbar = presentingVC.tabBar.snapshotView(afterScreenUpdates: false)
            fakeTabbar?.frame = presentingVC.tabBar.frame
            container.addSubview(presented)
            container.addSubview(fakeTabbar!)
            presented.frame = CGRect(x: 0,
                                     y: container.bounds.height - Constant.pinnedBarHeight,
                                     width: container.bounds.width,
                                     height: Constant.pinnedBarHeight)
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                contentesView.layer.cornerRadius = 10
                contentesView.clipsToBounds = true
                contentesView.transform = contentesView.transform.scaledBy(x: 0.95, y: 0.95)
                contentesView.transform = contentesView.transform.translatedBy(x: 0, y: 20 - container.bounds.height * 0.05 / 2)
                presentingVC.tabBar.frame = presentingVC.tabBar.frame.offsetBy(dx: 0, dy: presentingVC.tabBar.bounds.height)
                self.fakeTabbar!.frame = self.fakeTabbar!.frame.offsetBy(dx: 0, dy: self.fakeTabbar!.bounds.height)
                
                presentedVC.frameAfterPresent()
                presented.frame = CGRect(x: 0,
                                         y: Constant.pinnedBarInfoTopPadding,
                                         width: container.bounds.width,
                                         height: container.bounds.height - Constant.pinnedBarInfoTopPadding)
                presented.layer.cornerRadius = 10
                presented.clipsToBounds = true
            }, completion: { (_) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        } else {
            UIView.animate(withDuration: duration,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: .curveEaseInOut,
                           animations: {
                            
                contentesView.layer.cornerRadius = 0
                contentesView.transform = CGAffineTransform.identity
                contentesView.frame = container.frame
                presentingVC.tabBar.frame = presentingVC.tabBar.frame.offsetBy(dx: 0, dy: -presentingVC.tabBar.bounds.height)
                presentingVC.pinnedBarView.isHidden = true
                self.fakeTabbar!.frame = self.fakeTabbar!.frame.offsetBy(dx: 0, dy: -self.fakeTabbar!.bounds.height)
                
                presentedVC.frameBeforePresent()
                presented.layer.cornerRadius = 0
                presented.frame = CGRect(x: 0,
                                         y: container.bounds.height - Constant.pinnedBarHeight,
                                         width: container.bounds.width,
                                         height: Constant.pinnedBarHeight)
            }, completion: { (_) in
                if !transitionContext.transitionWasCancelled {
                    self.fakeTabbar?.removeFromSuperview()
                    self.fakeTabbar = nil
                    presentingVC.pinnedBarView.isHidden = false
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
}
