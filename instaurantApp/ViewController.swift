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

    @IBOutlet var sceneView: ARSCNView!
    let locationManager = CLLocationManager() // location manager
    let node = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Aim at a Storefront"
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        // sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Get the location permission and set delegate
//        isAuthorizedtoGetUserLocation()
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        }
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
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "images", bundle: Bundle.main)!

        // Run the view's session
        sceneView.session.run(configuration)
        
        for childNode in node.childNodes {
            childNode.removeFromParentNode()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

//    func getInfo() -> Restaurant {
//        // find the restaurant
//    }
    
    func createNode(headingString: String, position: SCNVector3) -> SCNNode {
        let headingText = SCNText(string: headingString, extrusionDepth: 1)
        headingText.flatness = 0.1
        headingText.font = UIFont.systemFont(ofSize: 14, weight: .bold)
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
//            let restaurant = getInfo(id: yelpId)
//            var name: String = restaurant.name
//            var price: String = restaurant.price!
//            var rate: Double = restaurant.averageRating!
            let name = "Upass"
            let price = "$10.00"
            let rate = "5.0"
            
            // let nameString = imageAnchor.referenceImage.name == "id" ? "Store Name: " + storeName : "Gift Card Value"
            // let priceString = imageAnchor.referenceImage.name == "id" ? "Price: " + price : "$18.39"
            // let rateString = imageAnchor.referenceImage.name == "id" ? "Rating: " + rating : "test"
            
            let namePosition = SCNVector3(-imageSize.width / 2, 0, -imageSize.height * 0.9)
            node.addChildNode(createNode(headingString: name, position: namePosition))
            let pricePosition = SCNVector3(-imageSize.width / 2, 0, -imageSize.height * 0.75)
            node.addChildNode(createNode(headingString: price, position: pricePosition))
            let ratePosition = SCNVector3(-imageSize.width / 2, 0, -imageSize.height * 0.6)
            node.addChildNode(createNode(headingString: "\(rate)", position: ratePosition))
        }
        return node
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
