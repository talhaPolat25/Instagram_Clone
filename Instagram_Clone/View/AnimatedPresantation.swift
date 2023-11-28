//
//  AnimatedPresantation.swift
//  Instagram_Clone
//
//  Created by talha polat on 25.11.2023.
//

import UIKit

class AnimatedPresantation:NSObject,UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let toView = transitionContext.view(forKey: .to) else{return}
        
        toView.frame = CGRect(x: CGFloat(-toView.frame.width), y: 0, width: toView.frame.width, height: toView.frame.height)
        containerView.addSubview(toView)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .curveEaseOut,animations:  {
            toView.frame = CGRect(x: 0, y: 0, width: CGFloat(toView.frame.width), height: toView.frame.height)
        }){result in
            transitionContext.completeTransition(true)
        }
        
    }
}
