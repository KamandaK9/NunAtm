//
//  PassthroughView.swift
//  NoneAttm
//
//  Created by Daniel Senga on 2020/05/18.
//  Copyright © 2020 Daniel Senga. All rights reserved.
//

import Foundation
import UIKit

class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
        
    }
}
