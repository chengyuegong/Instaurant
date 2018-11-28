//
//  RegistrationViewController.swift
//  Instaurant
//
//  Created by 衡俊吉 on 11/22/18.
//  Copyright © 2018 CSE@WashU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class RegistrationViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate,UITextFieldDelegate {

//    @IBOutlet var button: UIButton!
    @IBOutlet var name: UITextField!
    @IBOutlet var uploadImage: UIImageView!
    @IBOutlet var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let image = UIImagePickerController()
    var theImage: [UIImage] = []
    let dataManager = DataManager()
    
    @IBAction func addPhotoFromAlbums(_ sender: Any) {
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image,animated: true)
    }
    
    @IBAction func addPhotoFromCamera(_ sender: Any) {
        image.delegate = self
        image.sourceType = .camera
        image.allowsEditing = false
        self.present(image,animated: true)
    }
    
//    @IBAction func getLocation(_ sender: Any) {
//        locationManager.startUpdatingLocation()
//    }
    
    @IBAction func uploadData(_ sender: Any) {

        let text:String!
        if(self.name.text==""||self.name.text==nil){
            text = "Create with no name?"
        }else{
            text = "Make sure to create " + self.name.text! + "?"
            
        }
        let alertController = UIAlertController(
            title: "Great!",
            message: text,
            preferredStyle: UIAlertController.Style.alert
        )
        
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: UIAlertAction.Style.destructive) { (action) in
        }
        
        let confirmAction = UIAlertAction(
        title: "OK", style: UIAlertAction.Style.default) { (action) in
            let _ = self.dataManager.createRestaurant(AtLatitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!, withName: self.name.text!, withPhotos: self.theImage)
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func cancelUploading(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            theImage.append(image)
            uploadImage.image = theImage.last
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let curlocation = locations.last
        let viewRegion = MKCoordinateRegion.init(center: (curlocation?.coordinate)!,latitudinalMeters: 50,longitudinalMeters: 50)
        self.mapView.setRegion(viewRegion,animated: true)
        self.mapView.showsUserLocation = true
        
        manager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Restaurant"
        self.name.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
        }
        let endEditingTapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:)))
        endEditingTapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(endEditingTapGesture)
        locationManager.startUpdatingLocation()
        
//        button.backgroundColor = UIColor.white
//        button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
//        button.setTitle("Get your Location", for: UIControl.State.normal)
//        button.layer.masksToBounds = true
//        button.layer.cornerRadius = 10
//        button.layer.borderWidth = 2
//        button.layer.borderColor = UIColor.blue.cgColor
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
