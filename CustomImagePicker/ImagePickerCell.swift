//
//  ImagePickerCell.swift
//  CustomImagePicker
//
//  Created by Andrey Chuprina on 2/3/16.
//  Copyright © 2016 Andrey Chuprina. All rights reserved.
//

import UIKit

class ImagePickerCell: UICollectionViewCell {

    @IBOutlet weak private var imageView: UIImageView!
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
        }
    }
    
}
