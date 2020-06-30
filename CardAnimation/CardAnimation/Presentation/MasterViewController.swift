//
//  MasterViewController.swift
//  CardAnimation
//
//  Created by Sergey Pritula on 30.06.2020.
//  Copyright © 2020 Onix-Systems. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    @IBOutlet weak var cardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addGestture()
    }
    
    private func addGestture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        cardView.isUserInteractionEnabled = true
        cardView.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func handleTap() {
        let controller: DetailViewController = Storyboard.main.instantiate()
        controller.modalPresentationStyle = .overFullScreen
        controller.transitioningDelegate = self
        present(controller, animated: true, completion: nil)
    }
    
}


extension MasterViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardPresentAnimator(duration: 1.0, cardImage: cardView)
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CardDismissAnimator(duration: 1.0, cardImage: cardView)
    }
}
