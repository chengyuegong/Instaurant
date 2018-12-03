//
//  Restaurant.swift
//  instaurantApp
//
//  Created by Metaphor on 11/20/18.
//  Author: Tiancheng He
//  Copyright © 2018 CSE@WashU. All rights reserved.
//
//  Note: Code modified from the google Firestore example project.

/* The restaurant data from firebase
 * r.arImage: return ARReferenceImage (for AR detection)
 * r.details(completionHandler): return YelpBusinessDetail (need callback function)
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
    var physicalSize: Double
    
    // review info
    var yelpId: String
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "name": name,
            "latitude": latitude,
            "longitude": longitude,
            "photos": photos.map{ $0.absoluteString },// ? photo.absoluteString
            "physicalSize": physicalSize,
            
            "yelpId": yelpId]
    }
    
    
    // get yelp details object of this restaurant, including:
    // yelp url
    // categories
    // location
    // display phone
    // photos
    
    func details(completion: @escaping (YelpBusinessDetail, Error?)->Void) {
        let manager = DataManager()
        manager.queryYelpBussinessDetail(withYelpID: yelpId, completion: completion)
    }
    
    //    var details: YelpBusinessDetail? {
    //        let manager = DataManager()
    //        return yelpId != nil ? manager.queryYelpBussinessDetail(withYelpID: yelpId!) : nil
    //    }
    
    // get UIImages of the photos of this restaurant
    var uiImage: UIImage? {
        if photos.count < 1 {return nil}
        let url = photos[0]
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
    
    var arImage: ARReferenceImage? {
        guard let image = self.uiImage else {return nil}
        return ARReferenceImage(image.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: CGFloat(self.physicalSize))
    }
    
//    var UIImagesOfPhotos: [UIImage] {
//        var imagesOfPhotos: [UIImage] = []
//        for url in self.photos {
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    imagesOfPhotos.append(image)
//                }
//            }
//        }
//        return imagesOfPhotos
//    }
//    
//    // get ar references images of the photos of this restaurant
//    var ARReferenceImagesOfPhotos: [ARReferenceImage] {
//        var imagesOfPhotos: [ARReferenceImage] = []
//        for photo in self.UIImagesOfPhotos {
//            let arImage = ARReferenceImage(photo.cgImage!, orientation: CGImagePropertyOrientation.up, physicalWidth: CGFloat(self.physicalSize))
//            imagesOfPhotos.append(arImage)
//        }
//        return imagesOfPhotos
//    }
}

extension Restaurant: DocumentSerializable {
    
    init?(dictionary: [String : Any]) {
        guard let name = dictionary["name"] as? String,
            let id = dictionary["id"] as? String,
            let latitude = dictionary["latitude"] as? Double,
            let longitude = dictionary["longitude"] as? Double,
            let photoURLStrings = dictionary["photos"] as? [String],
            let physicalSize = dictionary["physicalSize"] as? Double,
            let yelpId = dictionary["yelpId"] as? String else { return nil }
        
        guard let photos = photoURLStrings.map(URL.init(string:)) as? [URL] else { return nil}
        
        //            let price = dictionary["price"] as? String
        //            let reviewCount = dictionary["reviewCount"] as? Int
        //            let averageRating = dictionary["averageRating"] as? Double
        //let photo = (dictionary["photo"] as? String).flatMap(URL.init(string:))
        
        self.init(id: id,
                  name: name,
                  latitude: latitude,
                  longitude: longitude,
                  photos: photos,
                  physicalSize: physicalSize,
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

