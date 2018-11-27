//
//  DetailController.swift
//  Instaurant
//
//  Created by zifan on 11/26/18.
//  Copyright © 2018 CSE@WashU. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    @IBOutlet weak var ResImage: UIImageView!
    
    @IBOutlet weak var ResName: UILabel!
    
    @IBOutlet weak var Price: UILabel!
    
    @IBOutlet weak var RatingCount: UILabel!
    
    @IBOutlet weak var StarOne: UIImageView!
    
    @IBOutlet weak var StarTwo: UIImageView!
    
    @IBOutlet weak var StarThree: UIImageView!
    
    @IBOutlet weak var StarFour: UIImageView!
    
    @IBOutlet weak var StarFive: UIImageView!
    
    
    func ResDetail(res: Restaurant){
        
        let path = res.photos[0].path
        let url = URL(string: path)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        
        ResImage.image = image
        ResName.text = res.name
        Price.text = String(res.price!)
        RatingCount.text = String(res.ratingCount!)
        let AveRating = res.averageRating
        
        if(AveRating == 0){
            StarOne.image = UIImage(named: "emptyStar")
            StarTwo.image = UIImage(named: "emptyStar")
            StarThree.image = UIImage(named: "emptyStar")
            StarFour.image = UIImage(named: "emptyStar")
            StarFive.image = UIImage(named: "emptyStar")
        }
        if(AveRating == 0.5){
            StarOne.image = UIImage(named: "halfStar")
            StarTwo.image = UIImage(named: "emptyStar")
            StarThree.image = UIImage(named: "emptyStar")
            StarFour.image = UIImage(named: "emptyStar")
            StarFive.image = UIImage(named: "emptyStar")
        }
        if(AveRating == 1){
            StarOne.image = UIImage(named: "filledStar")
            StarTwo.image = UIImage(named: "emptyStar")
            StarThree.image = UIImage(named: "emptyStar")
            StarFour.image = UIImage(named: "emptyStar")
            StarFive.image = UIImage(named: "emptyStar")
        }
        if(AveRating == 1.5){
            StarOne.image = UIImage(named: "filledStar")
            StarTwo.image = UIImage(named: "halfStar")
            StarThree.image = UIImage(named: "emptyStar")
            StarFour.image = UIImage(named: "emptyStar")
            StarFive.image = UIImage(named: "emptyStar")
        }
        if(AveRating == 2){
            StarOne.image = UIImage(named: "filledStar")
            StarTwo.image = UIImage(named: "filledStar")
            StarThree.image = UIImage(named: "emptyStar")
            StarFour.image = UIImage(named: "emptyStar")
            StarFive.image = UIImage(named: "emptyStar")
        }
        if(AveRating == 2.5){
            StarOne.image = UIImage(named: "filledStar")
            StarTwo.image = UIImage(named: "filledStar")
            StarThree.image = UIImage(named: "halfStar")
            StarFour.image = UIImage(named: "emptyStar")
            StarFive.image = UIImage(named: "emptyStar")
        }
        if(AveRating == 3){
            StarOne.image = UIImage(named: "filledStar")
            StarTwo.image = UIImage(named: "filledStar")
            StarThree.image = UIImage(named: "filledStar")
            StarFour.image = UIImage(named: "emptyStar")
            StarFive.image = UIImage(named: "emptyStar")
        }
        if(AveRating == 3.5){
            StarOne.image = UIImage(named: "filledStar")
            StarTwo.image = UIImage(named: "filledStar")
            StarThree.image = UIImage(named: "filledStar")
            StarFour.image = UIImage(named: "halfStar")
            StarFive.image = UIImage(named: "emptyStar")
        }
        if(AveRating == 4){
            StarOne.image = UIImage(named: "filledStar")
            StarTwo.image = UIImage(named: "filledStar")
            StarThree.image = UIImage(named: "filledStar")
            StarFour.image = UIImage(named: "filledStar")
            StarFive.image = UIImage(named: "emptyStar")
        }
        if(AveRating == 4.5){
            StarOne.image = UIImage(named: "filledStar")
            StarTwo.image = UIImage(named: "filledStar")
            StarThree.image = UIImage(named: "filledStar")
            StarFour.image = UIImage(named: "filledStar")
            StarFive.image = UIImage(named: "halfStar")
        }
        if(AveRating == 5){
            StarOne.image = UIImage(named: "filledStar")
            StarTwo.image = UIImage(named: "filledStar")
            StarThree.image = UIImage(named: "filledStar")
            StarFour.image = UIImage(named: "filledStar")
            StarFive.image = UIImage(named: "filledStar")
        }
        
        
    }
    
   
    
    
}
