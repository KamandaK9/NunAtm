//
//  RoundView.swift
//  NoneAttm
//
//  Created by Daniel Senga on 2020/08/06.
//  Copyright © 2020 Daniel Senga. All rights reserved.
//

import Foundation
import UIKit

class RoundView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()

        self.roundCorners(.allCorners, radius: 20)
        
        
    }
}

