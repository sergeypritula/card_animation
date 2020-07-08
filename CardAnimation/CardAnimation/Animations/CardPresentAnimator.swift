//
//  CardPresentAnimator.swift
//  ChicoreeAppProd
//
//  Created by Sergey Pritula on 20.06.2020.
//  Copyright © 2020 Edge5 AG. All rights reserved.
//

import UIKit

class CardPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private var duration: TimeInterval
    private var cardImage: UIView

    init(duration: TimeInterval, cardImage: UIView) {
        self.duration = duration
        self.cardImage = cardImage
    }

    func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard
            let toVC = transitionContext.viewController(forKey: .to) as? DetailViewController
            else {
                transitionContext.completeTransition(true)
                return
        }
        
        // Check this, why we need layout subviews here?
        toVC.view.layoutSubviews()
        containerView.addSubview(toVC.view)
        
        guard
            let cardViewSnapshot = toVC.cardView.snapshotView(afterScreenUpdates: true),
            let closeButtonSnapshot = toVC.closeButton.snapshotView(afterScreenUpdates: true),
            let cardImageViewSnapshot = cardImage.snapshotView(afterScreenUpdates: true)
            else  {
                transitionContext.completeTransition(true)
                return
        }
        
        print("\(#function) frame: \(toVC.cardView.frame)")
        
        let cardBackgroundSnapshot = UIView()
        cardBackgroundSnapshot.frame = toVC.view.frame
        cardBackgroundSnapshot.backgroundColor = .clear


        let backgroundView: UIView
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = toVC.backgroundView.backgroundColor

        backgroundView = UIView(frame: containerView.bounds)
        backgroundView.addSubview(fadeView)
        
        fadeView.alpha = 0
        toVC.view.alpha = 0

        let cardRect = toVC.cardView.convert(toVC.cardView.bounds, to: nil)
        let closeButtonRect = toVC.closeButton.convert(toVC.closeButton.bounds, to: nil)
        
        print("cardRect: \(cardRect)")
        
        cardImageViewSnapshot.frame = cardImage.convert(cardImage.bounds, to: nil)
        cardViewSnapshot.frame = cardImage.convert(cardImage.bounds, to: nil)
        
        cardBackgroundSnapshot.addSubview(cardImageViewSnapshot)
        cardBackgroundSnapshot.addSubview(cardViewSnapshot)
        
        cardBackgroundSnapshot.addSubview(closeButtonSnapshot)

        [backgroundView, cardBackgroundSnapshot].forEach { containerView.addSubview($0) }
        containerView.sendSubviewToBack(backgroundView)

        cardImageViewSnapshot.alpha = 1
        cardViewSnapshot.alpha = 0

        cardViewSnapshot.layer.transform = AnimationHelper.yRotation(-.pi / 2)

        closeButtonSnapshot.frame = closeButtonRect
        closeButtonSnapshot.alpha = 0

        cardImage.isHidden = true

        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .layoutSubviews,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                    fadeView.alpha = 1.0
                    closeButtonSnapshot.alpha = 1.0
                }

                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1 / 2) {
                    cardImageViewSnapshot.layer.transform = AnimationHelper.yRotation(-.pi / 2)
                    
                    cardViewSnapshot.alpha = 1.0
                }

                UIView.addKeyframe(withRelativeStartTime: 1 / 2, relativeDuration: 1 / 2) {
                    cardViewSnapshot.layer.transform = AnimationHelper.yRotation(0.0)
                }

                UIView.addKeyframe(withRelativeStartTime: 1 / 5, relativeDuration: 4 / 5) {
                    cardImageViewSnapshot.frame = cardRect
                    cardViewSnapshot.frame = cardRect
                }

            },
            completion: { _ in
                backgroundView.removeFromSuperview()
                cardBackgroundSnapshot.removeFromSuperview()
                toVC.view.alpha = 1

                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
