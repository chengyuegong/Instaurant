//
//  WidthViewController.swift
//  instaurantApp
//
//  Created by 衡俊吉 on 12/2/18.
//  Author: Junji Heng
//  Copyright © 2018 CSE@WashU. All rights reserved.
//

import UIKit

protocol PassWidthProtocol {
    func setWidth(width:String)
}

class WidthViewController: UIViewController {
    var widthProtocol: PassWidthProtocol?
    var text: UITextField!
    
    @objc func handleRegister(sender: UIButton){
        print("Set the width to \(text.text!) meters")
        widthProtocol?.setWidth(width: text.text!)
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 1, alpha: 1)
        navigationItem.title = "Physical Width"
        let theTextFrame = CGRect(x: 0, y: 80, width: view.frame.width, height: 40)
        text = UITextField(frame: theTextFrame)
        text.backgroundColor = UIColor(white: 0.5, alpha: 0.1)
        text.borderStyle = .roundedRect
        text.attributedPlaceholder = NSAttributedString(string: "Enter the width (in meters)")
        text.keyboardType = .default
        text.clearButtonMode = .whileEditing
        view.addSubview(text)
        
        let buttonFrame = CGRect(x: 110, y: 150, width: 145, height: 36)
        let button = UIButton.init(type: .roundedRect)
        button.frame = buttonFrame
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        button.setTitle("Confirm", for: UIControl.State.normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blue.cgColor
        button.addTarget(self, action:#selector(handleRegister(sender:)), for: .touchUpInside)
        view.addSubview(button)
    }
}
