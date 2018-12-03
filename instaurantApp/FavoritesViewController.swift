//
//  FavoritesViewController.swift
//  instaurantApp
//
//  Created by Chengyue Gong on 2018/12/2.
//  Author: Chengyue Gong
//  Copyright © 2018 CSE@WashU. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let database = FavoritesDB()
    let dataManager = DataManager()
    @IBOutlet weak var theTableView: UITableView!
    var theFavorites: [dbRestaurant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Favorites"
        setUpTableView()
    }
    
    func setUpTableView() {
        theTableView.dataSource = self
        theTableView.delegate = self
        theTableView.register(UITableViewCell.self, forCellReuseIdentifier: "fCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        theFavorites = []
        theFavorites = database.loadDatabase()
        theTableView.reloadData()
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theFavorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "fCell")
        cell.textLabel!.text = theFavorites[indexPath.row].name
        cell.detailTextLabel!.text = theFavorites[indexPath.row].address
        return cell
    }
    
    // UITableViewDelegate
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            database.deleteFromDatabase(id: theFavorites[indexPath.row].id)
            theFavorites.remove(at: indexPath.row)
            theTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataManager.queryYelpBussinessDetail(withYelpID: theFavorites[indexPath.row].id) { (retDetail, err) in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "fav2detail", sender: retDetail)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fav2detail"{
            let dest = segue.destination as! DetailViewController
            dest.restaurant = (sender as! YelpBusinessDetail)
        }
    }

}

