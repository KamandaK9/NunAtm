//
//  PanelMaterial.swift
//  Panels_Example
//
//  Created by Antonio Casero on 30.09.18.
//  Copyright © 2018 Antonio Casero. All rights reserved.
//

import Panels
import UIKit
import Firebase

class PanelMaterial: UIViewController, Panelable {
    var Titlee: String!
    var Location: String!
    let AtmInfo = UserDefaults.standard
    
    var ref: DatabaseReference!
    
    var noVotes = true
    var userVotedUP = false
    var userVotedDown = false
    var VoteUpCount = 0
    var VoteDownCount = 0
    
    @IBOutlet weak var LblThumbsUpCount: UILabel!
    
    @IBOutlet weak var LblThumbsDownCount: UILabel!
    
    @IBOutlet weak var ThumbsUpBtn: UIButton!
    
    @IBOutlet weak var ThumbsDownbtn: UIButton!
    
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
        
        ref = Database.database().reference(fromURL: "https://noneatm-atms-locations-data.firebaseio.com/")
        
        DispatchQueue.main.async {
         
        NotificationCenter.default.addObserver(self, selector: #selector(self.atmtitleshow(notification:)), name: Notification.Name("UserTappedMarker"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.AtmVotesShow(notification:)), name: Notification.Name("ATMVotes"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.DrivingMode(notification:)), name: Notification.Name("DrivingMode"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.WalkingMode(notification:)), name: Notification.Name("WalkingMode"), object: nil)
        
        }
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
            let UpCount = userInfo["VotesUp"] as? String,
            let uid = userInfo["uid"] as? String,
            let atmkind = userInfo["ATMKind"] as? String,
            let DownCount = userInfo["VotesDown"] as? String else {
                print("No UserInfo found")
                return
        
        }
        
            print(uid)
             let thumbsUp = String(UpCount)
             let thumbsDown = String(DownCount)
            
        
             LblThumbsUpCount.text = thumbsUp
             LblThumbsDownCount.text = thumbsDown
        
            
        
            AtmInfo.set(uid, forKey: "uid")
            AtmInfo.set(atmkind, forKey: "atmkind")
            AtmInfo.set(thumbsUp, forKey: "thumbsup")
            AtmInfo.set(thumbsDown, forKey: "thumbsdown")
            
        
    
        
        
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
    
    @IBAction func VoteUp(_ sender: UIButton) {
        
        sender.isSelected = true
        print("Voted up, selected state \(sender.isSelected)")
        self.ThumbsDownbtn.isSelected = false
        voting(buttonVote: 1)
        
    }
    
    @IBAction func VotesDown(_ sender: UIButton) {
        
        sender.isSelected = true
        print("Voted down, selected state \(sender.isSelected)")
        self.ThumbsUpBtn.isSelected = false
        voting(buttonVote: -1)
    }
    
    func voting (buttonVote: Int) {
        
        let uid = AtmInfo.string(forKey: "uid") ?? " "
        let atmkind = AtmInfo.string(forKey: "atmkind") ?? " "
        let thumbsup = AtmInfo.integer(forKey: "thumbsup")
        let thumbsdown = AtmInfo.integer(forKey: "thumbsdown")
        
        let databaseref = "\(atmkind)/\(uid)/votesUpCount"
        
        VoteUpCount = thumbsup
        VoteDownCount = thumbsdown
        
        //If no votes recorded yet i.e. user has not voted yet
        if self.noVotes {
            
            if buttonVote == 1 {
                
                self.VoteUpCount += 1
                self.userVotedUP = true
                
                //Write data to Firebase
                let votingref = ref.child(databaseref)
                votingref.setValue(self.VoteUpCount)
                print(votingref)
                
                //Read VotesUpCount from Firebase. Updating UI
               ref.child("\(atmkind)/\(uid)/votesUpCount").observeSingleEvent(of: .value) {
                   (snapshot) in
                   if let VoteUp = snapshot.value as? Int {
                       self.LblThumbsUpCount.text = "\(VoteUp)"
                   }
               }
            }
            else {
                self.VoteDownCount += 1
                self.userVotedDown = true
                
                //Write data to Firebase
              let votingreff = self.ref.child("\(atmkind)/\(uid)/votesDownCount")
                votingreff.setValue(self.VoteDownCount)
                
                //Read VotesUpCount from Firebase. Updating UI
                ref.child("\(atmkind)/\(uid)/votesDownCount").observeSingleEvent(of: .value) {
                    (snapshot) in
                    if let VoteDown = snapshot.value as? Int {
                        self.LblThumbsDownCount.text = "\(VoteDown)"
                    }
                }
            }
            self.noVotes = false //User has voted
        }
        
        //User wants to change vote
        else {
            
            switch buttonVote {
            case 1:
                
                if userVotedUP {
                    //Do nothing
                    print("User already voted up")
                }
                else {
                    
                    //change vote from dislike to like
                    self.VoteUpCount  += 1
                    self.VoteDownCount -= 1
                    
                    //Reset flags
                    self.userVotedUP = true
                    self.userVotedDown = false
                    
                    //Write multiple votes to Firebase
                    ref.updateChildValues(["\(atmkind)/\(uid)/votesUpCount": self.VoteUpCount,
                                           "\(atmkind)/\(uid)/votesDownCount": self.VoteDownCount])
                    
                    //Read VotesUpCount from Firebase. Updating UI
                    ref.child("\(atmkind)/\(uid)/votesDownCount").observeSingleEvent(of: .value) {
                        (snapshot) in
                        if let VoteDown = snapshot.value as? Int {
                            self.LblThumbsDownCount.text = "\(VoteDown)"
                        }
                    }
                    
                    
                }
                
                case -1:
                
                if userVotedDown{
                    //Do nothing
                    print("User already voted up")
                }
                else {
                    
                    //change vote from like to dislike
                    self.VoteUpCount  -= 1
                    self.VoteDownCount += 1
                    
                    //Reset flags
                    self.userVotedUP = false
                    self.userVotedDown = true
                    
                    //Write multiple votes to Firebase
                    ref.updateChildValues(["\(atmkind)/\(uid)/votesUpCount": self.VoteUpCount,
                                           "\(atmkind)/\(uid)/votesDownCount": self.VoteDownCount])
                    
                    //Read VotesUpCount from Firebase. Updating UI
                    ref.child("\(atmkind)/\(uid)/votesDownCount").observeSingleEvent(of: .value) {
                        (snapshot) in
                        if let VoteDown = snapshot.value as? Int {
                            self.LblThumbsDownCount.text = "\(VoteDown)"
                        }
                    }
                }
            default:
                print("")
            }
        }
    }
}




