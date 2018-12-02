//
//  DetailController.swift
//  Instaurant
//
//  Created by zifan on 11/26/18.
//  Copyright © 2018 CSE@WashU. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var res: YelpBusiness?
    @IBOutlet weak var ratingStars: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        navigationItem.title = res!.name
//        displayDetail()
    }
    
    @IBAction func Favorate(_ sender: Any) {
        //FavButton.image = UIImage(named: "filledai")
    }
    
    
    func displayDetail() {
//        for i in 0..<res.photos.count {
//            let path = res.photos[i].path
//            let url = URL(string: path)
//            let data = try? Data(contentsOf: url!)
//            let image = UIImage(data: data!)
//            let imageView = UIImageView()
//            let x = self.view.frame.size.width * CGFloat(i)
//            imageView.frame = CGRect(x: x, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//            imageView.contentMode = .scaleAspectFit
//            imageView.image = image
//            ResImg.contentSize.width = ResImg.frame.size.width * CGFloat(i + 1)
//            ResImg.addSubview(imageView)
//        }
//
//        Price.text = String(res.price!)
//
        let rating = res!.rating
        
        if (rating == 0){
            ratingStars.image = UIImage(named: "0")
        } else if (rating == 1){
            ratingStars.image = UIImage(named: "1")
        } else if (rating == 1.5){
            ratingStars.image = UIImage(named: "1.5")
        } else if (rating == 2){
            ratingStars.image = UIImage(named: "2")
        } else if (rating == 2.5){
            ratingStars.image = UIImage(named: "2.5")
        } else if (rating == 3){
            ratingStars.image = UIImage(named: "3")
        } else if (rating == 3.5){
            ratingStars.image = UIImage(named: "3.5")
        } else if(rating == 4){
            ratingStars.image = UIImage(named: "4")
        } else if(rating == 4.5){
            ratingStars.image = UIImage(named: "4.5")
        } else if(rating == 5){
            ratingStars.image = UIImage(named: "5")
        }
    }
    
    
    @IBAction func toYelpPage(_ sender: UIButton) {
        //performSegue(withIdentifier: "detail2yelp", sender: res.url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detail2yelp") {
            let dest = segue.destination as! YelpViewController
            dest.urlString = (sender as! String)
        }
    }
    
}
