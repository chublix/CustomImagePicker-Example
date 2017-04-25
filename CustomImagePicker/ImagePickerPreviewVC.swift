//
//  ImagePickerPreviewVC.swift
//  CustomImagePicker
//
//  Created by Andrey Chuprina on 2/2/16.
//  Copyright © 2016 Andrey Chuprina. All rights reserved.
//

import UIKit
import GPUImage

@objc protocol ImagePickerPreviewDelegate {
    @objc optional func imagePickerPreview(_ originalImage: UIImage?, filteredImage: UIImage?);
    @objc optional func imagePickerPreviewCancel();
}

class ImagePickerPreviewVC: UIViewController {

    @IBOutlet fileprivate weak var imageView: UIImageView!
    @IBOutlet fileprivate var optionSliders: [UISlider]!
    
    var delegate: ImagePickerPreviewDelegate?
    
    fileprivate var image: UIImage?
    let imageFilter =  ColorBalanceFilter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateImage()
    }
    
    fileprivate func updateImage() {
        imageView.image = imageFilter.image(byFilteringImage: image)
    }
    
    func setImage(image im: UIImage?) {
        image = im
    }

    @IBAction func sliderValueChanged(_ sender: AnyObject) {
        if let index = optionSliders.index(of: sender as! UISlider) { 
            switch index {
                case 0:
                    imageFilter.redColor = CGFloat(optionSliders[index].value)
                case 1:
                    imageFilter.greenColor = CGFloat(optionSliders[index].value)
                case 2:
                    imageFilter.blueColor = CGFloat(optionSliders[index].value)
                default: break
            }
            updateImage()
        }
    }
    
    @IBAction func okButtonTouch(_ sender: AnyObject) {
        dismiss(animated: false, completion: nil)
        delegate?.imagePickerPreview?(image, filteredImage: imageView.image)
    }
    
    @IBAction func cancelButtonTouch(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
        delegate?.imagePickerPreviewCancel?()
    }
    
    @IBAction func optionSwitched(_ sender: AnyObject) {
        imageFilter.option = (sender as! UISwitch).isOn
        updateImage()
    }
}
