//
//  SelectATMViewController.swift
//  NoneAttm
//
//  Created by Daniel Senga on 2020/01/25.
//  Copyright © 2020 Daniel Senga. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import FirebaseDatabase
import GoogleSignIn
import FBSDKCoreKit



class SelectATMViewController: UIViewController {

    
    @IBOutlet weak var onLogin: UIButton!
    
 let backgroundImageView = UIImageView()
 let UserInfo = UserDefaults.standard
 let greeting = "Hi, "
    
    
 let appDelegate = UIApplication.shared.delegate as! AppDelegate
 let network: NetworkManager = NetworkManager.sharedInstance
    @IBOutlet weak var HeaderBlck: UIView!
    
    
    
    
    @IBAction func RemoveFirstLaunch(_ sender: Any) {
        
        UserInfo.removeObject(forKey:" isAppAlreadyLaunchedOnce")
        UserInfo.removeObject(forKey: "Name")
        let name = self.UserInfo.object(forKey: "Name")
        let remove = self.UserInfo.object(forKey: "hasAlreadyLaunched")
        print("Object removed" + (remove as? String ?? "Me") + (name as? String ?? "Me") )
        
    }
    @IBOutlet weak var Avatar: UIImageView!
    @IBOutlet weak var onSignO: UIButton!
    

    
  
    //MARK: - All buttons for ATM selection, keyword and color of path is sent over to mapview
    @IBAction func onSignOut(_ sender: Any) {
        //try! Auth.auth().signOut()
        // Sign out from Google
            GIDSignIn.sharedInstance()?.signOut()
            
            // Sign out from Firebase
            do {
                try Auth.auth().signOut()
                
                // Update screen after user successfully signed out
            } catch let error as NSError {
                print ("Error signing out from Firebase: %@", error)

            }
        
    }
    
    @IBAction func DisplayAllATMS(_ sender: Any) {
        let DispAll = storyboard?.instantiateViewController(withIdentifier: "Mapview") as! MapViewController
        DispAll.keyatm = "ATM"
        DispAll.strkeColor = #colorLiteral(red: 0, green: 0.4153311253, blue: 0, alpha: 1)
        present(DispAll, animated: true, completion: nil)
        
    }
    
 
    
    @IBAction func AbsaButton(_ sender: Any) {
        let SAbsa = storyboard?.instantiateViewController(withIdentifier: "Mapview") as! MapViewController
        SAbsa.keyatm = "Absa"
        SAbsa.pin = "Absa_pin"
        SAbsa.strkeColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        SAbsa.AtmKind = "ABSATMS"
        present(SAbsa, animated: true, completion: nil)
    }
    
    
    @IBAction func NedbankButton(_ sender: Any) {
        let SNed = storyboard?.instantiateViewController(withIdentifier: "Mapview") as! MapViewController
        let NedBankClr = hexStringToUIColor(hex: "#218702")
        SNed.keyatm = "Nedbank"
        SNed.pin = "Ned_pin"
        SNed.strkeColor = NedBankClr
        SNed.AtmKind = "NEDATMS"
        present(SNed, animated: true, completion: nil)
    }
    
    
    @IBAction func FNBButton(_ sender: Any) {
        let FNed = storyboard?.instantiateViewController(withIdentifier: "Mapview") as! MapViewController
        FNed.keyatm = "FNB ATM"
        FNed.pin = "Fnb_pin"
        FNed.strkeColor = #colorLiteral(red: 0, green: 0.7448331714, blue: 0.4741281867, alpha: 1)
        FNed.AtmKind = "FNBATMS"
        present(FNed, animated: true, completion: nil)
    }
    
    @IBAction func CapitecButton(_ sender: Any) {
        let CPed = storyboard?.instantiateViewController(withIdentifier: "Mapview") as! MapViewController
        CPed.keyatm = "Capitec Bank"
        CPed.pin = "Cap_pin"
        CPed.strkeColor = .gray
        CPed.AtmKind = "CAPSATMS"
        present(CPed, animated: true, completion: nil)
    }
    
    
    @IBAction func StandbardButton(_ sender: Any) {
        let Stned = storyboard?.instantiateViewController(withIdentifier: "Mapview") as! MapViewController
        Stned.keyatm = "StandardBank"
        Stned.pin = "Standard_pin"
        Stned.strkeColor = #colorLiteral(red: 0.02959540859, green: 0.04092096537, blue: 0.7686998248, alpha: 1)
        Stned.AtmKind = "STDATMS"
        present(Stned, animated: true, completion: nil)
    }
    
    func switchStoryboard() {
        let Newview = storyboard?.instantiateViewController(withIdentifier: "SignIn") as! SignInViewController
            self.present(Newview, animated: true, completion: nil)
        }
    
    
    
  /*  @IBAction func ShowName(_ sender: Any) {
       
        let alert = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your name here..."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                self.UserInfo.set(name, forKey: "Name")
                let UserName = self.UserInfo.object(forKey: "Name")
                self.ShowUserName.text = self.greeting + (UserName as? String ?? "Me")
                print("Your name: \(name)")
            }
        }))
        
        self.present(alert, animated: true)
        
    } */
    func showprofile() {
        let Newview = storyboard?.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
            self.present(Newview, animated: true, completion: nil)
    }
    
    func LoggedIn() {
        
        if let user = Auth.auth().currentUser {

            if AccessToken.current != nil {
                  // logged in using facebook
                
              }
            else if  GIDSignIn.sharedInstance()!.currentUser != nil {
                let user = GIDSignIn.sharedInstance()!.currentUser
                if ((user?.profile.hasImage) != nil) {
                    let userDP = user?.profile.imageURL(withDimension: 200)
                    Avatar.sd_setImage(with: userDP)

                  
                } else {
                    let currentUser = Auth.auth().currentUser!.uid
                    let storage = Storage.storage()
                    let storageRef = storage.reference()
                    let ref = storageRef.child("profile/\(currentUser)")
                    Avatar.sd_setImage(with: ref)
                }
                
                
           }
        
       
    /*    Database.database().reference().child("users").child(currentUser).observeSingleEvent(of: .value, with: { (snapshot) in
          // Get user value
          let value = snapshot.value as? NSDictionary
          let username = value?["name"] as? String ?? ""
          
          })*/
        
        
            }
    }
    
    func setUpAvatar() {
        Avatar.layoutIfNeeded()
        Avatar.layer.cornerRadius = Avatar.frame.height/2
        Avatar.layer.borderWidth = 2
        Avatar.layer.borderColor = #colorLiteral(red: 0.1294117647, green: 0.5294117647, blue: 0.007843137255, alpha: 1)
        Avatar.clipsToBounds = true
        Avatar.contentMode = .scaleToFill
    
    }
    
    func OnCheck() {
        
        Avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self,action: #selector(checkLogin))
        Avatar.addGestureRecognizer(tapGesture)
    }
    
    @objc func checkLogin() {
        Auth.auth().addStateDidChangeListener() { auth, user in
                if user != nil {
                    self.LoggedIn()
                    self.setUpAvatar()
                    print("Hi")
                } else {
                    self.switchStoryboard()
                }
            
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBackground()
        OnCheck()
        LoggedIn()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.GoogleSign(notification:)), name: Notification.Name("GoogleSignedIn"), object: nil)
        
       // let User = self.UserInfo.object(forKey: "Name")
       // self.ShowUserName.text = greeting + (User as? String ?? "There")
        
        // If the network is unreachable show the offline page
        NetworkManager.isUnreachable { _ in
            self.showOfflinePage()
        }
        
    }
    
    @objc func GoogleSign(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let userDP = userInfo["userDP"] as? String
                else {
            print("No UserInfo found")
            return
        }
        
    }
    
    
  
    
    /// Reachability Offline
    private func showOfflinePage() -> Void {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "NetworkUnavailable", sender: self)
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
    
    
   
   /* func ShowAlert() {
        let alert = UIAlertController(title: "What's your name?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input your name here..."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                self.UserInfo.set(name, forKey: "Name")
                let UserName = self.UserInfo.object(forKey: "Name")
                self.ShowUserName.text = self.greeting + (UserName as? String ?? "Me")
                print("Your name: \(name)")
            }
        }))
        
        self.present(alert, animated: true)
    } */
    
    /// Hex -> UIColor conversion
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red:CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x000FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        
    }
    
   
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
}
    
    func dropShadow() {
           self.layer.masksToBounds = false
           self.layer.shadowColor = UIColor.black.cgColor
           self.layer.shadowOpacity = 0.2
           self.layer.shadowOffset = CGSize(width: -2, height: 1.5)
           self.layer.shadowRadius = 13
           self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
           self.layer.shouldRasterize = true
           self.layer.rasterizationScale = UIScreen.main.scale

       }
}
