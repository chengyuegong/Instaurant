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
    
    var urlString: String!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("Open webpage \(String(describing: urlString))")
        let url = URL(string: urlString)!
        let myURLRequest = URLRequest(url: url)
        webView.load(myURLRequest)
    }

}
