//
//  InfoCardViewController.swift
//  AwesomeCustomTransition
//
//  Created by Ruslan Timchenko on 28/03/2018.
//  Copyright © 2018 Ruslan Timchenko. All rights reserved.
//

import UIKit

protocol InfoCardViewControllerDelegate: class {
    func update(withProgress progress: CGFloat)
}

class InfoCardViewController: UIViewController {

    // Delegates
    weak var delegate: InfoCardViewControllerDelegate?
    
    // Dependencies
    private let componentsFactory = Locator.shared.componentsFactory()
    
    // UI
    private lazy var coverImageView: CoverImageView = componentsFactory.createCoverImageView()
    private lazy var headerButton: HeaderButton = componentsFactory.createHeaderButton()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Helpers
    private var originFrame = CGRect(x: 0, y: 0, width: 0, height: 1)
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHeaderButton()
        setupGestures()
        frameBeforePresent()
    }
    
    // MARK: - Gesture Actions
    @objc private func tapGestureAction(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func panGestureAction(gesture: UIPanGestureRecognizer) {
        let viewTransition = gesture.translation(in: view)
        let progress = viewTransition.y / (originFrame.height - Constant.pinnedBarHeight)
        switch gesture.state {
        case .began:
            originFrame = view.frame
        case .changed:
            if progress > Constant.closedProgressNotReturn {
                endPan(withProgress: progress)
            } else {
                update(withProgress: progress)
            }
        case .cancelled:
            break
        case .ended:
            endPan(withProgress: progress)
            break
        default:
            break
        }
    }

    // MARK: - Handle Transition Progress
    private func update(withProgress progress: CGFloat) {
        delegate?.update(withProgress: progress)
        view.frame = CGRect(x: 0,
                            y: originFrame.origin.y + (originFrame.height - Constant.pinnedBarHeight) * progress,
                            width: view.bounds.width,
                            height: view.bounds.height)
    }
    
    // MARK: - Handle end of the transition
    private func endPan(withProgress progress: CGFloat) {
        if progress > Constant.closedProgressNotReturn {
            dismiss(animated: true, completion: nil)
        } else {
            UIView.animate(withDuration: 0.2 + 0.2 * Double(progress), delay: 0, options: .curveEaseInOut, animations: {
                self.delegate?.update(withProgress: 0)
                self.view.frame = self.originFrame
            })
        }
    }
    
    // MARK: - Setup View
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(headerButton)
        view.addSubview(coverImageView)
    }
    
    // MARK: - Setup Header Button
    private func setupHeaderButton() {
        headerButton.addTarget(self, action: #selector(tapGestureAction(_:)),
                               for: .touchUpInside)
    }
    
    // MARK: - Setup Gestures
    private func setupGestures() {
        let pan = UIPanGestureRecognizer(target: self,
                                         action: #selector(panGestureAction(gesture:)))
        view.addGestureRecognizer(pan)
    }
    
    // MARK: - Frame before and after transition
    public func frameBeforePresent() {
        headerButton.isHidden = true
        coverImageView.layer.cornerRadius = 4
        coverImageView.frame = CGRect(x: 20, y: 10, width: 50, height: 50)
    }
    
    public func frameAfterPresent() {
        headerButton.isHidden = false
        headerButton.frame = CGRect(x: (view.bounds.width - 100) / 2,
                                    y: 10,
                                    width: 100,
                                    height: 5)
        let coverWidth = view.bounds.width * 0.8
        coverImageView.layer.cornerRadius = 8
        coverImageView.frame = CGRect(x: (view.bounds.width - coverWidth) / 2,
                                      y: 40,
                                      width: coverWidth,
                                      height: coverWidth)
    }
}
