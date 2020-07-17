//
//  SelectATMViewController.swift
//  NoneAttm
//
//  Created by Daniel Senga on 2020/01/25.
//  Copyright © 2020 Daniel Senga. All rights reserved.
//

import UIKit



class SelectATMViewController: UIViewController {

    
 @IBOutlet weak var BankCardView: UIView!
 let backgroundImageView = UIImageView()
 let UserInfo = UserDefaults.standard
 let greeting = "Hi, "
    

    
 let appDelegate = UIApplication.shared.delegate as! AppDelegate
 let network: NetworkManager = NetworkManager.sharedInstance
 
    @IBOutlet weak var ShowUserName: UILabel!
    
    @IBAction func RemoveFirstLaunch(_ sender: Any) {
        
        UserInfo.removeObject(forKey:" isAppAlreadyLaunchedOnce")
        UserInfo.removeObject(forKey: "Name")
        let name = self.UserInfo.object(forKey: "Name")
        let remove = self.UserInfo.object(forKey: "hasAlreadyLaunched")
        print("Object removed" + (remove as? String ?? "Me") + (name as? String ?? "Me") )
        
    }
    
    /// Code below: All buttons for ATM selection, keyword and color of path is sent over to mapview
    
    @IBAction func DisplayAllATMS(_ sender: Any) {
        let DispAll = storyboard?.instantiateViewController(withIdentifier: "Mapview") as! MapViewController
        DispAll.keyatm = "ATM"
        present(DispAll, animated: true, completion: nil)
        
    }
    
    
    @IBAction func AbsaButton(_ sender: Any) {
        let SAbsa = storyboard?.instantiateViewController(withIdentifier: "Mapview") as! MapViewController
        SAbsa.keyatm = "Absa"
        SAbsa.pin = "Absa_pin"
        SAbsa.strkeColor = .red
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
        FNed.strkeColor = .green
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
        Stned.strkeColor = .blue
        Stned.AtmKind = "STDATMS"
        present(Stned, animated: true, completion: nil)
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
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setBackground()
        let User = self.UserInfo.object(forKey: "Name")
        self.ShowUserName.text = greeting + (User as? String ?? "There")
        
        // If the network is unreachable show the offline page
        NetworkManager.isUnreachable { _ in
            self.showOfflinePage()
        }
        
        
        BankCardV()
        
     
    }
  
    
    /// Reachability Offline
    private func showOfflinePage() -> Void {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "NetworkUnavailable", sender: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(!appDelegate.hasAlreadyLaunched) {
            
            //set has AlreadyLaunched to false
            appDelegate.sethasAlreadyLaunched()
            
            
        }
        
       
    }
    
    // BankView settings
    func BankCardV() {
        BankCardView.roundCorners([.topLeft, .topRight], radius: 40)
        
        
    }
    
    
    func setBackground() {
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        if #available(iOS 13.0, *) {
            backgroundImageView.overrideUserInterfaceStyle = .dark
        } else {
            // Fallback on earlier versions
        }
        
        backgroundImageView.image = UIImage(named: "IphoneXnXS")
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
}
