//
//  PresentationController.swift
//  AwesomeCustomTransition
//
//  Created by Ruslan Timchenko on 28/03/2018.
//  Copyright © 2018 Ruslan Timchenko. All rights reserved.
//

import Foundation
import UIKit

private extension TimeInterval {
    static let duration: TimeInterval = 0.6
}

private extension CGFloat {
    static let blackLayerAlpha: CGFloat = 0.5
    static let cornerRadius: CGFloat = 10
    static let presantingSpringWithDamping: CGFloat = 0.9
    static let presantingInitialSpringVelocity: CGFloat = 0.5
    static let hiddenSpringWithDamping: CGFloat = 0.8
    static let hiddenInitialSpringVelocity: CGFloat = 0.5
    static let contentsViewYOffset: CGFloat = 20
    static let contentsViewYCoeff: CGFloat = 0.05
}

class PresentationController: UIPresentationController, UIViewControllerAnimatedTransitioning {
    
    // Models
    enum State {
        case presenting // the cover is shown
        case hidden // the cover is hidden
    }
    
    var state: State = .hidden
    
    private var fakeTabbar: UIView?
    
    private lazy var blackLayer: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    // MARK: - Transition Lifecycle
    
    override func presentationTransitionWillBegin() {
        guard let fromView = presentingViewController.view,
            let coordinator = presentedViewController.transitionCoordinator,
            let presentingVC = presentingViewController as? MainTabBarController,
            let contentsView = presentingVC.selectedViewController?.view else { return }
        
        blackLayer.frame = fromView.frame
        contentsView.addSubview(blackLayer)
        coordinator.animate(alongsideTransition: { (context) in
            self.blackLayer.alpha = .blackLayerAlpha
        })
    }
    
    // For dismiss
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        coordinator.animate(alongsideTransition: { (context) in
            self.blackLayer.alpha = 0
        }) { (context) in
            if !context.isCancelled {
                self.blackLayer.removeFromSuperview()
            }
        }
    }
    
    //MARK: - Private
    
    private func showPresentingAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let presented = presentedView,
            let container = containerView,
            let presentedVC = presentedViewController as? InfoCardViewController,
            let presentingVC = presentingViewController as? MainTabBarController,
            let contentsView = presentingVC.selectedViewController?.view,
            let fakeTabbar = presentingVC.tabBar.snapshotView(afterScreenUpdates: false) else { return }
        
        self.fakeTabbar = fakeTabbar
        fakeTabbar.frame = presentingVC.tabBar.frame
        
        container.addSubview(presented)
        container.addSubview(fakeTabbar)
        
        presented.frame = CGRect(x: 0,
                                 y: container.bounds.height - Constant.tabBarHeight,
                                 width: container.bounds.width,
                                 height: Constant.pinnedBarHeight)
        
        UIView.animate(withDuration: .duration, delay: 0, usingSpringWithDamping: .presantingSpringWithDamping, initialSpringVelocity: .presantingInitialSpringVelocity, options: .curveEaseInOut, animations: {

            contentsView.layer.cornerRadius = .cornerRadius
            contentsView.layer.maskedCorners =
                [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            contentsView.clipsToBounds = true
            contentsView.transform =
                contentsView.transform.scaledBy(x: Constant.homeScaleX,
                                                y: Constant.homeScaleY)
            contentsView.layoutSubviews()
            
            presentingVC.tabBar.frame = presentingVC.tabBar.frame.offsetBy(dx: 0, dy: presentingVC.tabBar.bounds.height)
            fakeTabbar.frame = fakeTabbar.frame.offsetBy(dx: 0, dy: fakeTabbar.bounds.height)

            presentedVC.frameAfterPresent()
            presented.frame = CGRect(x: 0,
                                     y: Constant.pinnedBarInfoTopPadding,
                                     width: container.bounds.width,
                                     height: container.bounds.height - Constant.pinnedBarInfoTopPadding)
            presented.layer.cornerRadius = .cornerRadius
            presented.layer.maskedCorners =
                [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            presented.clipsToBounds = true
            presented.layoutSubviews()
            
        }, completion: { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            contentsView.layoutSubviews()
        })
    }
    
    private func showHiddenAnimation(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let presented = presentedView,
            let container = containerView,
            let presentedVC = presentedViewController as? InfoCardViewController,
            let presentingVC = presentingViewController as? MainTabBarController,
            let contentsView = presentingVC.selectedViewController?.view,
            let fakeTabbar = fakeTabbar else { return }
        
        UIView.animate(withDuration: .duration,
                       delay: 0,
                       usingSpringWithDamping: .hiddenSpringWithDamping,
                       initialSpringVelocity: .hiddenInitialSpringVelocity,
                       options: [.curveEaseInOut, .beginFromCurrentState],
                       animations: {
                        
                        contentsView.layer.cornerRadius = 0
                        contentsView.transform = CGAffineTransform.identity
                        contentsView.frame = container.frame
                        contentsView.layoutSubviews()
                        
                        presentingVC.tabBar.frame = presentingVC.tabBar.frame.offsetBy(dx: 0, dy: -presentingVC.tabBar.bounds.height)
                        presentingVC.pinnedBarView.isHidden = true
                        fakeTabbar.frame = fakeTabbar.frame.offsetBy(dx: 0, dy: -fakeTabbar.bounds.height)
                        
                        presentedVC.frameBeforePresent()
                        presented.layer.cornerRadius = 0
                        presented.frame = CGRect(x: 0,
                                                 y: container.bounds.height - Constant.tabBarHeight,
                                                 width: container.bounds.width,
                                                 height: Constant.pinnedBarHeight)
                        presented.layoutSubviews()
        }, completion: { (_) in
            if !transitionContext.transitionWasCancelled {
                fakeTabbar.removeFromSuperview()
                self.fakeTabbar = nil
                presentingVC.pinnedBarView.isHidden = false
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            contentsView.layoutSubviews()
        })
    }
    
    //MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return .duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch state {
        case .presenting:
            showPresentingAnimation(using: transitionContext)
        case .hidden:
            showHiddenAnimation(using: transitionContext)
        }
    }
}
