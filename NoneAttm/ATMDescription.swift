//
//  ATMDescription.swift
//  NoneAttm
//
//  Created by Daniel Senga on 2020/01/27.
//  Copyright © 2020 Daniel Senga. All rights reserved.
//

import UIKit
import Panels

class ATMDescription: UIViewController, Panelable {

    
 @IBOutlet var headerHeight: NSLayoutConstraint!
 @IBOutlet var headerPanel: UIView!
        
        override func viewDidLoad() {
            view.addBlurBackground()
            curveTopCorners()
            view.layoutIfNeeded()
            super.viewDidLoad()
        }
    
        // Do any additional setup after loading the view.
    }
    




