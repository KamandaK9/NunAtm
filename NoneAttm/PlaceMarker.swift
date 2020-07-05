//
//  PlaceMarker.swift
//  NoneAttm
//
//  Created by Daniel Senga on 2020/01/25.
//  Copyright © 2020 Daniel Senga. All rights reserved.
//

import UIKit
import GoogleMaps

class PlaceMarker: GMSMarker {
    
    var pinBnk: String = "atm_pin"
    let Mapview = MapViewController()
    // 1
    let place: GooglePlace
    
    
    // 2
    init(place: GooglePlace) {
        self.place = place
        super.init()
        
        
        
        
        position = place.coordinate
        icon = UIImage(named: pinBnk)
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
    }
    
    
    
    
}

