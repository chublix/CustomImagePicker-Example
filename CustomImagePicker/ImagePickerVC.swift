//
//  ImagePickerViewController.swift
//  CustomImagePicker
//
//  Created by Andrey Chuprina on 2/2/16.
//  Copyright © 2016 Andrey Chuprina. All rights reserved.
//

import UIKit
import Photos

@objc protocol ImagePickerDelegate {
    optional func imagePicker(pickedImage image: UIImage?, filteredImage: UIImage?)
}

class ImagePickerVC: UIViewController {
    
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var collectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    
    private var assets: PHFetchResult?
    private var sideSize: CGFloat!
    
    var delegate:ImagePickerDelegate?
    
    class func loadFromStoryboard() -> ImagePickerVC! {
        let _storyboard = UIStoryboard(name: "Picker", bundle: NSBundle.mainBundle())
        return _storyboard.instantiateViewControllerWithIdentifier("ImagePickerVC") as! ImagePickerVC
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        sideSize = (collectionView.bounds.width - 16) / 3
        collectionViewLayout.itemSize = CGSizeMake(sideSize, sideSize)
        collectionViewLayout.minimumLineSpacing = 8
        collectionViewLayout.minimumInteritemSpacing = 8
        
        if PHPhotoLibrary.authorizationStatus() == .Authorized {
            reloadAssets()
        } else {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                if status == .Authorized {
                    self.reloadAssets()
                } else {
                    self.showNeedAccessMessage()
                }
            })
        }
    }
    
    private func showNeedAccessMessage() {
        let alert = UIAlertController(title: "Image picker", message: "App need get access to photos", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        
        showViewController(alert, sender: nil)
    }
    
    private func reloadAssets() {
        activityIndicator.startAnimating()
        assets = nil
        collectionView.reloadData()
        assets = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
        collectionView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    @IBAction func cancelButtonTouch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension ImagePickerVC: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (assets != nil) ? assets!.count : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("ImagePickerCell", forIndexPath: indexPath) 
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        PHImageManager.defaultManager().requestImageForAsset(assets?[indexPath.row] as! PHAsset, targetSize: CGSizeMake(sideSize, sideSize), contentMode: .AspectFill, options: nil) { (image: UIImage?, info: [NSObject : AnyObject]?) -> Void in
            (cell as! ImagePickerCell).image = image
        }
    }
    
}

extension ImagePickerVC: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let _storyboard = storyboard {
            let showPreviewVC = { (image: UIImage!) -> Void in
                let previewVC = _storyboard.instantiateViewControllerWithIdentifier("ImagePickerPreviewVC") as! ImagePickerPreviewVC
                previewVC.definesPresentationContext = true
                previewVC.modalPresentationStyle = .OverCurrentContext
                previewVC.setImage(image: image)
                previewVC.delegate = self
                self.showViewController(previewVC, sender: nil)
            }
            
            let width = self.view.bounds.width
            let options = PHImageRequestOptions()
            options.deliveryMode = .HighQualityFormat
            options.resizeMode = .Exact
            
            PHImageManager.defaultManager().requestImageForAsset(assets?[indexPath.row] as! PHAsset, targetSize: CGSizeMake(width, 0.75 * width), contentMode: .AspectFill, options: options) { (image: UIImage?, info: [NSObject : AnyObject]?) -> Void in
                if let _image = image {
                    showPreviewVC(_image)
                }
            }
        }
    }
    
}

extension ImagePickerVC: ImagePickerPreviewDelegate {
    
    func imagePickerPreview(originalImage: UIImage?, filteredImage: UIImage?) {
        self.delegate?.imagePicker?(pickedImage: originalImage, filteredImage: filteredImage)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
