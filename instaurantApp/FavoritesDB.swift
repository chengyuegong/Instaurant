//
//  FavoritesDB.swift
//  instaurantApp
//
//  Created by Chengyue Gong on 2018/12/2.
//  Author: Chengyue Gong
//  Copyright © 2018 CSE@WashU. All rights reserved.
//

// NOTE: The code is based on the source code of ChengyueGong-Lab4 

import Foundation

struct dbRestaurant {
    let id: String
    let name: String
    let address: String
    init(id: String, name: String, address: String) {
        self.id = id
        self.name = name
        self.address = address
    }
}

class FavoritesDB {
    var database: FMDatabase
    
    init() {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dbPath = docPath[0] + "/favorites.db"
        var fileExists = true
        if (!FileManager.default.fileExists(atPath: dbPath)) {
            fileExists = false
        }
        database = FMDatabase(path: dbPath)
        if (!database.open()) {
            print("Failed to open database")
        }
        if (!fileExists) {
            print("create a database at \(dbPath)")
            let sqlStatement = "CREATE TABLE FAVORITES(ID STRING PRIMARY KEY, NAME STRING NOT NULL, ADDRESS STRING)"
            print("create a database: \(sqlStatement)")
            if (!database.executeStatements(sqlStatement)) {
                print("Failed to create a table")
            }
        }
    }
    
    func loadDatabase() -> [dbRestaurant] {
        var theFavorites: [dbRestaurant] = []
        do {
            let sqlStatement = "SELECT * FROM FAVORITES"
            print("load: \(sqlStatement)")
            let results = try database.executeQuery(sqlStatement, values: nil)
            while (results.next()) {
                let id = results.string(forColumn: "id")
                let name = results.string(forColumn: "name")
                let address = results.string(forColumn: "address")
                print("Load restaurant: \(id!), \(name!) at \(address!)")
                theFavorites.append(dbRestaurant(id:id!, name:name!, address: address!))
            }
        } catch let error as NSError {
            print("Failed: \(error)")
        }
        return theFavorites
    }
    
    func addToDatabase(id: String, name: String, address: String) {
        let name = name.replacingOccurrences(of: "'", with: "''")
        let sqlStatement = "INSERT INTO FAVORITES (ID,NAME,ADDRESS) VALUES ('\(id)','\(name)','\(address)')"
        print("add: \(sqlStatement)")
        if (!database.executeStatements(sqlStatement)) {
            print("Failed to add \(name)(\(id)) to database")
        }
    }
    
    func deleteFromDatabase(id: String) {
        let sqlStatement = "DELETE FROM FAVORITES WHERE ID = '\(id)'"
        print("delete: \(sqlStatement)")
        if (!database.executeStatements(sqlStatement)) {
            print("Failed to delete the restaurant(\(id)) from database")
        }
    }
    
    func searchForRestaurant(id: String) -> Bool {
        let sqlStatement = "SELECT * FROM FAVORITES WHERE ID = '\(id)'"
        print("search: \(sqlStatement)")
        do {
            let results = try database.executeQuery(sqlStatement, values: nil)
            if (results.next()) {
                let name = results.string(forColumn: "name")
                print("The restaurant(\(id)) \(name!) was in the favorites!")
                return true
            }
        } catch let error as NSError {
            print("Failed: \(error)")
        }
        return false
    }
}
