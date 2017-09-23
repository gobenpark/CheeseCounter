//
//  PhotoViewController.swift
//  CheeseCounter
//
//  Created by xiilab on 2017. 4. 24..
//  Copyright © 2017년 xiilab. All rights reserved.
//

import UIKit
import Photos
import PhotosUI


private extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}

class PhotoViewController: UIViewController{
    
    var fetchResult: PHFetchResult<PHAsset>!
    let photoLibrary = PHPhotoLibrary.shared()
    var assetCollection: PHAssetCollection!
    let imageManager = PHCachingImageManager()
    var previousPreheatRect:CGRect = .zero
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: PhotoViewCell.ID)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = collectionView
        self.view.backgroundColor = .white
        
        if fetchResult == nil {
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
        }
        
        photoLibrary.register(self)
    }
    
    deinit {
        photoLibrary.unregisterChangeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCachedAssets()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Determine the size of the thumbnails to request from the PHCachingImageManager
        //        let scale = UIScreen.main.scale
        //        let cellSize = (UICollectionViewFlowLayout).itemSize
        //        thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
        //
        //        // Add button to the navigation bar if the asset collection supports adding content.
        //        if assetCollection == nil || assetCollection.canPerform(.addContent) {
        //            navigationItem.rightBarButtonItem = addButtonItem
        //        } else {
        //            navigationItem.rightBarButtonItem = nil
        //        }
    }
    
    
    
    func resetCachedAssets(){
        imageManager.stopCachingImagesForAllAssets()
    }
    
    
    fileprivate func updateCachedAssets() {
        // Update only if the view is visible.
        guard isViewLoaded && view.window != nil else { return }
        
        //현재 뷰의 두배를 미리 준비해둠. (preheatRect)
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        print("visibleRect",visibleRect)
        let preheatRect = visibleRect.insetBy(dx: 0, dy: -0.5 * visibleRect.height)
        print("preheatRect" , preheatRect)
        
        // Update only if the visible area is significantly different from the last preheated area.
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        print("delta:" , delta)
        guard delta > view.bounds.height / 3 else { return }
        
        // Compute the assets to start caching and to stop caching.
        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
        let addedAssets = addedRects
            .flatMap { rect in collectionView.indexPathsForElements(in: rect) }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        let removedAssets = removedRects
            .flatMap { rect in collectionView.indexPathsForElements(in: rect) }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        
        // Update the assets the PHCachingImageManager is caching.
        imageManager.startCachingImages(for: addedAssets,
                                        targetSize: CGSize(width: collectionView.frame.width/4, height: collectionView.frame.width/4), contentMode: .aspectFill, options: nil)
        imageManager.stopCachingImages(for: removedAssets,
                                       targetSize: CGSize(width: collectionView.frame.width/4, height: collectionView.frame.width/4), contentMode: .aspectFill, options: nil)
        
        // Store the preheat rect to compare against in the future.
        previousPreheatRect = preheatRect
    }
    
    fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY,
                                 width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                 width: new.width, height: old.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                   width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY,
                                   width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }
}

extension PhotoViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let assetViewController = AssetViewController()
        assetViewController.asset = fetchResult.object(at: indexPath.item)
        self.navigationController?.pushViewController(assetViewController, animated: true)
    }
}

extension PhotoViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let asset = fetchResult.object(at: indexPath.item)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoViewCell.ID
            , for: indexPath) as? PhotoViewCell else { fatalError("unexpected cell in collection view") }
        if asset.mediaSubtypes.contains(.photoLive){
            cell.livePhotoBadgeImageView.image = PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
        }
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: CGSize(width: collectionView.frame.width/4, height: collectionView.frame.width/4), contentMode: .aspectFill, options: nil) { (image, _) in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.imageView.image = image
            }
        }
        
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4, height: collectionView.frame.width/4)
    }
}

extension PhotoViewController: PHPhotoLibraryChangeObserver{
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        
        guard let changes = changeInstance.changeDetails(for: fetchResult)
            else { return }
        
        // Change notifications may be made on a background queue. Re-dispatch to the
        // main queue before acting on the change as we'll be updating the UI.
        DispatchQueue.main.sync {
            // Hang on to the new fetch result.
            fetchResult = changes.fetchResultAfterChanges
            if changes.hasIncrementalChanges {
                // If we have incremental diffs, animate them in the collection view.
                collectionView.performBatchUpdates({
                    // For indexes to make sense, updates must be in this order:
                    // delete, insert, reload, move
                    if let removed = changes.removedIndexes, removed.count > 0 {
                        self.collectionView.deleteItems(at: removed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let inserted = changes.insertedIndexes, inserted.count > 0 {
                        self.collectionView.insertItems(at: inserted.map({ IndexPath(item: $0, section: 0) }))
                    }
                    if let changed = changes.changedIndexes, changed.count > 0 {
                        self.collectionView.reloadItems(at: changed.map({ IndexPath(item: $0, section: 0) }))
                    }
                    changes.enumerateMoves { fromIndex, toIndex in
                        self.collectionView.moveItem(at: IndexPath(item: fromIndex, section: 0),
                                                     to: IndexPath(item: toIndex, section: 0))
                    }
                })
            } else {
                // Reload the collection view if incremental diffs are not available.
                collectionView.reloadData()
            }
            resetCachedAssets()
        }
        
    }
}


class PhotoViewCell: UICollectionViewCell{
    
    static let ID = "PhotoViewCell"
    
    var livePhotoBadgeImageView: UIImageView = UIImageView()
    var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var representedAssetIdentifier: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        self.addSubview(livePhotoBadgeImageView)
        self.layer.borderWidth = 0.5
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        livePhotoBadgeImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3)
            make.width.equalToSuperview().dividedBy(3)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
