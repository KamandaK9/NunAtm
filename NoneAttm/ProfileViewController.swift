//
//  ProfileViewController.swift
//  NoneAttm
//
//  Created by Daniel Senga on 2021/01/07.
//  Copyright © 2021 Daniel Senga. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import FirebaseUI

class ProfileViewController: UIViewController {
    @IBOutlet weak var Namelbl: UILabel!
    
    
    @IBOutlet weak var Emaillbl: UILabel!
    @IBOutlet weak var ProfileView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImageUserFromFirebase()

        // Do any additional setup after loading the view.
    }
    
    
        func downloadImageUserFromFirebase() {
            let currentUser = Auth.auth().currentUser!.uid
            let storage = Storage.storage()
            let storageRef = storage.reference()
            let ref = storageRef.child("profile/\(currentUser)")
            
            Database.database().reference().child("users").child(currentUser).observeSingleEvent(of: .value, with: { (snapshot) in
              // Get user value
              let value = snapshot.value as? NSDictionary
              let email = value?["email"] as? String ?? ""
              self.Emaillbl.text = email
              

              
              })
            
            print(ref)
            ProfileView.sd_setImage(with: ref)
            
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


