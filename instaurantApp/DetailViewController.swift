//
//  DetailController.swift
//  instaurantApp
//
//  Created by zifan on 11/26/18.
//  Author: Zifan Wan & Chengyue Gong
//  Copyright © 2018 CSE@WashU. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let database = FavoritesDB()
    var restaurant: YelpBusinessDetail!
    
    @IBOutlet weak var favBtn: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var location1: UILabel!
    @IBOutlet weak var location2: UILabel!
    @IBOutlet weak var categories: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var ratingStars: UIImageView!
    @IBOutlet weak var reviewCount: UILabel!
    @IBOutlet weak var phone: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = restaurant.name
        displayDetail()
    }

    override func viewWillAppear(_ animated: Bool) {
        setButtonImage()
    }
    
    func setButtonImage() {
        if (database.searchForRestaurant(id: restaurant.id)) {
            favBtn.image = UIImage(named: "filledHeart")
        } else {
            favBtn.image = UIImage(named: "emptyHeart")
        }
    }

    func displayDetail() {
        displayPhotos()
        if (restaurant.location.display_address.count >= 2) {
            location1.text = restaurant.location.display_address[0]
            location2.text = restaurant.location.display_address.last
        } else {
            location1.text = "Unknown address"
        }
        displayCategories()
        price.text = restaurant.price
        displayRating()
        reviewCount.text = String(restaurant.review_count) + " Reviews"
        phone.setTitle(restaurant.display_phone, for: .normal)
    }
    
    func displayPhotos() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize.width = scrollView.frame.size.width * CGFloat(restaurant.photos.count)
        scrollView.isPagingEnabled = true
        var i: Int = 0
        for path in restaurant.photos {
            let url = URL(string: path)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            let imageView = UIImageView()
            let x = view.frame.size.width * CGFloat(i)
            imageView.frame = CGRect(x: x, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            scrollView.addSubview(imageView)
            i += 1
        }
    }
    
    func displayCategories() {
        categories.text = ""
        for category in restaurant.categories {
            categories.text! += category.title
            categories.text! += " "
        }
    }
    
    func displayRating() {
        let rating = restaurant.rating
        if (rating == 5) {
            ratingStars.image = UIImage(named: "5")
        } else if (rating == 4.5) {
            ratingStars.image = UIImage(named: "4_half")
        } else if (rating == 4) {
            ratingStars.image = UIImage(named: "4")
        } else if (rating == 3.5) {
            ratingStars.image = UIImage(named: "3_half")
        } else if (rating == 3) {
            ratingStars.image = UIImage(named: "3")
        } else if (rating == 2.5) {
            ratingStars.image = UIImage(named: "2_half")
        } else if(rating == 2) {
            ratingStars.image = UIImage(named: "2")
        } else if(rating == 1.5) {
            ratingStars.image = UIImage(named: "1_half")
        } else if(rating == 1) {
            ratingStars.image = UIImage(named: "1")
        } else {
            ratingStars.image = UIImage(named: "0")
        }
    }
    
    @IBAction func addToFavorites(_ sender: UIBarButtonItem) {
        if (favBtn.image!.isEqual(UIImage(named: "emptyHeart"))) {
            let addr = location1.text! + ", " + location2.text!
            database.addToDatabase(id: restaurant.id, name: restaurant.name, address: addr)
            favBtn.image = UIImage(named: "filledHeart")
        } else {
            database.deleteFromDatabase(id: restaurant.id)
            favBtn.image = UIImage(named: "emptyHeart")
        }
        
    }
    
    @IBAction func toYelpPage(_ sender: UIButton) {
        performSegue(withIdentifier: "detail2yelp", sender: restaurant.url)
    }
    
    @IBAction func makeACall(_ sender: UIButton) {
        var phoneNumber = sender.titleLabel?.text
        phoneNumber = phoneNumber?.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: "telprompt://\(phoneNumber!)") {
            UIApplication.shared.open(url)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detail2yelp") {
            let dest = segue.destination as! YelpViewController
            dest.urlString = (sender as! String)
        }
    }
    
}
