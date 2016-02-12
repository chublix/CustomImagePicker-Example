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
    optional func imagePickerPreview(originalImage: UIImage?, filteredImage: UIImage?);
    optional func imagePickerPreviewCancel();
}

class ImagePickerPreviewVC: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private var optionSliders: [UISlider]!
    
    var delegate: ImagePickerPreviewDelegate?
    
    private var image: UIImage?
    let imageFilter =  ColorBalanceFilter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateImage()
    }
    
    private func updateImage() {
        imageView.image = imageFilter.imageByFilteringImage(image)
    }
    
    func setImage(image im: UIImage?) {
        image = im
    }

    @IBAction func sliderValueChanged(sender: AnyObject) {
        if let index = optionSliders.indexOf(sender as! UISlider) { 
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
    
    @IBAction func okButtonTouch(sender: AnyObject) {
        dismissViewControllerAnimated(false, completion: nil)
        delegate?.imagePickerPreview?(image, filteredImage: imageView.image)
    }
    
    @IBAction func cancelButtonTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.imagePickerPreviewCancel?()
    }
    
    @IBAction func optionSwitched(sender: AnyObject) {
        imageFilter.option = (sender as! UISwitch).on
        updateImage()
    }
}
