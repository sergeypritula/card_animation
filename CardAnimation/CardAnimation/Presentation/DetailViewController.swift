//
//  DetailViewController.swift
//  CardAnimation
//
//  Created by Sergey Pritula on 30.06.2020.
//  Copyright © 2020 Onix-Systems. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
