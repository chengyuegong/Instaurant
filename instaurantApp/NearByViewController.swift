//
//  NearByViewController.swift
//  instaurantApp
//
//  Created by 衡俊吉 on 12/2/18.
//  Author: Junji Heng & Chengyue Gong
//  Copyright © 2018 CSE@WashU. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol PassNearProtocol {
    func setIdAddr(id: String, address: String, latitude: Double, longitude: Double)
}

class NearByViewController: UIViewController,CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    var nearProtocol: PassNearProtocol?
    var latitude: CLLocationDegrees!
    var longitude: CLLocationDegrees!
    var tableView: UITableView!
    var name: String!
    let dataManager = DataManager()
    var restaurants: [YelpBusiness] = []
    let distance: Int = 100

    override func viewDidLoad() {
        super.viewDidLoad()
        let tableViewFrame = CGRect(x: 0, y: 0, width: view.frame.width, height:view.frame.height)
        tableView = UITableView(frame: tableViewFrame)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "theCell")
        queryNearbyRestaurants()
    }
    
    func queryNearbyRestaurants() {
        print("Querying nearby restaurants: \(String(describing: latitude)), \(String(describing: longitude)), \(name!), \(distance)")
        dataManager.findPossibleRestaurants(AtLatitude: latitude, longitude: longitude, withName: name, withRadiusByMeter: distance) { (restaurants) in
            print("Find \(restaurants.count) restaurants")
            for restaurant in restaurants {
                self.restaurants.append(restaurant)
                print("Find a restaurant: \(restaurant)")
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theCell = UITableViewCell(style: .subtitle, reuseIdentifier: "theCell")
        theCell.textLabel?.text = restaurants[indexPath.row].name
        if (restaurants[indexPath.row].location.display_address.count > 0) {
            let address = restaurants[indexPath.row].location.display_address[0] + ", " + restaurants[indexPath.row].location.display_address.last!
            theCell.detailTextLabel?.text = address
        } else {
            theCell.detailTextLabel?.text = "Unknown address"
        }
        return theCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = restaurants[indexPath.row]
        nearProtocol?.setIdAddr(id: restaurant.id, address: (tableView.cellForRow(at: indexPath)?.detailTextLabel?.text)!, latitude: restaurant.coordinates.latitude, longitude: restaurant.coordinates.longitude)
        navigationController?.popViewController(animated: true)
    }

}
