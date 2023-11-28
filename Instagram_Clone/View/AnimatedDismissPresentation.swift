//
//  AnimatedDismissPresentation.swift
//  Instagram_Clone
//
//  Created by talha polat on 25.11.2023.
//

import UIKit

class AnimatedDismissPresentation:NSObject,UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from) else{return}
        guard let toView = transitionContext.view(forKey: .to) else{return}
        
       // containerView.addSubview(toView)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .curveEaseOut, animations: {
            
            fromView.frame = CGRect(x: -fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
        })
        {result in
            transitionContext.completeTransition(true)
        }
    }
}
