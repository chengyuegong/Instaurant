//
//  WidthViewController.swift
//  fortesting
//
//  Created by 衡俊吉 on 12/2/18.
//  Copyright © 2018 junji. All rights reserved.
//

import UIKit
protocol PassWidthProtocol {
    func setWidth(width:String)
}
class WidthViewController: UIViewController {
    var widthProtocol: PassWidthProtocol?
    var text: UITextField!
    @objc func handleRegister(sender: UIButton){
        sender.isUserInteractionEnabled = false
        sender.alpha = 0.4
        sender.setTitle("Add the Width", for: .normal)
        print(text.text!)
        widthProtocol?.setWidth(width: text.text!)
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 1, alpha: 0.5)
        navigationItem.title = "Width"
        let theTextFrame = CGRect(x: 0, y: 80, width: view.frame.width, height: 40  )
        text = UITextField(frame: theTextFrame)
        text.backgroundColor = UIColor.white
        text.borderStyle = .roundedRect
        text.attributedPlaceholder = NSAttributedString(string: "Enter the Width")
        text.keyboardType = .default
        text.clearButtonMode = .whileEditing
        view.addSubview(text)
        let buttonFrame = CGRect(x: 100, y: 135, width: 175, height: 36  )
        let button = UIButton.init(type: .roundedRect)
        button.frame = buttonFrame
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        button.setTitle("Add the Width", for: UIControl.State.normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blue.cgColor
        button.addTarget(self, action:#selector(handleRegister(sender:)), for: .touchUpInside)
        view.addSubview(button)
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
