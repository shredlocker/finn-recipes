//
//  TransitionAnimator.swift
//  AppStoreTransition
//
//  Created by Granheim Brustad , Henrik on 10/07/2018.
//  Copyright © 2018 Granheim Brustad , Henrik. All rights reserved.
//

import UIKit

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.6
    let damping: CGFloat = 0.8
    let cell: UICollectionViewCell
    var initialFrame: CGRect
    var state = UINavigationControllerOperation.none
    
    lazy var shadowView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 16
        view.layer.shadowOffset = CGSize(width: 0, height: 8)
        return view
    }()
    
    init(cell: UICollectionViewCell, frame: CGRect) {
        self.cell = cell
        self.initialFrame = frame
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch state {
        case .push:
            present(using: transitionContext)
        case .pop:
            dismiss(using: transitionContext)
        default:
            return
        }
    }
}

extension TransitionAnimator {
    
    private func present(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        cell.isHidden = true
        
        guard let toViewController = transitionContext.viewController(forKey: .to) as? ObjectViewController else { return }
        toViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(shadowView)
        containerView.addSubview(toViewController.view)
        
        toViewController.containerViewConstraints = EdgeConstraints(view: toViewController.view, container: containerView, frame: initialFrame)
        toViewController.containerViewConstraints?.toggleConstraints(true)
        containerView.layoutIfNeeded()
        
        shadowView.frame = initialFrame
        toViewController.view.layer.cornerRadius = 16
        toViewController.closeButton.alpha = 0
        
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: damping) {
            toViewController.containerViewConstraints?.constants(to: 0)
            containerView.layoutIfNeeded()
            toViewController.view.layer.cornerRadius = 0
            self.shadowView.frame = containerView.frame
            toViewController.closeButton.alpha = 1
        }
        animator.addCompletion { (position) in
            self.shadowView.removeFromSuperview()
            transitionContext.completeTransition(position == .end)
        }
        animator.startAnimation()
    }
    
    private func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        cell.transform = .identity
        let frame = cell.convert(cell.contentView.frame, to: containerView)
        
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        guard let fromViewController = transitionContext.viewController(forKey: .from) as? ObjectViewController else { return }
        
        containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
        containerView.insertSubview(shadowView, belowSubview: fromViewController.view)
        
        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: damping) {
            fromViewController.containerViewConstraints?.match(to: frame, container: containerView)
            containerView.layoutIfNeeded()
            fromViewController.view.layer.cornerRadius = 16
            self.shadowView.frame = frame
            fromViewController.closeButton.alpha = 0
        }
        animator.addCompletion { (position) in
            self.cell.isHidden = false
            self.shadowView.removeFromSuperview()
            fromViewController.view.removeFromSuperview()
            transitionContext.completeTransition(position == .end)
        }
        animator.startAnimation()
        
    }
}
