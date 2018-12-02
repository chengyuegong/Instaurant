//
//  YelpViewController.swift
//  InstaurantApp
//
//  Created by zifan on 11/26/18.
//  Copyright © 2018 CSE@WashU. All rights reserved.
//

import UIKit
import WebKit

class YelpViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = URL(string: "https://www.yelp.com")!
        let myURLRequest = URLRequest(url: url)
        webView.load(myURLRequest)
    }

}
