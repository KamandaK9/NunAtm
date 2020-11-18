//
//  LaunchViewController.swift
//  NoneAttm
//
//  Created by Daniel Senga on 2020/05/19.
//  Copyright © 2020 Daniel Senga. All rights reserved.
//

import Foundation
import UIKit

class LaunchViewController: UIViewController {
    
    let backgroundImageView = UIImageView()
    
    let network: NetworkManager = NetworkManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If the network is unreachable show the offline page
        NetworkManager.isUnreachable { _ in
            self.showOfflinePage()
            }
        
        // If the network is reachable show the main page
        NetworkManager.isReachable { _ in
            self.showMainPage()
        }
        
        setBackground()
        
    }
    
     private func showOfflinePage() -> Void {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.performSegue(withIdentifier: "NetworkUnavailable", sender: self)
        }
    }
    
     private func showMainPage() -> Void {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.performSegue(withIdentifier: "MainController", sender: self)
        }
    }
    
    func setBackground() {
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        backgroundImageView.image = UIImage(named: "MainScreen")
        view.sendSubviewToBack(backgroundImageView)
    }
    
    
}
