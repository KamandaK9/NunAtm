//
//  ButtonXtras.swift
//  NoneAttm
//
//  Created by Daniel Senga on 2020/08/06.
//  Copyright © 2020 Daniel Senga. All rights reserved.
//


import Foundation
import UIKit

class ButtonXtras: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(.allCorners, radius: 30)
        dropShadow()
    }
}
