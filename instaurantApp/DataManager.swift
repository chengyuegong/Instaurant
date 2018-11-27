//
//  DataManager.swift
//  Instaurant
//
//  Created by Metaphor on 11/20/18.
//  Copyright © 2018 CSE@WashU. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import ARKit
import Firebase
import Geofirestore
//import FirebaseStorage


/*
 This is used for external access to the database.
 usage: let manager = DataManager()
 
 Create a restaurant:
 manager.createRestaurant(AtLatitude: CLLocationDegrees, longitude: CLLocationDegrees, withName: String, withPhotos: [UIImage])) -> Restaurant?

 Get restaurants:
 manager.queryRestaurantAtFirebase(withID: String) -> [Restaurant]
 
 
 TODO:
 error handling
 progress observing
 testing
 */

class DataManager {
    // to add a restaurant
    // TODO: fetch possible restaurants in yelp if we want to provide a range of restaurants for users to choose.
    // In addition, we need to create a new struct for mere yelp business info
    
    // store info
    static let storageRef = Storage.storage().reference()
    static let restaurantsRef = Firestore.firestore().collection("restaurants")
    static let geoRestaurants = GeoFirestore(collectionRef: restaurantsRef)
    
    func createRestaurant(AtLatitude latitude: CLLocationDegrees, longitude: CLLocationDegrees, withName name: String, withPhotos photos: [UIImage]) -> Restaurant? {
        // try to get the info in yelp
        guard let url = URL(string: "https://api.yelp.com/v3/businesses/search?term=\(name)&latitude=\(latitude)&longitude=\(longitude)&radius=50") else {
            return nil
        }
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        // try to decode the returned json from Yelp
        let api_results: YelpAPIResults = try! JSONDecoder().decode(YelpAPIResults.self, from: data)
        
        // FIXME: need to test the real returning results
        if api_results.total > 0 {
            let business = api_results.businesses[0]
            return createRestaurantWith(name: name, latitude: latitude, longitude: longitude, photos: photos, price: business.price, reviewCount: business.review_count, averageRating: business.rating, yelpId: business.id)
        } else {
            return createRestaurantWith(name: name, latitude: latitude, longitude: longitude, photos: photos, price: nil, reviewCount: nil, averageRating: nil, yelpId: nil)
        }
    }
    
    // create a Restaurant object and store it in our database
    func createRestaurantWith(name: String, latitude: Double, longitude: Double, photos: [UIImage], price: String?, reviewCount: Int?, averageRating: Double?, yelpId: String?) -> Restaurant? {
        // create a new document
        let docRef = DataManager.restaurantsRef.document()
        let id = docRef.documentID
        // save images and get the urls
        let imagesUrls = storeImagesAtFirebase(photos: photos, forDocumentWithID: id)
        
        // save locations
        storeLocationAtFirebase(latitude: latitude, longitude: longitude, forDocumentWithID: id)
        
        // save the restaurant
        let restaurant = Restaurant(id: id, name: name, latitude: latitude, longitude: longitude, photos: imagesUrls, price: price, reviewCount: reviewCount, averageRating: averageRating, yelpId: yelpId)
        docRef.setData(restaurant.dictionary)
        return restaurant
    }

    func storeImagesAtFirebase(photos: [UIImage], forDocumentWithID id: String) -> [URL] {
        let storageRef = DataManager.storageRef
        var imagesURLs: [URL] = []
        for (index, image) in photos.enumerated() {
            let imageRef = storageRef.child("\(id)/\(index).png")
            let data = image.pngData()
            
            // Upload the file to the path "restaurantID/imagesIndex"
            let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
                imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else { return }
                    imagesURLs.append(downloadURL)
                }
            }
        }
        return imagesURLs
    }
    
    func storeLocationAtFirebase(latitude: Double, longitude: Double, forDocumentWithID id: String) {
        DataManager.geoRestaurants.setLocation(location: CLLocation(latitude: latitude, longitude: longitude), forDocumentWithID: id) { (error) in
            if (error != nil) {
                print("An error occured: \(String(describing: error))")
            } else {
                print("Saved location successfully!")
            }
        }
    }
    
    func createRestaurant(withYelpBusiness business: YelpBusiness, withPhotos photos: [UIImage]) -> Restaurant? {
        return createRestaurantWith(name: business.name, latitude: business.coordinates.latitude, longitude: business.coordinates.longitude, photos: photos, price: business.price, reviewCount: business.review_count, averageRating: business.rating, yelpId: business.id)
    }
    
    
//    // try to fetch yelp info
//    func queryYelpInfoForRestaurant(AtLatitude latitude: CLLocationDegrees, longitude: CLLocationDegrees, withName name: String) -> Restaurant?{
//        return nil
//    }
//
//    //set yelp info for the restaurant
//    func setYelpInfoForRestaurant(_ restaurant: inout Restaurant, withYelpId id: String) -> Bool {
//        return false
//    }
    
    // to recognize
    // find nearby restaurants
    func queryRestaurantsAtLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> [Restaurant] {
        var restaurants: [Restaurant] = []
        let center = CLLocation(latitude: latitude, longitude: longitude)
        let query = DataManager.geoRestaurants.query(withCenter: center, radius: 0.05) //radius of 50 meters
        let queryHandle = query.observe(.documentEntered, with: { (key, location) in
            if let restaurant = self.queryRestaurantAtFirebase(withID: key!) {
                restaurants.append(restaurant)
            }
        })
        return restaurants
    }
    
    // get the restaurant with its id
    func queryRestaurantAtFirebase(withID id: String) -> Restaurant? {
        var restaurant: Restaurant?
        let docRef = DataManager.restaurantsRef.document(id)
        docRef.getDocument { (document, error) in
            if let result = document.flatMap({
                $0.data().flatMap({ (data) in
                    return Restaurant(dictionary: data)
                })
            }) {
                print("Restaurant: \(result)")
                restaurant = result
            } else {
                print("Document does not exist")
            }
        }
        return restaurant
    }
    
    // get images of a restaurant
    func queryPhotosOfRestaurant(withID id: String) -> [UIImage] {
        var photos: [UIImage] = []
        guard let restaurant = queryRestaurantAtFirebase(withID: id) else { return [] }
        for url in restaurant.photos {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    photos.append(image)
                }
            }
            
        }
        return photos
    }
    
    // TODO: return ARReference images of a restaurant
    // I find it needs a phsicalWidth and I have no idea how to set it
    func queryARReferenceImagesOfRestaurant(withID id: String) -> [ARReferenceImage]{
        let photos = queryPhotosOfRestaurant(withID: id)
        var references: [ARReferenceImage] = []
        for photo in photos {
            let arImage = ARReferenceImage(photo.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 2.5) //FIXME: physical width needed for each photo. Unit: meter
            references.append(arImage)
        }
        return references
    }
}
