//
//  PanelMaterial.swift
//  Panels_Example
//
//  Created by Antonio Casero on 30.09.18.
//  Copyright © 2018 Antonio Casero. All rights reserved.
//

import Panels
import UIKit

class PanelMaterial: UIViewController, Panelable {
    var Titlee: String!
    var Location: String!
    
    @IBOutlet weak var LblThumbsUpCount: UILabel!
    
    @IBOutlet weak var LblThumbsDownCount: UILabel!
    
    
    
    @IBOutlet var headerHeight: NSLayoutConstraint!
    @IBOutlet var headerPanel: UIView!

    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet var detailsLocation: UILabel!
    
    @IBOutlet weak var DistanceKM: UILabel!
    
    @IBOutlet var Panel: UIView!
    
    @IBOutlet weak var LblCarMin: UILabel!
    
    @IBOutlet weak var LblWalkMin: UILabel!
    
    
    override func viewDidLoad() {
        view.layoutIfNeeded()
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.atmtitleshow(notification:)), name: Notification.Name("UserTappedMarker"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.AtmVotesShow(notification:)), name: Notification.Name("ATMVotes"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.DrivingMode(notification:)), name: Notification.Name("DrivingMode"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.WalkingMode(notification:)), name: Notification.Name("WalkingMode"), object: nil)
        
        
        headerTitle.text = "Select Location"
        headerTitle.adjustsFontSizeToFitWidth = true
        headerTitle.minimumScaleFactor = 0.5
        headerTitle.sizeToFit()
        //headerTitle.preferredMaxLayoutWidth = 150
        detailsLocation.adjustsFontSizeToFitWidth = true
        detailsLocation.minimumScaleFactor = 0.5
        detailsLocation.sizeToFit()
        
            
        }
    
@objc func atmtitleshow(notification: Notification) {
    
    guard let userInfo = notification.userInfo,
          let Atmheading = userInfo["AtmHeading"] as? String,
          let Atmloc = userInfo["AtmLocation"] as? String else {
        print("No UserInfo found")
        return
    }
    
    headerTitle.text = Atmheading
    detailsLocation.text = Atmloc
    
    PanelView()
   
    }
    
    @objc func AtmVotesShow(notification: Notification) {
        
        guard let userInfo = notification.userInfo,
            let UpCount = userInfo["VotesUp"] as? Int,
            let DownCount = userInfo["VotesDown"] as? Int else {
                print("No UserInfo found")
                return
        }
        
        let thumbsUp = String(UpCount)
        let thumbsDown = String(DownCount)
        
        LblThumbsUpCount.text = thumbsUp
        LblThumbsDownCount.text = thumbsDown
        
        
    }
    
    @objc func DrivingMode(notification: Notification) {
        
        guard let userInfo = notification.userInfo,
            let distancestr = userInfo["DrivingDist"] as? String,
            let duration = userInfo["DrivingDuration"] as? String else {
                print("No UserInfo found")
                return
        }
        
        DistanceKM.text = distancestr
        LblCarMin.text = duration
        DistanceKM.adjustsFontSizeToFitWidth = true
        DistanceKM.minimumScaleFactor = 0.5
        DistanceKM.sizeToFit()
        
        
        
        
    }
    
    @objc func WalkingMode(notification: Notification) {
        
        guard let userInfo = notification.userInfo,
            let walkduration = userInfo["Walkingdur"] as? String else {
                print("No UserInfo found")
                return
        }
        
        LblWalkMin.text = walkduration
        
        
    }
    
    func PanelView() {
         Panel.roundCorners([.topLeft,.topRight], radius: 20)
         headerPanel.roundCorners([.topLeft,.topRight], radius: 20)
    
    }
}




