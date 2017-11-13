//
//  AssetViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 24..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class AssetViewController: UIViewController{
    
    
    var scrollView: UIScrollView = UIScrollView()
    var cropView = CropOverlay()
    
    
    var asset:PHAsset!
    var data:Data?
    
    var staticImageView = UIImageView()
    var livePhotoView: PHLivePhotoView = PHLivePhotoView()
    fileprivate var isPlayingHint = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(cropView)
        scrollView.addSubview(staticImageView)
        scrollView.maximumZoomScale = 1
        
        self.view.addSubview(livePhotoView)
        
        let selectBarButton = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(selectAction))
        selectBarButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = selectBarButton
        
        staticImageView.contentMode = .scaleAspectFit
        staticImageView.layer.masksToBounds = true
        
        cropView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(self.view.frame.width)
        }
        
        
        staticImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        livePhotoView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        livePhotoView.delegate = self
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        let scale = calculateMinimumScale(view.frame.size)
//        let frame = allowsCropping ? cropOverlay.frame : view.bounds
//        
//        scrollView.contentInset = calculateScrollViewInsets(frame)
//        scrollView.minimumZoomScale = scale
//        scrollView.zoomScale = scale
        updateImage()
    }
    
    //MARK: - Image display
    
    var targetSize: CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: staticImageView.bounds.width * scale,
                      height: staticImageView.bounds.height * scale)
    }
    
  @objc fileprivate dynamic func selectAction(){
        guard let data = self.data else {return}
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "imageSelected"), object: nil, userInfo: ["image" : data])
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func updateImage() {
        if asset.mediaSubtypes.contains(.photoLive) {
            updateLivePhoto()
        } else {
            updateStaticImage()
        }
    }
    
    func updateLivePhoto() {
        // Prepare the options to pass when fetching the live photo.
        let options = PHLivePhotoRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        // Request the live photo for the asset from the default PHImageManager.
        PHImageManager.default().requestLivePhoto(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { livePhoto, info in
            // Hide the progress view now the request has completed.
            
            // If successful, show the live photo view and display the live photo.
            guard let livePhoto = livePhoto else { return }
            
            // Now that we have the Live Photo, show it.
            self.staticImageView.isHidden = true
            self.livePhotoView.isHidden = false
            self.livePhotoView.livePhoto = livePhoto
            
            if !self.isPlayingHint {
                // Playback a short section of the live photo; similar to the Photos share sheet.
                self.isPlayingHint = true
                self.livePhotoView.startPlayback(with: .hint)
            }
        })
    }
    
    func updateStaticImage() {
        // Prepare the options to pass when fetching the (photo, or video preview) image.
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        PHImageManager.default().requestImageData(for: asset, options: options) { (data, _, _, _) in
        
            // If successful, show the image view and display the image.
            guard let data = data else {return}
            self.data = data
            
            // Now that we have the image, show it.
            self.livePhotoView.isHidden = true
            self.staticImageView.isHidden = false
            self.staticImageView.image = UIImage(data: data)
        }
    }
}

extension AssetViewController: PHPhotoLibraryChangeObserver{
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            guard changeInstance.changeDetails(for: self.asset) != nil else {return}
        }
    }
}

extension AssetViewController: PHLivePhotoViewDelegate{
    func livePhotoView(_ livePhotoView: PHLivePhotoView, willBeginPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        isPlayingHint = (playbackStyle == .hint)
    }
    
    func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        isPlayingHint = (playbackStyle == .hint)
    }
}
