//
//  ViewController.swift
//  instaurantApp
//
//  Created by Metaphor on 11/27/18.
//  Copyright © 2018 CSE@WashU. All rights reserved.
//

import UIKit
import CoreLocation

class ExampleViewController: UIViewController {
    let manager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to use DataManager, first initial an instance. you can set it as an instance variable
        let manager = DataManager()
        
        // Because all calls are asynchronous, you have to transfer a callback function parameter that you want to perform when the call completes.
        // for example, if you want to find possible restaurants near some place
//        manager.findPossibleRestaurants(AtLatitude: 38.6270, longitude: -90.199501, withName: "Starbucks", withRadiusByMeter: 500, completion: <#T##([YelpBusiness]) -> Void#>)
        
        // you have to transfer a function in the placeholder. And its type must be [YelpBusiness] -> Void.
        // for example, if you have the following function
        func wannaDoSomethingAfterIGetTheseRestaurants(results: [YelpBusiness])->Void {
            // yes, I want to do something! like
            for business in results {
                // whatever I like
                print("I want to write this \(business) into our database")
            }
        }
        
        // then set it in the first function
        manager.findPossibleRestaurants(AtLatitude: 38.6270, longitude: -90.199501, withName: "Starbucks", withRadiusByMeter: 500, completion: wannaDoSomethingAfterIGetTheseRestaurants)
        
        // Tip: you have other options to transfer this callback parameter. please see closure and trailing close in Swift documents
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let manager = DataManager()
        
        // now I will show some basic usage of our DataManager class
        
        // 1. find possible restaurants near some place "in yelp", not in our database
        // in this time, our database might not store info about them
        let name = "Starbucks"
        let latitude = 38.6270
        let longitude = -90.199501
        func showRestaurants(results: [YelpBusiness]) -> Void {
            for r in results {
                print("id: \(r.id), name: \(r.name), address :\(r.location.display_address)")
            }
        }
        manager.findPossibleRestaurants(AtLatitude: latitude, longitude: longitude, withName: name, withRadiusByMeter: 50, completion: showRestaurants)
        
        
        // 2. create a restaurant in our database
        // it will provide you a Restaurant object, because some functions might have error, so your callback function has to have a parameter of Error? type
        func handleWithCreatedRestaurant(r: Restaurant, error: Error?)->Void {
            // might want to transfer this object to other viewcontroller
        }
//        manager.createRestaurant(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>, withName: <#T##String#>, withPhoto: <#T##UIImage#>, physicalWidthByMeter: <#T##Double#>, yelpID: <#T##String#>, completion: handleWithCreatedRestaurant)
        
        // 3. find some restaurants near some place in our database
        // it will provide you an array of Restaurant
//        manager.queryRestaurantsAtLocation(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>, completion: <#T##([Restaurant]) -> Void#>)
        
        // 4. get the detail of a restaurant
        // 4.1 if you have a Restaurant object, you can just call
//        let r = Restaurant(id: <#T##String#>, name: <#T##String#>, latitude: <#T##Double#>, longitude: <#T##Double#>, photos: <#T##[URL]#>, physicalSize: <#T##Double#>, yelpId: <#T##String#>)
//        r.details(completion: <#T##(YelpBusinessDetail, Error?) -> Void#>)
        
        // 4.2 if you only have its yelpID
//        manager.queryYelpBussinessDetail(withYelpID: <#T##String#>, completion: <#T##(YelpBusinessDetail, Error?) -> Void#>)
        
        
        
        //Tip: pay attention if you want to perform another asynchronous function inside one asnchrounous function
        // for example, you want to have the details of a Restaurant for each restaurants in example 3(find some restaurants near some place in our database).
        // you have to write in such a way:
        func doSomethingWhenIHaveDetails (detail: YelpBusinessDetail, err: Error?) {
        }
        func doSomethingWhenIHaveRestaurants (restaurants: [Restaurant]) {
            for r in restaurants {
                // you have to call it here to ensure the right calling order
                r.details(completion: doSomethingWhenIHaveDetails(detail:err:))
            }
        }
        // then call the most outside function
//        manager.queryRestaurantsAtLocation(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>, completion: doSomethingWhenIHaveRestaurants(restaurants:))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
