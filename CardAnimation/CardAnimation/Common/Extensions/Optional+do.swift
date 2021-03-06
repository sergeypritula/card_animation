//
//  Optional+do.swift
//  CardAnimation
//
//  Created by Sergey Pritula on 30.06.2020.
//  Copyright © 2020 Onix-Systems. All rights reserved.
//

import Foundation

public extension Optional {
    func `do`(_ action: (Wrapped) -> Void) {
        map(action)
    }
}
