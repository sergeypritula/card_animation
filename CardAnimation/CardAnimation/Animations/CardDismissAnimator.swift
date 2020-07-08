//
//  CardDismissAnimator.swift
//  ChicoreeAppProd
//
//  Created by Sergey Pritula on 23.06.2020.
//  Copyright © 2020 Edge5 AG. All rights reserved.
//

import UIKit

class CardDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {
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
        cardImage.isHidden = false
        
        guard
            let toVC = transitionContext.viewController(forKey: .to) as? MasterViewController,
            let fromVC = transitionContext.viewController(forKey: .from) as? DetailViewController,
            let cardViewSnapshot = fromVC.cardView.snapshotView(afterScreenUpdates: true),
            let closeButtonSnapshot = fromVC.closeButton.snapshotView(afterScreenUpdates: true),
            let cardImageViewSnapshot = cardImage.snapshotView(afterScreenUpdates: true)
            else {
                transitionContext.completeTransition(true)
                return
        }

        let cardBackgroundSnapshot = UIView()
        cardBackgroundSnapshot.frame = fromVC.view.frame
        cardBackgroundSnapshot.backgroundColor = .clear

        let backgroundView: UIView
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = fromVC.backgroundView.backgroundColor

        backgroundView = UIView(frame: containerView.bounds)
        backgroundView.addSubview(fadeView)
        fadeView.alpha = 1.0
        
        let cardRect = fromVC.cardView.convert(fromVC.cardView.bounds, to: nil)
        let closeButtonRect = fromVC.closeButton.convert(fromVC.closeButton.bounds, to: nil)
        let cardToFrame = cardImage.convert(cardImage.bounds, to: nil)
        
        cardImageViewSnapshot.frame = cardRect
        cardViewSnapshot.frame = cardRect
        
        cardBackgroundSnapshot.addSubview(cardImageViewSnapshot)
        cardBackgroundSnapshot.addSubview(cardViewSnapshot)
        
        cardBackgroundSnapshot.addSubview(closeButtonSnapshot)
        
        [backgroundView, cardBackgroundSnapshot].forEach { containerView.addSubview($0) }
        containerView.sendSubviewToBack(backgroundView)
        
        cardImageViewSnapshot.alpha = 0
        cardViewSnapshot.alpha = 1
        
        cardImageViewSnapshot.layer.transform = AnimationHelper.yRotation(.pi / 2)
        
        closeButtonSnapshot.frame = closeButtonRect
        closeButtonSnapshot.alpha = 1

        toVC.view.alpha = 1.0
        toVC.cardView?.isHidden = true

        fromVC.view.alpha = 0

        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeLinear,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                    cardImageViewSnapshot.frame = cardToFrame
                    cardViewSnapshot.frame = cardToFrame
                        
                    fadeView.alpha = 0.0
                    closeButtonSnapshot.alpha = 0.0
                }

                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1 / 2) {
                    cardViewSnapshot.layer.transform = AnimationHelper.yRotation(.pi / 2)
                }

                UIView.addKeyframe(withRelativeStartTime: 1 / 2, relativeDuration: 0) {
                    cardViewSnapshot.alpha = 0
                    cardImageViewSnapshot.alpha = 1
                }

                UIView.addKeyframe(withRelativeStartTime: 1 / 2, relativeDuration: 1 / 2) {
                    cardImageViewSnapshot.layer.transform = AnimationHelper.yRotation(0.0)
                }
            },
            completion: { _ in
                backgroundView.removeFromSuperview()
                cardBackgroundSnapshot.removeFromSuperview()

                toVC.cardView?.isHidden = false

                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
