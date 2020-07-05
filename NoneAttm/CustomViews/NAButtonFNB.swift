//
//  NAButtonFNB.swift
//  NoneAttm
//
//  Created by Daniel Senga on 2020/03/12.
//  Copyright © 2020 Daniel Senga. All rights reserved.
//

import Foundation
import UIKit

class NAButtonFNB: UIButton {
    
    let bimage = UIImage(named: "FNB Button")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        
        self.setImage(bimage, for: .normal)
        
    }
}
