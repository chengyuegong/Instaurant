//
//  LocationViewController.swift
//  fortesting
//
//  Created by 衡俊吉 on 12/2/18.
//  Copyright © 2018 junji. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
protocol PassLocationProtocol {
    func setLocation(AtLatitude: CLLocationDegrees, longitude: CLLocationDegrees,id: String)
}

class LocationViewController: UIViewController,CLLocationManagerDelegate,PassNearProtocol {
    func setId(id: String) {
        self.id = id
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
        locationProtocol?.setLocation(AtLatitude: atlatitude!, longitude: longitude!, id: id!)
        navigationController?.popViewController(animated: true)
    }
    
    var id: String?
    var name: String?
    var atlatitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var button: UIButton!
    var button2: UIButton!
    let locationManager = CLLocationManager()
    var mapView: MKMapView!
    var locationProtocol: PassLocationProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        let theMapFrame = CGRect(x: 0, y: 0, width: view.frame.width, height:view.frame.height)
        mapView = MKMapView.init(frame: theMapFrame)
        view.addSubview(mapView)
        
        let buttonFrame = CGRect(x: view.frame.width/2-135, y: view.frame.height-100, width: 160, height: 30)
        button = UIButton.init(type: .system)
        button.frame = buttonFrame
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        button.setTitle("Nearby Restaurants", for: UIControl.State.normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blue.cgColor
        button.addTarget(self, action:#selector(handleNearby(sender:)), for: .touchUpInside)
        view.addSubview(button)
        
        let buttonFrame2 = CGRect(x: view.frame.width/2+50, y: view.frame.height-100, width: 70, height: 30)
        button2 = UIButton.init(type: .system)
        button2.frame = buttonFrame2
        button2.backgroundColor = UIColor.white
        button2.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        button2.setTitle("OK", for: UIControl.State.normal)
        button2.layer.masksToBounds = true
        button2.layer.cornerRadius = 10
        button2.layer.borderWidth = 2
        button2.layer.borderColor = UIColor.blue.cgColor
        button2.addTarget(self, action:#selector(handleLocation(sender:)), for: .touchUpInside)
        view.addSubview(button2)
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let curlocation = locations.last
        atlatitude = curlocation?.coordinate.latitude
        longitude = curlocation?.coordinate.longitude
        let viewRegion = MKCoordinateRegion.init(center: (curlocation?.coordinate)!,latitudinalMeters: 50,longitudinalMeters: 50)
        self.mapView.setRegion(viewRegion,animated: true)
        self.mapView.showsUserLocation = true
        //     location.text = "\(locValue.latitude) \(locValue.longitude)"
        
       //manager.stopUpdatingLocation()
    }
    
}
