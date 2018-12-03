//
//  RegistrationViewController.swift
//  instaurantApp
//
//  Created by 衡俊吉 on 11/22/18.
//  Author: Junji Heng
//  Copyright © 2018 CSE@WashU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class RegistrationViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,PassNameProtocol,PassWidthProtocol,PassImageProtocol,PassLocationProtocol,CLLocationManagerDelegate{
    @IBOutlet var submitButton: UIButton!
    
    func setLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, id: String, address: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.id = id
        self.address = address
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
    var address: String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var registerName: String?
    var width: String?
    var image: UIImage?
    @IBOutlet var myTableView: UITableView!
    var myArray = ["Name", "Photo", "Address","Physical Width"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 1, alpha: 1)
        navigationItem.title = "Restaurant Registration"
        
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        submitButton.layer.cornerRadius = 10
        submitButton.layer.borderWidth = 2
        submitButton.layer.borderColor = UIColor.blue.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myTableView.reloadData()
    }
    
    @IBAction func submit(_ sender: UIButton) {
        if(latitude == nil || longitude == nil || registerName == nil || image == nil || width == nil || id == nil){
            let alertController = UIAlertController(title: "Error!", message: "Please finish the registration", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in}
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
        } else {
            dataManager.createRestaurant(latitude: latitude!, longitude: longitude!, withName: registerName!, withPhoto: image!, physicalWidthByMeter: Double(width!)!, yelpID: id!) { (restaurant, error) in
            print("Create a restaurant in the firebase: \(restaurant)")
            let alertController = UIAlertController(title: "Great!", message: "You've added a restaurant to the database!", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "theCell")! as UITableViewCell
        cell.textLabel!.text = myArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        if(indexPath.row == 2 && id != nil){
            cell = UITableViewCell(style: .value1, reuseIdentifier: "theCell")
            cell.textLabel?.text = myArray[indexPath.row]
            cell.detailTextLabel?.text = address!
        }else if(indexPath.row == 1 && image != nil){
            cell = UITableViewCell(style: .default, reuseIdentifier: "theCell")
            cell.textLabel?.text = myArray[indexPath.row]
            let imageView = UIImageView()
            imageView.frame = CGRect(x: view.frame.width-80, y: 0, width: 80, height:80)
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            cell.addSubview(imageView)
        }else if(indexPath.row == 0 && registerName != nil && registerName != ""){
            cell = UITableViewCell(style: .value1, reuseIdentifier: "theCell")
            cell.textLabel?.text = myArray[indexPath.row]
            cell.detailTextLabel?.text = registerName!
        } else if(indexPath.row == 3 && width != nil && width != ""){
            cell = UITableViewCell(style: .value1, reuseIdentifier: "theCell")
            cell.textLabel?.text = myArray[indexPath.row]
            cell.detailTextLabel?.text = width!+"m"
        }
        return cell
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
    }
}
