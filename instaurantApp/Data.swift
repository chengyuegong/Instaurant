//
//  Data.swift
//  instaurantApp
//
//  Created by Metaphor on 11/21/18.
//  Author: Tiancheng He
//  Copyright © 2018 CSE@WashU. All rights reserved.
//

// Accept the json data return from yelp api

import Foundation

// for possible restaurants near some place
struct YelpBusiness: Codable {
    let id: String
    let coordinates: Coordinates
    let name: String
    //    let price: String
    //    let rating: Double
    //    let review_count: Int
    let location: Location
}

// for detail view
struct YelpBusinessDetail: Codable {
    let id: String!
    let url: String!
    let name: String!
    let price: String!
    let rating: Double!
    let review_count: Int!
    
    let display_phone: String?
    let photos: [String]
    let categories: [Category]
    let location: Location
    
}

struct Coordinates: Codable {
    let longitude: Double!
    let latitude: Double!
}

struct Category: Codable {
    let alias: String!
    let title: String!
}

struct Location: Codable {
    let display_address: [String]
}

struct YelpAPIResults:Decodable {
    let total: Int
    let businesses: [YelpBusiness]
}

