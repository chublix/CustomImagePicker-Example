//
//  ViewController.swift
//  CustomImagePicker
//
//  Created by Andrey Chuprina on 2/2/16.
//  Copyright © 2016 Andrey Chuprina. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak fileprivate var imageView: UIImageView!
    @IBOutlet weak fileprivate var filteredImageView: UIImageView!

    @IBAction func pickImageButtonTouch(_ sender: AnyObject) {
        let imagePicker = ImagePickerVC.loadFromStoryboard()
        imagePicker?.delegate = self
        show(imagePicker!, sender: nil)
    }

}

extension ViewController: ImagePickerDelegate {

    func imagePicker(pickedImage image: UIImage?, filteredImage: UIImage?) {
        imageView.image = image
        filteredImageView.image = filteredImage
    }
    
}

