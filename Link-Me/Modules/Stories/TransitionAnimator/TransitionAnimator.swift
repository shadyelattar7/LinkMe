//
//  TransitionAnimator.swift
//  Link-Me
//
//  Created by Al-attar on 20/07/2023.
//

import Foundation
import UIKit



class StoriesPresentingAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1 // Adjust the duration of the animation as desired
    }
//
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
        let containerView = transitionContext.containerView

        // Set the initial position and alpha for the presented view controller
        toViewController.view.frame = CGRect(x: 0, y: containerView.frame.height, width: containerView.frame.width, height: containerView.frame.height)
        toViewController.view.alpha = 0.0

        containerView.addSubview(toViewController.view)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            // Animate the final position and alpha for the presented view controller
            toViewController.view.frame = containerView.frame
            toViewController.view.alpha = 1.0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//           guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
//           let containerView = transitionContext.containerView
//
//           // Set the initial position of the presented view off the screen
//           toViewController.view.frame = CGRect(x: 0, y: containerView.frame.height, width: containerView.frame.width, height: containerView.frame.height)
//           containerView.addSubview(toViewController.view)
//
//           // Animate the view into the screen
//           UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
//               toViewController.view.frame = containerView.bounds
//           }, completion: { _ in
//               transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//           })
//       }

//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
//        let containerView = transitionContext.containerView
//
//        // Set the initial position for the presented view controller
//        toViewController.view.frame = CGRect(x: 0, y: containerView.frame.height, width: containerView.frame.width, height: containerView.frame.height)
//
//        containerView.addSubview(toViewController.view)
//
//        // Animate the presented view controller with UIViewPropertyAnimator
//        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 0.8)
//        animator.addAnimations {
//            toViewController.view.frame = containerView.frame
//        }
//        animator.addCompletion { _ in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
//        animator.startAnimation()
//    }
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }
//        let containerView = transitionContext.containerView
//
//        // Set the initial position for the presented view controller
//        toViewController.view.frame = CGRect(x: 0, y: containerView.frame.height, width: containerView.frame.width, height: containerView.frame.height)
//
//        containerView.addSubview(toViewController.view)
//
//        // Animate the presented view controller with UIViewPropertyAnimator
//        let animator = UIViewPropertyAnimator(duration: transitionDuration(using: transitionContext), dampingRatio: 0.8)
//        animator.addAnimations {
//            toViewController.view.frame = containerView.frame
//        }
//        animator.addCompletion { _ in
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        }
//        animator.startAnimation()
//    }
    
}
