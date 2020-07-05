//
//  ATMmodel.swift
//  NoneAttm
//
//  Created by Daniel Senga on 2020/06/05.
//  Copyright © 2020 Daniel Senga. All rights reserved.
//

import Foundation
import Firebase

struct Atm {
    
    let atmName : String
    let address : String
    let lat : Double
    let long: Double
    let votesUpCount : Int
    let votesDownCount : Int
    let totalVotes : Int
    
    init(snapshot: DataSnapshot) {
        
        let value = snapshot.value as? NSDictionary
        
        atmName = value?["atmName"] as? String ?? ""
        address = value?["address"] as? String ?? ""
        lat = value?["lat"] as! Double
        long = value?["long"] as! Double
        votesUpCount = value?["votesUpCount"] as! Int
        votesDownCount = value?["votesDownCount"] as! Int
        totalVotes = value?["totalVotes"] as! Int
    }
}
