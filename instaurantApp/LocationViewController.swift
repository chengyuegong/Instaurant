//
//  LocationViewController.swift
//  instaurantApp
//
//  Created by 衡俊吉 on 12/2/18.
//  Author: Junji Heng
//  Copyright © 2018 CSE@WashU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol PassLocationProtocol {
    func setLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, id: String, address: String)
}

class LocationViewController: UIViewController,CLLocationManagerDelegate,PassNearProtocol {
    var address: String?
    var id: String?
    var name: String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var restLatitude: Double?
    var restLongitude: Double?
    var button: UIButton!
    var button2: UIButton!
    let locationManager = CLLocationManager()
    var mapView: MKMapView!
    var locationProtocol: PassLocationProtocol?
    var annotation = MKPointAnnotation()
    
    func setIdAddr(id: String, address: String, latitude: Double, longitude: Double) {
        self.id = id
        self.address = address
        self.restLatitude = latitude
        self.restLongitude = longitude
    }
    
    @objc func handleNearby(sender: UIButton){
        let detailedVC = NearByViewController()
        detailedVC.nearProtocol = self
        detailedVC.latitude = self.locationManager.location?.coordinate.latitude
        detailedVC.longitude = self.locationManager.location?.coordinate.longitude
        detailedVC.name = self.name
        navigationController?.pushViewController(detailedVC, animated: true)
    }
    
    @objc func handleLocation(sender: UIButton){
        if (id != nil) {
            print("Set the restaurant at \(address!)")
            locationProtocol?.setLocation(latitude: latitude!, longitude: longitude!, id: id!, address: address!)
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
        let theMapFrame = CGRect(x: 0, y: 0, width: view.frame.width, height:view.frame.height)
        mapView = MKMapView.init(frame: theMapFrame)
        view.addSubview(mapView)
        
        let buttonFrame = CGRect(x: view.frame.width/2-135, y: view.frame.height-120, width: 160, height: 30)
        button = UIButton.init(type: .system)
        button.frame = buttonFrame
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        button.setTitle("Nearby Restaurants", for: UIControl.State.normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blue.cgColor
        button.addTarget(self, action:#selector(handleNearby(sender:)), for: .touchUpInside)
        view.addSubview(button)
        
        if (name == nil || name == "") {
            button.isEnabled = false
            button.alpha = 0.4
            let textFrame = CGRect(x: view.frame.width/2-120, y: view.frame.height-160, width: 300, height: 30)
            let hint = UILabel(frame: textFrame)
            hint.text = "You need to input a name at first"
            view.addSubview(hint)
        }
        
        let buttonFrame2 = CGRect(x: view.frame.width/2+70, y: view.frame.height-120, width: 70, height: 30)
        button2 = UIButton.init(type: .system)
        button2.frame = buttonFrame2
        button2.backgroundColor = UIColor.white
        button2.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        button2.setTitle("OK", for: UIControl.State.normal)
        button2.layer.cornerRadius = 10
        button2.layer.borderWidth = 2
        button2.layer.borderColor = UIColor.blue.cgColor
        button2.addTarget(self, action:#selector(handleLocation(sender:)), for: .touchUpInside)
        view.addSubview(button2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.startUpdatingLocation()
        if (mapView.annotations.count > 0) {
            mapView.removeAnnotation(annotation)
        }
        if (restLatitude != nil && restLongitude != nil) {
            annotation.coordinate = CLLocationCoordinate2D(latitude: restLatitude!, longitude: restLongitude!)
            mapView.addAnnotation(annotation)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let curlocation = locations.last
        latitude = curlocation?.coordinate.latitude
        longitude = curlocation?.coordinate.longitude
        let viewRegion = MKCoordinateRegion.init(center: (curlocation?.coordinate)!,latitudinalMeters: 50,longitudinalMeters: 50)
        self.mapView.setRegion(viewRegion,animated: true)
        self.mapView.showsUserLocation = true
        manager.stopUpdatingLocation()
    }
}
