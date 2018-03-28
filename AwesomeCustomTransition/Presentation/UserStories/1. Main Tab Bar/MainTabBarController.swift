//
//  MainTabBarController.swift
//  AwesomeCustomTransition
//
//  Created by Ruslan Timchenko on 27/03/2018.
//  Copyright © 2018 Ruslan Timchenko. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    // Dependencies
    private let componentsFactory = Locator.shared.componentsFactory()
    
    // UI
    public lazy var pinnedBarView: PinnedBarView = componentsFactory.createPinnedBarView()
    
    // Animators
    var presentationAnimator: PresentationController?
    var interactiveAnimator: InteractiveAnimator?
    
    // MARK: - Tab Bar Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPinnedBarView()
        setupGestures()
        setupInteractiveAnimator()
    }
    
    // MARK: - Gesture Actions
    @objc private func tapGestureAction(_ sender: UITapGestureRecognizer) {
        presentInfoCard()
    }
    
    // MARK: - Setup Pinned Bar
    private func setupPinnedBarView() {
        let barFrame = CGRect(x: 0,
                              y: view.bounds.height - 120,
                              width: view.bounds.width,
                              height: 120)
        pinnedBarView.frame = barFrame
        view.insertSubview(pinnedBarView, belowSubview: tabBar)
    }
    
    // MARK: - Setup Gestures
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(tapGestureAction(_:)))
        pinnedBarView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Setup Animators
    private func setupInteractiveAnimator() {
        interactiveAnimator = InteractiveAnimator(attachTo: pinnedBarView)
        interactiveAnimator?.delegate = self
    }
    
    // MARK: - Present Info Card View Controller
    private func presentInfoCard() {
        let vc = InfoCardViewController()
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.modalPresentationCapturesStatusBarAppearance = true
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension MainTabBarController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator?.isPresenting = true
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator?.isPresenting = false
        return presentationAnimator
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        self.presentationAnimator = PresentationController(presentedViewController: presented, presenting: presenting)
        return presentationAnimator
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveAnimator
    }
}

// MARK: - InfoCardViewControllerDelegate
extension MainTabBarController: InfoCardViewControllerDelegate {
    func update(withProgress progress: CGFloat) {
        guard let currView = selectedViewController?.view else { return }
        currView.transform = CGAffineTransform.identity.scaledBy(x: 0.95 + 0.05 * progress,
                                                                 y: 0.95 + 0.05 * progress)
    }
}

// MARK: - InteractiveAnimatorDelegate
extension MainTabBarController: InteractiveAnimatorDelegate {
    func presentInteractive() {
        presentInfoCard()
    }
}
