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
class RegistrationViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,PassNameProtocol,PassWidthProtocol,PassImageProtocol,PassLocationProtocol,CLLocationManagerDelegate{
    func setLocation(AtLatitude: CLLocationDegrees, longitude: CLLocationDegrees,id: String) {
        self.atlatitude = AtLatitude
        self.longitude = longitude
        self.id = id
    }
    
    func setImage(image: UIImage) {
        self.image = image
    }
    
    func setWidth(width: String) {
        self.width = width
    }
    
    func setName(name: String) {
        self.registerName = name
    }
    
    let dataManager = DataManager()
    var id: String?
    var atlatitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var registerName: String?
    var width: String?
    var image: UIImage?
    @IBOutlet var myTableView: UITableView!
    var myArray = ["Name", "Picture", "Location","Width"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        // Do any additional setup after loading the view, typically from a nib.
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
        myTableView.dataSource = self
        myTableView.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("appear")
        print(registerName as Any)
        print(width as Any)
        if(image != nil){
            print("cool")
        }else{
            print("fuck")
        }
        print(atlatitude as Any)
        
        // myTableView.
    }
    
    
    //    }
    //    func viewLoadSetup(){
    //
    //    }
    //
    
    @IBAction func submit(_ sender: UIButton) {
        dataManager.createRestaurant(latitude: atlatitude!, longitude: longitude!, withName: registerName!, withPhoto: image!, physicalWidthByMeter: Double(width!)!, yelpID: id!) { (restaurant, error) in
            print("Create a restaurant in the firebase: \(restaurant)")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "theCell")! as UITableViewCell
        myCell.textLabel!.text = myArray[indexPath.row]
        myCell.accessoryType = .disclosureIndicator
        //        myCell.detailTextLabel?.text = "registerName"
        //        myCell.detailTextLabel?.textColor = UIColor.black
        //        myCell.detailTextLabel?.textAlignment = .right
        
        return myCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 1){
            return 80
        }else{
            return 44
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Time to push on the detailed view
        if(indexPath.row==0){
            let detailedVC = NameViewController()
            detailedVC.nameProtocol = self
            navigationController?.pushViewController(detailedVC, animated: true)
        }
        if(indexPath.row==1){
            let detailedVC = ImageViewController()
            detailedVC.imageProtocol = self
            navigationController?.pushViewController(detailedVC, animated: true)
        }
        if(indexPath.row==2){
            let detailedVC = LocationViewController()
            detailedVC.locationProtocol = self
            detailedVC.name = registerName
            navigationController?.pushViewController(detailedVC, animated: true)
        }
        if(indexPath.row==3){
            let detailedVC = WidthViewController()
            detailedVC.widthProtocol = self
            navigationController?.pushViewController(detailedVC, animated: true)
        }
        
        //        let detailedVC = DetailedViewController()
        //        detailedVC.image = theImageCache[indexPath.row]
        //        detailedVC.imageName = theData[indexPath.row].name
        //navigationController?.pushViewController(detailedVC, animated: true)
        
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
