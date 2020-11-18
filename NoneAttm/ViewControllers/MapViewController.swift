//
//  MapViewController.swift
//  NoneAttm
//
//  Created by Daniel Senga on 2020/01/23.
//  Copyright © 2020 Daniel Senga. All rights reserved.
//

import UIKit
import GoogleMaps
import Panels
import Firebase
import SwiftyJSON




class MapViewController: UIViewController, GMSMapViewDelegate {
    
    var ref: DatabaseReference!
    
    
    
    let Userinfo = UserDefaults.standard
    var keyatm: String = ""
    var pin: String = ""
    var atmtitle: String = ""
    var atmloc : String = ""
    var strkeColor : UIColor = .green
    var AtmKind: String = ""
    private let dataProvider = GoogleDataProvider()
    private var searchedTypes = ["atm","bank"]
    private let locationManager = CLLocationManager()
    lazy var panelManager = Panels(target: self)
    var panelConfiguration = PanelConfiguration(size: .custom(330))
    let panel = UIStoryboard.instantiatePanel(identifier: "PanelMaterial")
    
    private var timer = Timer()
    var i : UInt = 0
    var path = GMSPath()
    var polyline = GMSPolyline()
    var newPolyline = GMSPolyline()
    var newPath = GMSMutablePath()
    
    
    
    
    
     let network = NetworkManager.sharedInstance
    
  
    
    @IBOutlet weak var LocationButton: UIButton!
    
    
    @IBAction func PressLocation( _ sender: UIButton)  {
        
        
        //let image2:UIImage = UIImage(named: "LocationSelected")!
       // LocationButton.setImage(image2, for: UIControl.State.selected)
        LocationButton.isSelected = true
        
        
        self.didTapMyLocationButton(for: mapView)
    }
    
    @IBAction func BackButton(_ sender: Any) {
        BackButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
           UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: .allowUserInteraction, animations: {[weak self] in self?.BackButton.transform = .identity},completion: nil)
                performSegue(withIdentifier: "ShowATM", sender: self)
               
        
    }
    @IBOutlet weak var DriveInfo: UIStackView!
    @IBOutlet weak var WalkInfo: UIStackView!
    @IBOutlet weak var DriveButton: UIButton!
    @IBOutlet weak var WalkButton: UIButton!
    @IBOutlet weak var DriveLabel: UILabel!
    @IBOutlet weak var WalkLabel: UILabel!
    
    
    @IBAction func DriveButton(_ sender: Any) {
        let willExpand = DriveInfo.isHidden
        let DriveButtonNewTitle = willExpand ? UIImage(named: "DriveSelected.png") : UIImage(named: "Drive.png")
        UIView.animate(
            withDuration:0.2, delay: 0, options: .curveEaseIn,
          animations: {
            self.DriveInfo.subviews.forEach { $0.isHidden = !$0.isHidden }
            self.DriveInfo.isHidden = !self.DriveInfo.isHidden
            if willExpand {
                self.DriveButton.setImage(DriveButtonNewTitle, for: .normal)
            }
        }, completion: { _ in
          // When collapsing, wait for animation to finish before changing from normal to selected
          if !willExpand {
            self.DriveButton.setImage(DriveButtonNewTitle, for: .normal)
          }
    })
        
        
        
    }
    
    
    @IBAction func WalkButton(_ sender: Any) {
        let willExpand = WalkInfo.isHidden
        let WalkButtonNewtitle = willExpand ? UIImage(named: "WalkSelected.png") : UIImage(named: "Walk.png")
        UIView.animate(
            withDuration:0.2, delay: 0, options: .curveEaseIn,
          animations: {
            self.WalkInfo.subviews.forEach { $0.isHidden = !$0.isHidden }
            self.WalkInfo.isHidden = !self.WalkInfo.isHidden
            if willExpand {
                self.WalkButton.setImage(WalkButtonNewtitle, for: .normal)
            }
        }, completion: { _ in
          // When collapsing, wait for animation to finish before changing from normal to selected
          if !willExpand {
            self.WalkButton.setImage(WalkButtonNewtitle, for: .normal)
          }
    })
       
       
        
      
       
       
        
   
        
    }
    
    
    
    @IBOutlet weak var mapView: GMSMapView!
  
    @IBOutlet weak var BackButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(fromURL: "https://noneatm-atms-locations-data.firebaseio.com/")
    
        /// Custom mapView style initialization
        self.mapView.mapStyle(withFilename: "NatureGreen", andType:"json")
    
        
        /// Location Permisions and accuracy
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        mapView.delegate = self
        
        //Panel Setup
        ShowAtmPanel()
        
        // If network is offline show offline page
        network.reachability.whenUnreachable = { reachability in
            self.showOfflinePage()
        }
        
        //Padding for mapView
        let padding = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        mapView.padding = padding
        
        //Hide Map Buttons / Drive / walk
        HideOnLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.WalkDurationShow(notification:)), name: Notification.Name("RouteDuration"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.DriveDurationShow(notification:)), name: Notification.Name("DriveDur"), object: nil)
        
        
        
        
        
        
    }
    
    @objc func DriveDurationShow(notification: Notification) {
        
        guard let userInfo = notification.userInfo,
              let DriveDuration = userInfo["DrivingDuration"] as? String
        else {
            print("No Info found")
            return
        }
        
        
        DispatchQueue.main.async {
            self.DriveLabel.text = DriveDuration
            print(DriveDuration)
        }
    }
    
    @objc func WalkDurationShow(notification: Notification) {
        
        guard let userInfo = notification.userInfo,
              let WalkDuration = userInfo["WalkDur"] as? String
            else {
            print("No Userinfo")
            return
        }
        
       
        DispatchQueue.main.async {
            self.WalkLabel.text = WalkDuration
            print(WalkDuration)
        }
       
    }
    
    
    
    
    
    /// ShowOffline page segue
    private func showOfflinePage() -> Void {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "NetworkUnavailable", sender: self)
        }
    }
   
    /// Hides Labels of Walk and Drive for animation purposes
    func HideOnLoad() {
        self.DriveInfo.isHidden = true
        self.WalkInfo.isHidden = true
        self.DriveLabel.isHidden = true
        self.WalkLabel.isHidden = true
    }
    

  
    
   
    /// Initialisation of ATM Panel and configuring of extra options
    func ShowAtmPanel() {
        
        let panel = UIStoryboard.instantiatePanel(identifier: "PanelMaterial")
        
        panelConfiguration.animateEntry = true
        panelConfiguration.respondToDrag = true
        panelConfiguration.closeOutsideTap = true
        panelConfiguration.useSafeArea = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.panelManager.show(panel: panel, config: self.panelConfiguration)
        }
    }
    
    /// Location Button for user, zoom and animation of camera.
    @discardableResult
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        guard let lat = mapView.myLocation?.coordinate.latitude,
        let lng = mapView.myLocation?.coordinate.longitude else { return false}
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 15)
        mapView.animate(to: camera)
        
        return true
        
    }
   
    
    /// Function to fetch nearby places using keyword and types declared and found in GoogleProviders folder
    func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        
        dataProvider.fetchPlacesNearCoordinate(coordinate, types: searchedTypes, keyword: keyatm) { places in
            places.forEach {
                let marker = PlaceMarker(place: $0)
                marker.icon = UIImage(named:self.pin)
                marker.map = self.mapView
            }
        }
    }
    
    
        
        
    
 
    
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


// MARK: - CLLocationManagerDelegate
//1
extension MapViewController: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
        //mapView.settings.myLocationButton = true
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // 7
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        // 8
        locationManager.stopUpdatingLocation()
        
        fetchNearbyPlaces(coordinate: location.coordinate)
    }
}



 extension MapViewController {
 // MARK: - MARKER INFORMATION
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            guard let placeMarker =  marker as? PlaceMarker else {return false}
        
                let atmtitre = placeMarker.place.name
                let coordinate0 = placeMarker.place.coordinate
                let myloc = mapView.myLocation!
        
       // observeSingleEvent(of: .value, with: { (snapshot)
        atmtitle = placeMarker.place.name
        atmloc = placeMarker.place.address
        
        let post = ["AtmName": atmtitle,
                    "AtmAddress": atmloc,
                    "lat": coordinate0.latitude,
                    "long": coordinate0.longitude,
                    "votesUpCount": 0,
                    "votesDownCount": 0,
                    "totalVotes": 0] as [String : Any]
        
           
       
            self.ref.child(self.AtmKind).queryOrdered(byChild: "AtmAddress").queryEqual(toValue: self.atmloc).observeSingleEvent(of: .value, with: { (DataSnapshot) in
            
            if DataSnapshot.exists(){
                
                
                for item in DataSnapshot.children {
                    
                    let itemsID = item as! DataSnapshot
                    let uid = itemsID.key
                    
                    let atm = Atm(snapshot: item as! DataSnapshot)
                    
                    let ThumbsUpCount = atm.votesUpCount.description
                    let ThumbsDownCount = atm.votesDownCount.description
                    let TotalCount = atm.totalVotes.description
                    
                    //Updating Local Variables
     
                         NotificationCenter.default.post(name:NSNotification.Name("ATMVotes"),object: nil,userInfo: ["VotesUp": ThumbsUpCount, "VotesDown":ThumbsDownCount, "TotalVotes": TotalCount, "uid": uid, "ATMKind": self.AtmKind])
       
                    print(ThumbsUpCount)
       
                }
                
            print("Data Exists")
            } else {
                self.ref.child(self.AtmKind).childByAutoId().setValue(post)
                print("Added")
            }
        })
    
         self.ref.child(AtmKind).observeSingleEvent(of: .value, with: {(DataSnapshot)  in
      
              if DataSnapshot.exists(){

            for item in DataSnapshot.children {
                    
                    let atm = Atm(snapshot: item as! DataSnapshot)
                    
                    self.atmtitle = atm.atmName.description
                    self.atmloc = atm.address
                    print(self.atmtitle)
                }
                
                print("ATM already exists")
                
            } else {
                self.ref.child(self.AtmKind).childByAutoId().setValue(post)
                print("Added")
            }
        })

                 print(atmtitle)
        
        NotificationCenter.default.post(name:NSNotification.Name("UserTappedMarker"),object: nil,userInfo: ["AtmHeading": atmtitre])
        
        
        
// MARK: - Zooms in on selected ATM marker
        let camera = GMSCameraPosition.camera(withTarget: coordinate0, zoom: 18)
        mapView.animate(to: camera)
        self.panelManager.expandPanel()
        
        
        
// MARK: - Path Manager and Directions
        PathManager.shared.drawPath(mapView: mapView, from: myloc.coordinate, to: coordinate0, strokeClr: strkeColor)
        WalkingModeDirections(mapView: mapView, from: myloc.coordinate, to: coordinate0)
        DrivingModeDirections(mapView: mapView, from: myloc.coordinate, to: coordinate0)
        
        
        return false
    }
    
   
                    
                    
    
    
  /*   func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        
        
        guard let placeMarker = marker as? PlaceMarker else {return false}
     
        
        let coordinate0 = placeMarker.place.coordinate
        
        
        
        
        
        
        observeSingleEvent(of: .value, with: { (snapshot)
        atmtitle = placeMarker.place.name
        atmloc = placeMarker.place.address
        
        let post = ["AtmName": atmtitle,
                    "AtmAddress": atmloc,
                    "lat": coordinate0.latitude,
                    "long": coordinate0.longitude,
                    "votesUpCount": 0,
                    "votesDownCount": 0,
                    "totalVotes": 0] as [String : Any]
        
           
       
            self.ref.child(self.AtmKind).queryOrdered(byChild: "AtmAddress").queryEqual(toValue: self.atmloc).observeSingleEvent(of: .value, with: { (DataSnapshot) in
            
            if DataSnapshot.exists(){
                
                
                for item in DataSnapshot.children {
                    
                    let itemsID = item as! DataSnapshot
                    let uid = itemsID.key
                    
                    let atm = Atm(snapshot: item as! DataSnapshot)
                    
                    let ThumbsUpCount = atm.votesUpCount.description
                    let ThumbsDownCount = atm.votesDownCount.description
                    let TotalCount = atm.totalVotes.description
                    
                    //Updating Local Variables
                    
                    
                   
                    
                    
                         NotificationCenter.default.post(name:NSNotification.Name("ATMVotes"),object: nil,userInfo: ["VotesUp": ThumbsUpCount, "VotesDown":ThumbsDownCount, "TotalVotes": TotalCount, "uid": uid, "ATMKind": self.AtmKind])
                                          
                    
                   
                    print(ThumbsUpCount)
                    
                }
                
            print("Data Exists")
            } else {
                self.ref.child(self.AtmKind).childByAutoId().setValue(post)
                print("Added")
            }
            })
            
 
        
         //self.ref.child(AtmKind).observeSingleEvent(of: .value, with: {(DataSnapshot)  in
            
        
         /*      if DataSnapshot.exists(){
                
                
               
                
            for item in DataSnapshot.children {
                    
                    let atm = Atm(snapshot: item as! DataSnapshot)
                    
                    self.atmtitle = atm.atmName.description  
                    self.atmloc = atm.address
                    print(self.atmtitle)
                }
                
                print("Username already exists")
                
            } else {
                self.ref.child(self.AtmKind).childByAutoId().setValue(post)
                print("Added")
            }
        })*/
        
        /// Sends placeMarker info to Panel
            NotificationCenter.default.post(name:NSNotification.Name("UserTappedMarker"),object: nil,userInfo: ["AtmHeading": self.atmtitle, "AtmLocation":self.atmloc])
        
        
        /// Zooms in on selected ATM marker
        //let camera = GMSCameraPosition.camera(withTarget: coordinate0, zoom: 20)
        //mapView.animate(to: camera)
        
       // self.panelManager.expandPanel()
        
        // Draw Path
        guard let myloc = mapView.myLocation else { return false }
        
        //drawPath(mapView: mapView, from: myloc.coordinate, to: coordinate)
        
        PathManager.shared.drawPath(mapView: mapView, from: myloc.coordinate, to: coordinate0, strokeClr: strkeColor)
        
        // Calculates the Walking and Driving modes inbetween points.
        WalkingModeDirections(mapView: mapView, from: myloc.coordinate, to: coordinate0)
    
        
        DrivingModeDirections(mapView: mapView, from: myloc.coordinate, to: coordinate0)
        
        
        
        
    
        
        
        
        return false
        


  } */
    
    func WalkingDrawPath(markr: GMSMarker) -> Bool  {
        
        guard let placeMarker =  markr as? PlaceMarker else {return false}
        // Draw Path
         let myloc = mapView.myLocation
        let coordinate0 = placeMarker.place.coordinate
        
        
        PathManager.shared.drawPath(mapView: mapView, from: myloc!.coordinate, to: coordinate0, strokeClr: strkeColor)
        
        
        return false
    }
    
    
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (gesture == true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.panelManager.collapsePanel()
                self.LocationButton.isSelected = false
            }
            
            
        }
    }
    
    
    
    
    func WalkingModeDirections(mapView: GMSMapView, from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        
        let fromStr = "\(from.latitude),\( from.longitude)"
        let toStr = "\(to.latitude),\( to.longitude)"
        
        //Makes final URL
        let url = URL(string : "https://maps.googleapis.com/maps/api/directions/json?origin=" + fromStr + "&destination=" + toStr + "&mode=walking" + "&key=" + DIRECTION_API_KEY)
        
        
        guard let DirectionsURL = url else { return }
        
        //Makes Data task
        URLSession.shared.dataTask(with: DirectionsURL) {
            (data, response, error) in
            
            guard let data = data else { return }
            
            do {
                
                
                // String
                let json = try JSON(data: data)
                
                let routes = json["routes"].arrayValue
                let walkdistance = routes[0]["legs"][0]["distance"]["text"].stringValue
                let walkduration = routes[0]["legs"][0]["duration"]["text"].stringValue
                print("Walking" + " " + walkdistance + " " + walkduration)
                
                
               UserDefaults.standard.set(walkduration, forKey: "wlkDuration")
                NotificationCenter.default.post(name:NSNotification.Name("RouteDuration"),object: nil,userInfo: ["WalkDur": walkduration])
                
                
                
            } catch {
                print(error.localizedDescription)
            }
            
            }.resume()
        
    }
    
    
    
    func DrivingModeDirections(mapView: GMSMapView, from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        
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
                let distancestr = routes[0]["legs"][0]["distance"]["text"].stringValue
                let duration = routes[0]["legs"][0]["duration"]["text"].stringValue
                print("Driving" + " " + distancestr + " " + duration)
                
                //Passes Data through to panel
                NotificationCenter.default.post(name:NSNotification.Name("DriveDur"),object: nil,userInfo: ["DrivingDuration": duration])
                
                
                
                
            } catch {
                print(error.localizedDescription)
            }
            
            }.resume()
        
    
    
}
    
  
   
}

extension GMSMapView {
    func mapStyle(withFilename name: String, andType type: String) {
        do {
            if let styleURL = Bundle.main.url(forResource: name, withExtension: type) {
                self.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                print("Unable to find style.json")
            }
        } catch {
            print("One or more of the map styles failed to load. \(error)")
        }
    }
}

extension Double {
    
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}




