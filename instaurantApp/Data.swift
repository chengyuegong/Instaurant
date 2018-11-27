//
//  Data.swift
//  Instaurant
//
//  Created by Metaphor on 11/21/18.
//  Copyright © 2018 CSE@WashU. All rights reserved.
//

import Foundation

struct YelpAPIResults: Decodable {
    let total: Int
    let businesses: [YelpBusiness]
}

struct YelpBusiness: Codable {
    let id: String!
    let coordinates: Coordinates!
    let name: String!
    let price: String!
    let rating: Double!
    let review_count: Int!
}

struct Coordinates: Codable {
    let longitude: Double!
    let latitude: Double!
}


