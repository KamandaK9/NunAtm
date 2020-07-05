//
//  GoogleDirections
//  NoneAtm
//
//  Created by Usman Nazir on 03/08/2019.
//  Copyright © 2019 Usman Nazir. All rights reserved.
//

import Foundation
import GoogleMaps
import SwiftyJSON


protocol NetworkEngine { }

extension NetworkEngine {

    
    //Gets path using the directions api
    func getDirectionsPathData(mapView: GMSMapView, from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, onSuccess: @escaping (Any?) -> ()) {
        
        let fromStr = "\(from.latitude),\( from.longitude)"
        let toStr = "\(to.latitude),\( to.longitude)"
        
        //Makes final URL
        let url = URL(string : "https://maps.googleapis.com/maps/api/directions/json?origin=" + fromStr + "&destination=" + toStr + "&mode=driving" + "&key=" + DIRECTION_API_KEY)
        
        
        guard let DirectionsURL = url else { return }
        
        //Makes Data task
        URLSession.shared.dataTask(with: DirectionsURL) {
            (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                
                
                // String
                let json = try JSON(data: data)
                    
                    let routes = json["routes"].arrayValue
                    
                    
                    // print route using Polyline
                    for route in routes
                    {
                        let routeOverviewPolyline = route["overview_polyline"].dictionary
                        let points = routeOverviewPolyline?["points"]?.stringValue
                        onSuccess(points)
                        
                        
                    }
                
            } catch {
                print(error.localizedDescription)
            }
            
            }.resume()
        
    }
    
    
    
    
}
