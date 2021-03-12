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
import MarqueeLabel



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
    
    
    @IBOutlet weak var OnlineImg: UIImageView!
    
    @IBOutlet weak var LblThumbsUpCount: UILabel!
    
    @IBOutlet weak var LblThumbsDownCount: UILabel!
    
    @IBOutlet weak var ThumbsUpBtn: UIButton!
    
    @IBOutlet weak var ThumbsDownbtn: UIButton!
    
    @IBOutlet var headerHeight: NSLayoutConstraint!
    @IBOutlet var headerPanel: UIView!

    
    @IBOutlet weak var headerTitle: MarqueeLabel!
    
    @IBOutlet var Panel: UIView!
    
    @IBOutlet weak var VoteView: UIStackView!
    
    @IBOutlet weak var InfoSelect: UIButton!
    
    @IBOutlet weak var VoteSelect: UIButton!
    
    
    @IBOutlet weak var UITextAddress: UITextView!
    
    @IBOutlet weak var LocationSelect: UIStackView!
    
    
    @IBAction func InfoShow(_ sender: Any) {
        VoteView.isHidden = true
        InfoSelect.isSelected = true
        VoteSelect.isSelected = false
        LocationSelect.isHidden = false
        
    }
    
    @IBAction func VoteShow(_ sender: Any) {
        VoteView.isHidden = false
        VoteSelect.isSelected = true
        InfoSelect.isSelected = false
        LocationSelect.isHidden = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()

        ref = Database.database().reference(fromURL: "https://noneatm-atms-locations-data.firebaseio.com/")
        
        DispatchQueue.main.async {
         
        NotificationCenter.default.addObserver(self, selector: #selector(self.atmtitleshow(notification:)), name: Notification.Name("UserTappedMarker"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.AtmVotesShow(notification:)), name: Notification.Name("ATMVotes"), object: nil)
            
        NotificationCenter.default.addObserver(self, selector:#selector(self.AwakeSleep(notification:)),name: UIApplication.didBecomeActiveNotification,object: nil)
      
        }
        
        headerTitle.sizeToFit()
        self.headerTitle.text = "this an ultra long textttttttttttttttttttttt"
        self.headerTitle.type = .continuous
        self.headerTitle.triggerScrollStart()
        self.headerTitle.animationCurve = .easeInOut
        self.headerTitle.labelWillBeginScroll()
        VoteSelect.isSelected = true
        LocationSelect.isHidden = true
        headerTitle.preferredMaxLayoutWidth = 150
        UITextAddress.adjustsFontForContentSizeCategory = true
        UITextAddress.sizeToFit()
        
        
      //  _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(PanelMaterial.marquee), userInfo: nil, repeats: true)
        
        self.PulseAnimation()
    
        }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func AwakeSleep(notification: Notification) {
        self.PulseAnimation()
        
    }
    
    
@objc func atmtitleshow(notification: Notification) {
    
    guard let userInfo = notification.userInfo,
          let Atmheading = userInfo["AtmHeading"] as? String,
          let Atmloc = userInfo["AtmLocation"] as? String
        else {
        print("No UserInfo found")
        return
    }
    
    headerTitle.text = Atmheading
    UITextAddress.text = Atmloc

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

    func PanelView() {
        headerPanel.roundCorners([.topLeft,.topRight], radius: 20)
    
    }
    
    func PulseAnimation() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 1.0
        pulse.toValue = 1.10
        pulse.autoreverses = true
        pulse.initialVelocity = 0.5
        pulse.damping = 0.5
        pulse.repeatCount = .infinity
        OnlineImg.layer.add(pulse, forKey: nil)
    }
    
 
    
//MARK: - Voting System
    @IBAction func VoteUp(_ sender: UIButton) {
        
        sender.isSelected = true
        print("Voted up, selected state \(sender.isSelected)")
        self.ThumbsDownbtn.isSelected = false
        voting(1)
        
        UpdateVotingLabels()
   
    }
    
    @IBAction func VotesDown(_ sender: UIButton) {
        
        sender.isSelected = true
        print("Voted down, selected state \(sender.isSelected)")
        self.ThumbsUpBtn.isSelected = false
        voting(-1)
        
        UpdateVotingLabels()

    }
    
    func UpdateVotingLabels() {
        
        let uid = AtmInfo.string(forKey: "uid") ?? " "
        let atmkind = AtmInfo.string(forKey: "atmkind") ?? " "
        
        ref.child("\(atmkind)/\(uid)/votesDownCount").observeSingleEvent(of: .value) {
              (snapshot) in
              if let VoteDown = snapshot.value as? Int {
                  self.LblThumbsDownCount.text = "\(VoteDown)"
              }
          }
        
        ref.child("\(atmkind)/\(uid)/votesUpCount").observeSingleEvent(of: .value) {
              (snapshot) in
              if let VoteUp = snapshot.value as? Int {
                  self.LblThumbsUpCount.text = "\(VoteUp)"
              }
          }
        
    }
    
    func voting (_ buttonVote: Int) {
        
        let uid = AtmInfo.string(forKey: "uid") ?? " "
        let atmkind = AtmInfo.string(forKey: "atmkind") ?? " "
        let thumbsup = AtmInfo.integer(forKey: "thumbsup")
        let thumbsdown = AtmInfo.integer(forKey: "thumbsdown")
        
        VoteUpCount = thumbsup
        VoteDownCount = thumbsdown
        
        //If no votes recorded yet i.e. user has not voted yet
        if self.noVotes {
            if buttonVote == 1 {
                
                self.VoteUpCount = VoteUpCount + 1
                self.userVotedUP = true
                
                //Write data to Firebase
                let votingref = self.ref.child("\(atmkind)/\(uid)/votesUpCount")
                  votingref.setValue(self.VoteUpCount)
                print(votingref)
                
            } else {
                
                self.VoteDownCount = VoteDownCount + 1
                self.userVotedDown = true
                
                //Write data to Firebase
                let votingreff = self.ref.child("\(atmkind)/\(uid)/votesDownCount")
                votingreff.setValue(self.VoteDownCount)
            }
            self.noVotes = false //User has voted
        }
    
        //User wants to change vote
       else {
            // UpVote button
            switch buttonVote {
            case 1 :
                
                if self.userVotedUP == true {
                    //Do nothing
                    print("User already voted up")
                }
                else if self.userVotedUP == false {
                    
                    //change vote from dislike to like
                    self.VoteUpCount  = VoteUpCount + 1
//                  
                    
                    //Reset flags
                    self.userVotedUP = true
                    self.userVotedDown = false
                    
                    //Write multiple votes to Firebase
                    self.ref.updateChildValues(["\(atmkind)/\(uid)/votesUpCount": self.VoteUpCount,
                                           "\(atmkind)/\(uid)/votesDownCount": self.VoteDownCount])
                    
                }
                
                //DownVote Button
                case -1 :
                
                    if self.userVotedDown == true {
                    //Do nothing
                    print("User already voted up")
                }
                    else if self.userVotedDown == false {
                    
                    //change vote from like to dislike
//
                    self.VoteDownCount = VoteDownCount + 1
                    
                    //Reset flags
                    self.userVotedUP = false
                    self.userVotedDown = true
                    
                    //Write multiple votes to Firebase
                        self.ref.updateChildValues(["\(atmkind)/\(uid)/votesUpCount": self.VoteUpCount,
                                           "\(atmkind)/\(uid)/votesDownCount": self.VoteDownCount])
                    
                }
            default:
                print("")
            }
        }
      }
    
    
   
 
}

extension PanelMaterial {
    @objc func marquee(){
        
        let str = headerTitle.text!
        let indexFirst = str.index(str.startIndex, offsetBy: 0)
        let indexSecond = str.index(str.startIndex, offsetBy: 1)
        headerTitle.text = String(str.suffix(from: indexSecond)) +  String(str[indexFirst])
        
    }
}





