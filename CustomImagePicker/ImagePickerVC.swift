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
    @objc optional func imagePicker(pickedImage image: UIImage?, filteredImage: UIImage?)
}

class ImagePickerVC: UIViewController {
    
    @IBOutlet weak fileprivate var collectionView: UICollectionView!
    @IBOutlet weak fileprivate var collectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak fileprivate var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var assets: PHFetchResult<AnyObject>?
    fileprivate var sideSize: CGFloat!
    
    var delegate:ImagePickerDelegate?
    
    class func loadFromStoryboard() -> ImagePickerVC! {
        let _storyboard = UIStoryboard(name: "Picker", bundle: Bundle.main)
        return _storyboard.instantiateViewController(withIdentifier: "ImagePickerVC") as! ImagePickerVC
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sideSize = (collectionView.bounds.width - 16) / 3
        collectionViewLayout.itemSize = CGSize(width: sideSize, height: sideSize)
        collectionViewLayout.minimumLineSpacing = 8
        collectionViewLayout.minimumInteritemSpacing = 8
        
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            reloadAssets()
        } else {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                if status == .authorized {
                    self.reloadAssets()
                } else {
                    self.showNeedAccessMessage()
                }
            })
        }
    }
    
    fileprivate func showNeedAccessMessage() {
        let alert = UIAlertController(title: "Image picker", message: "App need get access to photos", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }))
        
        show(alert, sender: nil)
    }
    
    fileprivate func reloadAssets() {
        activityIndicator.startAnimating()
        assets = nil
        collectionView.reloadData()
        assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil) as! PHFetchResult<AnyObject>
        collectionView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    @IBAction func cancelButtonTouch(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ImagePickerVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (assets != nil) ? assets!.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePickerCell", for: indexPath) 
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        PHImageManager.default().requestImage(for: assets?[indexPath.row] as! PHAsset, targetSize: CGSize(width: sideSize, height: sideSize), contentMode: .aspectFill, options: nil) { (image: UIImage?, info: [AnyHashable: Any]?) -> Void in
            (cell as! ImagePickerCell).image = image
        }
    }
    
}

extension ImagePickerVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _storyboard = storyboard {
            let showPreviewVC = { (image: UIImage!) -> Void in
                let previewVC = _storyboard.instantiateViewController(withIdentifier: "ImagePickerPreviewVC") as! ImagePickerPreviewVC
                previewVC.definesPresentationContext = true
                previewVC.modalPresentationStyle = .overCurrentContext
                previewVC.setImage(image: image)
                previewVC.delegate = self
                self.show(previewVC, sender: nil)
            }
            
            let width = self.view.bounds.width
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            
            PHImageManager.default().requestImage(for: assets?[indexPath.row] as! PHAsset, targetSize: CGSize(width: width, height: 0.75 * width), contentMode: .aspectFill, options: options) { (image: UIImage?, info: [AnyHashable: Any]?) -> Void in
                if let _image = image {
                    showPreviewVC(_image)
                }
            }
        }
    }
    
}

extension ImagePickerVC: ImagePickerPreviewDelegate {
    
    func imagePickerPreview(_ originalImage: UIImage?, filteredImage: UIImage?) {
        self.delegate?.imagePicker?(pickedImage: originalImage, filteredImage: filteredImage)
        self.dismiss(animated: true, completion: nil)
    }
    
}
