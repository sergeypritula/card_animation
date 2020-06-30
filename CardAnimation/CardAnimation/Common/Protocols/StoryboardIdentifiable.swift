//
//  StoryboardIdentifiable.swift
//  CardAnimation
//
//  Created by Sergey Pritula on 30.06.2020.
//  Copyright © 2020 Onix-Systems. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self.self)
    }
}

extension UIStoryboard {
    func instantiate<T: StoryboardIdentifiable>() -> T {
        guard let vc = instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Controller is nil with the identifier: \(T.storyboardIdentifier)")
        }
        return vc
    }
}

extension UIViewController: StoryboardIdentifiable {}
