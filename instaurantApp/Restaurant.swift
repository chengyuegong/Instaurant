//
//  Restaurant.swift
//  Instaurant
//
//  Created by Metaphor on 11/20/18.
//  Copyright © 2018 CSE@WashU. All rights reserved.
//  Code modified from the google Firestore example project.

/*
 This is used to save our restaurants information
 
 usage: let r = some function returing result
 
 Additional attributes:
 r.UIImagesOfPhotos: return the photos of the resturant (UIImage)
 r.ARReferenceImagesOfPhotos: return the photos of the resturant (ARReferenceImage), currently not recommended since every ARReference needs physical size (temporarily set to 2.5m for each photo)
 */

import Foundation
import CoreLocation
import UIKit
import ARKit

struct Restaurant: Codable {
    
    // necessary info to recognize
    var id: String
    var name: String
    var latitude: Double
    var longitude: Double
    var photos: [URL]
    
    // review info
    var price: String? // from "$" to "$$$$"; could also be an enum
    var reviewCount: Int? // number of reviews
    var averageRating: Double? // [0,0.5,1,1.5...4.5,5]
    var yelpId: String?
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "name": name,
            "latitude": latitude,
            "longitude": longitude,
            "photos": photos,// ? photo.absoluteString
            
            "price": price as Any,
            "reviewCount": reviewCount as Any,
            "averageRating": averageRating as Any,
            "yelpId": yelpId as Any]
    }

}

extension Restaurant: DocumentSerializable {
    // get UIImages of the photos of this restaurant
    var UIImagesOfPhotos: [UIImage] {
        let dataManager = DataManager()
        return dataManager.queryPhotosOfRestaurant(withID: self.id)
    }
    
    // get ar references images of the photos of this restaurant
    var ARReferenceImagesOfPhotos: [ARReferenceImage] {
        let dataManager = DataManager()
        return dataManager.queryARReferenceImagesOfRestaurant(withID: self.id)
    }

    
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let id = dictionary["id"] as? String,
            let latitude = dictionary["latitude"] as? Double,
            let longitude = dictionary["longitude"] as? Double,
            let photos = dictionary["photos"] as? [URL] else { return nil }
        
            let price = dictionary["price"] as? String
            let reviewCount = dictionary["reviewCount"] as? Int
            let averageRating = dictionary["averageRating"] as? Double
            let yelpId = dictionary["yelpId"] as? String
            //let photo = (dictionary["photo"] as? String).flatMap(URL.init(string:))

        self.init(id: id,
                  name: name,
                  latitude: latitude,
                  longitude: longitude,
                  photos: photos,
                  price: price,
                  reviewCount: reviewCount,
                  averageRating: averageRating,
                  yelpId: yelpId)
    }
    
}

//struct Review {
//
//    var rating: Int // Can also be enum
//    var userID: String
//    var username: String
//    var text: String
//    var date: Date
//
//    var dictionary: [String: Any] {
//        return [
//            "rating": rating,
//            "userId": userID,
//            "userName": username,
//            "text": text,
//            "date": date
//        ]
//    }
//
//}
//
//extension Review: DocumentSerializable {
//
//    init?(dictionary: [String : Any]) {
//        guard let rating = dictionary["rating"] as? Int,
//            let userID = dictionary["userId"] as? String,
//            let username = dictionary["userName"] as? String,
//            let text = dictionary["text"] as? String,
//            let date = dictionary["date"] as? Date else { return nil }
//
//        self.init(rating: rating, userID: userID, username: username, text: text, date: date)
//    }
//
//}

