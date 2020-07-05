//
//  OfflineViewController.swift
//  NoneAttm
//
//  Created by Daniel Senga on 2020/05/19.
//  Copyright © 2020 Daniel Senga. All rights reserved.
//

import Foundation
import UIKit

class OfflineViewController: UIViewController {
    
    let network = NetworkManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If the network is reachable show the main controller
        network.reachability.whenReachable = { _ in
            self.showMainController()
        }
    }
    
    
    private func showMainController() -> Void {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "MainController", sender: self)
        }
    }
    
}
