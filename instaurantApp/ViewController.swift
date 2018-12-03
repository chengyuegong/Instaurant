//
//  ViewController.swift
//  instaurantApp
//
//  Created by Chengyue Gong on 2018/11/27.
//  Copyright © 2018 CSE@WashU. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation

class ViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {

    var detail: YelpBusinessDetail?
    let dataManager = DataManager()
    let locationManager = CLLocationManager()
    let node = SCNNode()
    let configuration = ARWorldTrackingConfiguration() // Create a session configuration
    
    @IBOutlet weak var detailBtn: UIButton!
    @IBOutlet var sceneView: ARSCNView!
    
    var currentLoc: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // Get the location permission and set delegate
        // isAuthorizedtoGetUserLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        locationManager.startUpdatingLocation()
//        print("Start updating location")
        
        detailBtn.setTitleColor(UIColor.gray, for: .disabled)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        // sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
//        dataManager.queryYelpBussinessDetail(withYelpID: "0JnsAQFvOFxPltNU_smK3w") { (retDetail, err) in
//            DispatchQueue.main.async {
//                self.detail = retDetail
//                self.detailBtn.isEnabled = true
//            }
//        }
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        currentLoc = locations.last
        let latitude = currentLoc?.coordinate.latitude
        let longitude = currentLoc?.coordinate.longitude
        print("latitude = \(latitude!), longitude = \(longitude!)")
        dataManager.queryRestaurantsAtLocation(latitude: latitude!, longitude: longitude!) { (restaurants) in
//                self.configuration.detectionImages.removeAll()
            DispatchQueue.global(qos: .background).async {
                for restaurant in restaurants {
                    restaurant.arImage?.name = restaurant.yelpId
                    self.configuration.detectionImages.insert(restaurant.arImage!)
                }
                print("Downloaded \(self.configuration.detectionImages.count) images")
                // Run the view's session
                self.sceneView.session.run(self.configuration, options: [.removeExistingAnchors])
            }
        }
    }
    
    //if we have no permission to access user location, then ask user for permission.
//    func isAuthorizedtoGetUserLocation() {
//        switch CLLocationManager.authorizationStatus() {
//        case .notDetermined, .restricted, .denied:
//            // Request when-in-use authorization initially
//            locationManager.requestWhenInUseAuthorization()
//            break
//        case .authorizedWhenInUse, .authorizedAlways:
//            // Enable location features
//            break
//        }
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for childNode in node.childNodes {
            childNode.removeFromParentNode()
        }
        
        detailBtn.isEnabled = false
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func createNode(headingString: String, position: SCNVector3) -> SCNNode {
        let headingText = SCNText(string: headingString, extrusionDepth: 1)
        headingText.flatness = 0.1
        headingText.font = UIFont.systemFont(ofSize: 100, weight: .bold)
        let headingTextNode = SCNNode(geometry: headingText)
        headingTextNode.eulerAngles.x = -.pi / 2
        headingTextNode.scale = SCNVector3(0.0005, 0.0005, 0.0005)
        headingTextNode.position = SCNVector3(position.x, position.y, position.z)
        return headingTextNode
    }
    
    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        // Code sources from “Lecture14-StudentCard.zip” (from https://research.engineering.wustl.edu/~todd/cse438/)
        if let imageAnchor = anchor as? ARImageAnchor {
            let imageSize = imageAnchor.referenceImage.physicalSize
            
            // info for displaying, need to be used to match info in FireBase
            let yelpId = imageAnchor.referenceImage.name
            dataManager.queryYelpBussinessDetail(withYelpID: yelpId!) { (retDetail, err) in
                DispatchQueue.main.async {
                    self.detail = retDetail
                    self.detailBtn.isEnabled = true
                    let namePosition = SCNVector3(-imageSize.width / 2, 0, -imageSize.height * 0.9)
                    self.node.addChildNode(self.createNode(headingString: retDetail.name, position: namePosition))
                    let pricePosition = SCNVector3(-imageSize.width / 2, 0, -imageSize.height * 0.75)
                    if (retDetail.price != nil) {
                        self.node.addChildNode(self.createNode(headingString: "Price: \(retDetail.price!)", position: pricePosition))
                    } else {
                        self.node.addChildNode(self.createNode(headingString: "Unknown $", position: pricePosition))
                    }
                    let ratePosition = SCNVector3(-imageSize.width / 2, 0, -imageSize.height * 0.6)
                    self.node.addChildNode(self.createNode(headingString: "Rating: \(retDetail.rating!)", position: ratePosition))
                }
            }
        }
        return node
    }
    
    @IBAction func toDetail(_ sender: UIButton) {
        if detail != nil {
            performSegue(withIdentifier: "ar2detail", sender: detail)
        } else {
            print("Haven't found a restaurant!")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ar2detail") {
            let dest = segue.destination as! DetailViewController
            dest.restaurant = (sender as! YelpBusinessDetail)
        }
    }
    
}
