//
//  SignUpViewController.swift
//  NoneAttm
//
//  Created by Daniel Senga on 2020/01/14.
//  Copyright © 2020 Daniel Senga. All rights reserved.
//

import UIKit
import iOSDropDown

class SignUpViewController: UIViewController {

    @IBAction func onNext(_ sender: Any) {
        performSegue(withIdentifier: "SignUp", sender: self)
    }
    
    @IBOutlet weak var Citydrop: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ShowCity()

        // Do any additional setup after loading the view.
    }
    
    func ShowCity() {
        Citydrop.optionArray = ["Johannesburg", "CapeTown", "Durban"]
       
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
