//
//  CustomAnimation.swift
//  Carento
//
//  Created by Tuan Anh Vu on 10/10/17.
//  Copyright © 2017 Carento. All rights reserved.
//

import Foundation
import UIKit

enum CustomNavigationTransitionMode {
    case present, pop
}

class NavAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    var transitionMode: CustomNavigationTransitionMode = .present
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(true)
            return
        }
        guard let fromView = transitionContext.view(forKey: .from) else {
            transitionContext.completeTransition(true)
            return
        }
        
//        let duration = transitionDuration(using: transitionContext)
        
        switch transitionMode {
        case .present:
            containerView.addSubview(toView)
            containerView.addSubview(fromView)
            containerView.bringSubview(toFront: toView)
            
            transitionContext.completeTransition(true)
        default: // pop
            containerView.addSubview(toView)
            containerView.addSubview(fromView)
            containerView.bringSubview(toFront: fromView)
            
            transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
}
