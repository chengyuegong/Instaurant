//
//  ARViewController.swift
//  instaurantApp
//
//  Created by Chengyue Gong on 2018/11/27.
//  Author: Pengqiu Meng & Chengyue Gong
//  Copyright © 2018 CSE@WashU. All rights reserved.
//

// Note: Code sources from “Lecture14-StudentCard.zip” (from https://research.engineering.wustl.edu/~todd/cse438/)

import UIKit
import SceneKit
import ARKit
import CoreLocation

class ARViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {

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
        
        // Get the location permission
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
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
        manager.delegate = nil
        currentLoc = locations.last
        let latitude = currentLoc?.coordinate.latitude
        let longitude = currentLoc?.coordinate.longitude
        print("latitude = \(latitude!), longitude = \(longitude!)")
        dataManager.queryRestaurantsAtLocation(latitude: latitude!, longitude: longitude!) { (restaurants) in
            DispatchQueue.global(qos: .background).async {
                self.configuration.detectionImages.removeAll()
                for restaurant in restaurants {
                    let arImage: ARReferenceImage! = restaurant.arImage!
                    arImage.name = restaurant.yelpId
                    print(restaurant.yelpId)
                    self.configuration.detectionImages.insert(arImage)
                }
                print("Downloaded \(self.configuration.detectionImages.count) images")
                // Run the view's session
                self.sceneView.session.run(self.configuration, options: [.removeExistingAnchors])
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for childNode in node.childNodes {
            childNode.removeFromParentNode()
        }
        detailBtn.isEnabled = false
        locationManager.startUpdatingLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
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
        if let imageAnchor = anchor as? ARImageAnchor {
            let imageSize = imageAnchor.referenceImage.physicalSize
            
            // info for displaying, need to be used to match info in FireBase
            let yelpId = imageAnchor.referenceImage.name
            print("yelpId = \(yelpId!)")
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
