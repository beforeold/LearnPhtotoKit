//
//  ViewController.swift
//  LearnPhotoKit
//
//  Created by Brook_Mobius on 2022/11/3.
//

import UIKit
import Photos

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        testAllPhotos()
        
        testAssetCollection_album()
        
        testAssetCollection_smartAlbum()
        
        testAssetCollection_smartAlbum_smartAlbumUserLibrary()
    }
    
    func testAllPhotos() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
//        options.includeHiddenAssets = true
        
        let all = PHAsset.fetchAssets(with: options)
        print("all", all.count, "\n", all)
    }
    
    func testAssetCollection_smartAlbum_smartAlbumUserLibrary() {
        let options = PHFetchOptions()
        options.includeHiddenAssets = true
        let assetCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                  subtype: .smartAlbumUserLibrary,
                                                                  options: options)
        print(assetCollections)
        
        assetCollections.enumerateObjects { collection, index, _ in
            print(collection.estimatedAssetCount, collection.localizedTitle ?? "null title")
        }
    }
    
    func testAssetCollection_smartAlbum() {
        let options = PHFetchOptions()
        options.includeHiddenAssets = true
        let assetCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                                  subtype: .albumRegular,
                                                                  options: options)
        print(assetCollections)
        
        assetCollections.enumerateObjects { collection, index, _ in
            let options = PHFetchOptions()
            options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            let assets = PHAsset.fetchAssets(in: collection, options: options)
            print(collection.estimatedAssetCount, collection.localizedTitle ?? "null title", assets.count)
            if collection.localizedTitle == "Recents" {
                print("recents:")
            }
        }
    }
    
    func testAssetCollection_album() {
        let options = PHFetchOptions()
        options.includeHiddenAssets = true
        let assetCollections = PHAssetCollection.fetchAssetCollections(with: .album,
                                                                  subtype: .albumRegular,
                                                                  options: options)
        print(assetCollections)
        
        assetCollections.enumerateObjects { collection, index, _ in
            print(collection.estimatedAssetCount, collection.localizedTitle ?? "null title")
        }
    }
}

