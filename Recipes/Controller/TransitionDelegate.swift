//
//  TransitionDelegate.swift
//  AppStoreTransition
//
//  Created by Granheim Brustad , Henrik on 10/07/2018.
//  Copyright © 2018 Granheim Brustad , Henrik. All rights reserved.
//

import UIKit

class NavigationTransitionDelegate: NSObject, UINavigationControllerDelegate {
    
    var transitionAnimator: TransitionAnimator?
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .push:
            navigationController.setNavigationBarHidden(true, animated: true)
        case .pop:
            navigationController.setNavigationBarHidden(false, animated: true)
        default:
            break
        }
        
        transitionAnimator?.state = operation
        return transitionAnimator
    }
}
