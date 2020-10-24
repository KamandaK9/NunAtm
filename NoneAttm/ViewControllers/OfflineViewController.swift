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
    
    let OfflineScreen = UIImageView()
    let network = NetworkManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If the network is reachable show the main controller
        network.reachability.whenReachable = { _ in
            self.showMainController()
            
        }
        self.setBackground()
    }
    
    
    private func showMainController() -> Void {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "MainController", sender: self)
        }
    }
    
    func setBackground() {
          view.addSubview(OfflineScreen)
          OfflineScreen.translatesAutoresizingMaskIntoConstraints = false
          OfflineScreen.contentMode = .scaleAspectFill
          OfflineScreen.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
          OfflineScreen.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
          OfflineScreen.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
          OfflineScreen.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
          
          OfflineScreen.image = UIImage(named: "Offline")
          view.sendSubviewToBack(OfflineScreen)
      }
    
}
