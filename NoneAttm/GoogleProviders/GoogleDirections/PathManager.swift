//
//  DrawsPath.swift
//  GooGooMaps
//
//  Created by Usman Nazir on 03/08/2019.
//  Copyright © 2019 Usman Nazir. All rights reserved.
//

import Foundation
import GoogleMaps
import SwiftyJSON

let DIRECTION_API_KEY = googleApiKey

class PathManager : NetworkEngine{
    
    static let shared = PathManager()
    
    //Polylines displayed are stored here
    var polyLine: GMSPolyline?
    
    private init() { }
}

extension PathManager {
    
    
    
    
    
    func drawPath(mapView: GMSMapView, from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, strokeClr: UIColor) {
        
        //Get points data from the network engine
        getDirectionsPathData(mapView: mapView, from: from, to: to) { (points) in
            
            //MUST BE DONE ON MAIN THREAD
            DispatchQueue.main.async {
                
                //Convert Points to string format
                guard let pointsString = points as? String else { return }
                
                //Create a path object
                let path = GMSPath(fromEncodedPath: pointsString)
                
                //If there is a path displayed on screen, remove it
                if let polyLine = self.polyLine {
                    polyLine.map = nil
                }
                
                //Draw new polyline
                self.polyLine = GMSPolyline(path: path)
                
                //Set width of polyline
                self.polyLine?.strokeWidth = 5
                
                //Set color of the polyline
                self.polyLine?.strokeColor = strokeClr
                
                //Set map of the polyline
                self.polyLine?.map = mapView
                
                //Set new camera bounds
                let bounds = GMSCoordinateBounds(path: path!)
                
                //Animate camera to show entire path on screen
                mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 40.0))
            }
            
            
        }
        
    }
    
    /* func updateTraveledPath(currentLocation: CLLocationCoordinate2D) {
        var index = 0
        
        for i in 0..< self.path.count(){
            let pathLat = Double(self.Path.coordinate(at: i).latitude).rounded(toPlaces: 3)
            let pathLong = Double(self.Path.coordinate(at: i).longitude).rounded(toPlaces: 3)
            
            let currentLat = Double(currentLocation.longitude).rounded(toPlaces: 3)
            let currentLong = Double(currentLocation.longitude).rounded(toPlaces: 3)
            
            if currentLat == pathLat && currentLong == pathLong {
                index = Int(i)
                break
            }
        }
        
        
        let newPath = GMSMutablePath()
        for i in index..<Int(.path.count()){
            newPath.add(self.path.coordinate(at: UInt(i)))
        }
        self.path = newPath
        self.polyLine.map = nil
        self.polyLine = GMSPolyline(path: self.path)
        self.polyLine.strokeColor = UIColor.darkGray
        self.polyLine.strokeWidth = 2.0
        self.polyLine.map = self.mapView
    }
    
}
  */
    

}


