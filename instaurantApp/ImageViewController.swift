//
//  ImageViewController.swift
//  fortesting
//
//  Created by 衡俊吉 on 12/2/18.
//  Copyright © 2018 junji. All rights reserved.
//


import UIKit
protocol PassImageProtocol {
    func setImage(image:UIImage)
}
class ImageViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var imageProtocol: PassImageProtocol?
    var myImageView: UIImageView!
    let image = UIImagePickerController()
    var theImage: [UIImage] = []
    var button: UIButton!
    var button2: UIButton!
    @objc func handlePhotoFromAlbums(sender: UIButton){
        sender.isUserInteractionEnabled = true
        sender.alpha = 0.4
        sender.setTitle("Photo from Albums", for: UIControl.State.normal)
        sender.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        self.present(image,animated: true)
        //button2.isEnabled = true
//        self.button.isEnabled = true

        //navigationController?.popViewController(animated: true)
        
    }
    @objc func handlePhotoFromCamera(sender: UIButton){

        imageProtocol?.setImage(image: theImage.last!)
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 1, alpha: 1)
        navigationItem.title = "Image"
        let theImageFrame = CGRect(x: 0, y: 80, width: view.frame.width, height: 300)
        myImageView = UIImageView(frame: theImageFrame)
        myImageView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        myImageView.contentMode = .center
        view.addSubview(myImageView)
        //imageView.image = image
        
        let buttonFrame = CGRect(x: 30, y: 400, width: 150, height: 30)
        button = UIButton.init(type: .system)
        button.frame = buttonFrame
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        button.setTitle("Photo from Albums", for: UIControl.State.normal)
//        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blue.cgColor
        button.addTarget(self, action:#selector(handlePhotoFromAlbums(sender:)), for: .touchUpInside)
        view.addSubview(button)
        
        let buttonFrame2 = CGRect(x: 230, y: 400, width: 100, height: 30)
        button2 = UIButton.init(type: .system)
        button2.frame = buttonFrame2
        button2.backgroundColor = UIColor.white
        button2.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        button2.setTitle("OK", for: UIControl.State.normal)
        button2.layer.masksToBounds = true
        button2.layer.cornerRadius = 10
        button2.layer.borderWidth = 2
        button2.layer.borderColor = UIColor.blue.cgColor
        button2.addTarget(self, action:#selector(handlePhotoFromCamera(sender:)), for: .touchDown)
        view.addSubview(button2)
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            theImage.append(image)
            myImageView.image = theImage.last
            myImageView.contentMode = .scaleAspectFit
        }
        self.dismiss(animated: true, completion: nil)
    }

}
