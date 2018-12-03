//
//  DataManager.swift
//  instaurantApp
//
//  Created by Metaphor on 11/20/18.
//  Author: Tiancheng He
//  Copyright © 2018 CSE@WashU. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import ARKit
import Firebase
import Geofirestore
//import FirebaseStorage

class DataManager {
    static let storageRef = Storage.storage().reference() // use Cloud Storage to store images
    static let restaurantsRef = Firestore.firestore().collection("restaurants") // use Firestore to store restaurants
    static let geoRestaurants = GeoFirestore(collectionRef: restaurantsRef) // use GeoFirestore to query restaurants within some loction
    static private let API_key = "E2A_xJMsnSy8fJ5UN6nq6l4ZDy9iFSVRAvfKtvB86-6_sZwx_AyjJEHrGpzAkjBAlQWbKpRQR4-0YqIWTpV565X4DXbPJLQabFDWST9lx6xr4fSNqQNq7C-oQLQAXHYx"
    
    // MARK: to add a restaurant
    // fetch possible restaurants in yelp
    func findPossibleRestaurants(AtLatitude latitude: CLLocationDegrees, longitude: CLLocationDegrees, withName name: String, withRadiusByMeter radius: Int ,completion: @escaping ([YelpBusiness])->Void) {
        // try to get the info in yelp.
        let escapedName = name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: "https://api.yelp.com/v3/businesses/search?term=\(escapedName)&latitude=\(latitude)&longitude=\(longitude)&radius=\(radius)&limit=10")!
        let task = queryYelpAPI(url: url) {
            (data, response, error) in
            // try to decode the returned json from Yelp
            guard let api_results: YelpAPIResults = try? JSONDecoder().decode(YelpAPIResults.self, from: data!) else { return }
            //            print("[tiancheng] api results: \(String(describing: api_results))")
            completion(api_results.businesses)
        }
        task.resume()
    }
    
    func createRestaurant(latitude: CLLocationDegrees, longitude: CLLocationDegrees, withName name: String, withPhoto photo: UIImage, physicalWidthByMeter physicalSize: Double, yelpID: String, completion: @escaping (Restaurant, Error?)->Void) -> Void {
        self.createRestaurantWith(name: name, latitude: latitude, longitude: longitude, photos: [photo], physicalSize: physicalSize, price: nil, reviewCount: nil, averageRating: nil, yelpId: yelpID) {
            (restaurant, error) in
            completion(restaurant, error)
        }
    }
    
    private func queryYelpAPI(url: URL, completion:(@escaping (Data?, URLResponse?, Error?) -> Void)) -> URLSessionDataTask {
        var request: URLRequest = URLRequest(url: url)
        request.setValue("Bearer \(DataManager.API_key)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10
        return URLSession.shared.dataTask(with: request, completionHandler: completion)
    }
    
    // create a Restaurant object and store it in our database
    private func createRestaurantWith(name: String, latitude: Double, longitude: Double, photos: [UIImage], physicalSize: Double, price: String?, reviewCount: Int?, averageRating: Double?, yelpId: String, completion: @escaping (Restaurant, Error?)->Void) -> Void {
        // create a new document
        let docRef = DataManager.restaurantsRef.document()
        let id = docRef.documentID
        
        // first, save images
        _ = storeImagesAtFirebase(photos: photos, forDocumentWithID: id, withYelpID: yelpId) {  (url, error) in
            // second, store locations
            self.storeLocationAtFirebase(latitude: latitude, longitude: longitude, forDocumentWithID: id) { (error) in
                // third, perform completion handler
                let restaurant = Restaurant(id: id, name: name, latitude: latitude, longitude: longitude, photos: [url], physicalSize: physicalSize, yelpId: yelpId)
                docRef.setData(restaurant.dictionary, merge: true) {
                    (error) in
                    completion(restaurant,error)
                }
            }
        }
    }
    
    private func storeImagesAtFirebase(photos: [UIImage], forDocumentWithID id: String, withYelpID yelpID: String, completion: @escaping (URL, Error?)->Void) -> Void {
        let storageRef = DataManager.storageRef
        var imagesURLs: [URL] = []
        if photos.count == 0 { return }
        let image = photos[0].resizedTo1MB() ?? photos[0]
        let imageRef = storageRef.child("\(id)/\(yelpID).png")
        let data = image.pngData()
        
        // Upload the file to the path "restaurantID/imagesIndex"
        _ = imageRef.putData(data!, metadata: nil) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else { return }
                imagesURLs.append(downloadURL)
                // completion handler
                completion(imagesURLs[0], error)
            }
        }
    }
    
    private func storeLocationAtFirebase(latitude: Double, longitude: Double, forDocumentWithID id: String, completion: @escaping (Error?) -> Void) {
        DataManager.geoRestaurants.setLocation(location: CLLocation(latitude: latitude, longitude: longitude), forDocumentWithID: id) { (error) in
            if (error != nil) {
                print("An error occured: \(String(describing: error))")
            } else {
                completion(error)
            }
        }
    }
    
    //MARK: to recognize
    // find nearby restaurants
    func queryRestaurantsAtLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping ([Restaurant])->Void) -> Void {
        var restaurants: [Restaurant] = []
        let center = CLLocation(latitude: latitude, longitude: longitude)
        let query = DataManager.geoRestaurants.query(withCenter: center, radius: 0.05) //radius of 50 meters
        let dispatchGroup = DispatchGroup()
        //var queries: [(String,(Restaurant,Error?)->Void)->Void] = []
        dispatchGroup.enter()
        let _ = query.observe(.documentEntered, with: { (key, location) in
            dispatchGroup.enter()
            self.queryRestaurantAtFirebase(withID: key!) { (restaurant, error) in
                restaurants.append(restaurant)
                dispatchGroup.leave()
            }
        })
        dispatchGroup.leave()
        let _ = query.observeReady {
            dispatchGroup.notify(queue: .main) {
                completion(restaurants)
            }
        }
    }
    
    // get the restaurant with its id
    func queryRestaurantAtFirebase(withID id: String, completion:@escaping (Restaurant, Error?)->Void) -> Void {
        let docRef = DataManager.restaurantsRef.document(id)
        docRef.getDocument { (document, error) in
            if let result = document.flatMap({
                $0.data().flatMap({ (data) in
                    return Restaurant(dictionary: data)
                })
            }) {
                // perform completion handler
                print("Restaurant: \(result)")
                completion(result, error)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    // get the yelp info with its yelp id
    func queryYelpBussinessDetail(withYelpID id: String, completion:@escaping (YelpBusinessDetail, Error?)->Void) -> Void {
        let url = URL(string: "https://api.yelp.com/v3/businesses/\(id)")!
        let task = queryYelpAPI(url: url) { (data, response, error) in
            // try to decode the returned json from Yelp
            guard let api_result: YelpBusinessDetail = try? JSONDecoder().decode(YelpBusinessDetail.self, from: data!) else {return}
            completion(api_result, error)
        }
        task.resume()
    }
    
    
    
    
    // Unused and stored methods
    
    //    // get images of a restaurant
    //    func queryPhotosOfRestaurant(withID id: String, completion:@escaping ([UIImage], Error?)->Void) -> Void {
    //        var photos: [UIImage] = []
    //        queryRestaurantAtFirebase(withID: id){ (restaurant, error) in
    //            if (restaurant.photos.count > 0) {
    //                for url in restaurant.photos {
    //                    if let data = try? Data(contentsOf: url) {
    //                        if let image = UIImage(data: data) {
    //                            photos.append(image)
    //                        }
    //                    }
    //                }
    //                completion(photos, error)
    //            }
    //        }
    //    }
    //
    //
    //
    //    // TODO: return ARReference images of a restaurant
    //    // I find it needs a phsicalWidth and I have no idea how to set it
    //    func queryARReferenceImagesOfRestaurant(withID id: String) -> [ARReferenceImage]{
    //        let photos = queryPhotosOfRestaurant(withID: id)
    //        var references: [ARReferenceImage] = []
    //        for photo in photos {
    //            let arImage = ARReferenceImage(photo.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 2.5) //FIXME: physical width needed for each photo. Unit: meter
    //            references.append(arImage)
    //        }
    //        return references
    //    }
    //
    //    func queryARReferenceImagesOfRestaurant(withID id: String, completion:@escaping ([ARReferenceImage], Error?)->Void) -> Void {
    //        var photos: [UIImage] = []
    //        queryPhotosOfRestaurant(withID: id) { (images, error) in
    //            for photo in photos {
    //                let arImage = ARReferenceImage(photo.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: 2.5) //FIXME: physical width needed for each photo. Unit: meter
    //                references.append(arImage)
    //            }
    //        }
    //
    //        queryRestaurantAtFirebase(withID: id){ (restaurant, error) in
    //            if (restaurant.photos.count > 0) {
    //                for url in restaurant.photos {
    //                    if let data = try? Data(contentsOf: url) {
    //                        if let image = UIImage(data: data) {
    //                            photos.append(image)
    //                        }
    //                    }
    //                }
    //                completion(photos, error)
    //            }
    //        }
    //    }
    
    
    //    func createRestaurant(AtLatitude latitude: CLLocationDegrees, longitude: CLLocationDegrees, withName name: String, withPhotos photos: [UIImage], physicalWidthByMeter physicalSize: Double, completion: @escaping (Restaurant, Error?)->Void) -> Void {
    //        // try to get the info in yelp.
    //        let url = URL(string: "https://api.yelp.com/v3/businesses/search?term=\(name)&latitude=\(latitude)&longitude=\(longitude)&radius=50&limit=10")!
    //        let task = queryYelpAPI(url: url) {
    //            (data, response, error) in
    //            // try to decode the returned json from Yelp
    //            guard let api_results: YelpAPIResults = try? JSONDecoder().decode(YelpAPIResults.self, from: data!) else { return }
    //            print("[tiancheng] api results: \(String(describing: api_results))")
    //            if api_results.total > 0 {
    //                let business = api_results.businesses[0]
    //                _ = self.createRestaurantWith(name: name, latitude: latitude, longitude: longitude, photos: photos, physicalSize: physicalSize, price: business.price, reviewCount: business.review_count, averageRating: business.rating, yelpId: business.id) { (restaurant, error) in
    //                    completion(restaurant, error)
    //                }
    //            } else {
    //                _ = self.createRestaurantWith(name: name, latitude: latitude, longitude: longitude, photos: photos, physicalSize: physicalSize, price: nil, reviewCount: nil, averageRating: nil, yelpId: nil) { (restaurant, error) in
    //                    completion(restaurant, error)
    //                }
    //            }
    //        }
    //        task.resume()
    //    }
    
    
    
}
