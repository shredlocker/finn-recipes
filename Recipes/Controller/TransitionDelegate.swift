//
//  TransitionDelegate.swift
//  AppStoreTransition
//
//  Created by Granheim Brustad , Henrik on 10/07/2018.
//  Copyright © 2018 Granheim Brustad , Henrik. All rights reserved.
//

import UIKit

class TransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var transitionAnimator: TransitionAnimator?
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator?.state = .push
        return transitionAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transitionAnimator?.state = .pop
        return transitionAnimator
    }
}
