//
//  VTTransitionManager.swift
//  SlideMeun
//
//  Created by Vinte on 2019/8/6.
//  Copyright © 2019 Vinte. All rights reserved.
//

import UIKit

@objc protocol VTTransitionManagerDelegate {
    func dismiss()
}

class VTTransitionManager: NSObject {
    var duration = 0.5
    var isPresenting = false
    var delegate : VTTransitionManagerDelegate?
    var snapshot : UIView? {
        didSet {
            if let _delegate = delegate {
                let tapGestureRecognizer = UITapGestureRecognizer(target: _delegate, action: #selector(VTTransitionManagerDelegate.dismiss))
                snapshot?.addGestureRecognizer(tapGestureRecognizer)
            }
        }
    }
}

extension VTTransitionManager : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        let container = transitionContext.containerView
        let moveLeft = CGAffineTransform(translationX: 250, y: 0)
        let moveRight = CGAffineTransform(translationX: 0, y: 0)
        
        if isPresenting {
            snapshot = fromView.snapshotView(afterScreenUpdates: true)
            container.addSubview(toView)
            container.addSubview(snapshot!)
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.3, options: .curveEaseInOut, animations: {
            if self.isPresenting {
                self.snapshot?.transform = moveLeft
                toView.transform = .identity
            } else {
                self.snapshot?.transform = .identity
                fromView.transform = moveRight
            }
            
        }, completion: { finished in
            transitionContext.completeTransition(true)
            if !self.isPresenting {
                self.snapshot?.removeFromSuperview()
            }
        })
    }
}

extension VTTransitionManager : UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
}
