//
//  ImageViewController.swift
//  instaurantApp
//
//  Created by 衡俊吉 on 12/2/18.
//  Author: Junji Heng
//  Copyright © 2018 CSE@WashU. All rights reserved.
//


import UIKit

protocol PassImageProtocol {
    func setImage(image:UIImage)
}

class ImageViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var imageProtocol: PassImageProtocol?
    var myImageView: UIImageView!
    let imagePicker = UIImagePickerController()
    var theImage: [UIImage] = []
    
    @objc func handlePhotoFromAlbums(sender: UIButton){
        self.present(imagePicker,animated: true)
    }
    
    @objc func handleRegister(sender: UIButton){
        if (theImage.count > 0) {
            imageProtocol?.setImage(image: theImage.last!)
            print("Upload a photo")
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 1, alpha: 1)
        navigationItem.title = "Upload a Photo"
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        let theImageFrame = CGRect(x: 0, y: 80, width: view.frame.width, height: 300)
        myImageView = UIImageView(frame: theImageFrame)
        myImageView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        myImageView.contentMode = .scaleAspectFit
        view.addSubview(myImageView)
        
        let buttonFrame = CGRect(x: 30, y: 400, width: 150, height: 30)
        let button = UIButton.init(type: .roundedRect)
        button.frame = buttonFrame
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        button.setTitle("Photo from Albums", for: UIControl.State.normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blue.cgColor
        button.addTarget(self, action:#selector(handlePhotoFromAlbums(sender:)), for: .touchUpInside)
        view.addSubview(button)
        
        let buttonFrame2 = CGRect(x: 230, y: 400, width: 100, height: 30)
        let button2 = UIButton.init(type: .roundedRect)
        button2.frame = buttonFrame2
        button2.backgroundColor = UIColor.white
        button2.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        button2.setTitle("Confirm", for: UIControl.State.normal)
        button2.layer.masksToBounds = true
        button2.layer.cornerRadius = 10
        button2.layer.borderWidth = 2
        button2.layer.borderColor = UIColor.blue.cgColor
        button2.addTarget(self, action:#selector(handleRegister(sender:)), for: .touchUpInside)
        view.addSubview(button2)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            theImage.append(image)
            myImageView.image = theImage.last
        }
        self.dismiss(animated: true, completion: nil)
    }

}
