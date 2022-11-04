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
        
        // testAuth()
        // testLoadingAlbums()
        
        // testGetFileSizeWithAssetResource()
        
        // getFileSizeWithFolder()
        
        // testFileSizeAL()
                
         DeviceInfo.test()
        
        let disk = DiskHelper().getFreeDiskspace()
        print("diskhelper free:", Int64(disk).fileSizeFormatted)
    }
    
    // MARK: - event
    @IBAction func onShowPicker(_ sender: Any) {
        PHPickerDemo.show(from: self)
    }
    
    // MARK: - private
    func testAuth() {
        PHPhotoLibrary.requestAuthorization { status in
            print("status:", status.rawValue)
        }
    }
    
    func testLoadingAlbums() {
        testAllPhotos()
        
        testAssetCollection_album()
        
        testAssetCollection_smartAlbum()
        
        testAssetCollection_smartAlbum_smartAlbumUserLibrary()
    }
    
    @discardableResult
    func testAllPhotos() -> PHFetchResult<PHAsset> {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
//        options.includeHiddenAssets = true
        
        let all = PHAsset.fetchAssets(with: options)
        print("all", all.count, "\n", all)
        
        return all
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
    
    func testGetFileSizeWithAssetResource() {
        let result = measureTime("fetch all") {
             testAllPhotos()
        }
        
        measureTime("calculate file size") {
            var totalSize = 0 as Int64
            result.enumerateObjects { item, _, _ in
                let resources = PHAssetResource.assetResources(for: item)
                let thisFileSize = resources.reduce(0) { (partialResult, resource) -> CLong in
                    let fileSize = resource.value(forKey: "fileSize") as? CLong
                    
                    return partialResult + (fileSize ?? 0)
                }
                print("this file size:", convertByteToHumanReadable(Int64(thisFileSize)))
                
                totalSize += Int64(thisFileSize)
            }
            print("total file size:", convertByteToHumanReadable(totalSize))
        }
    }
    
    // 无法获取到具体的文件大小
    func getFileSizeWithFolder() {
        let all = testAllPhotos()
        let firstAsset = all.object(at: 0)
        let options = PHContentEditingInputRequestOptions()
        options.isNetworkAccessAllowed = true
        _ = firstAsset.requestContentEditingInput(with: options) { input, info in
            print("full size image url:", input?.fullSizeImageURL as Any)
            let path = "/var/mobile/Media/PhotoData/CPLAssets/group409/1FFC973D-1A31-42B6-A9EA-18E961986BE6.JPG"
            // let fileURL = URL(fileURLWithPath: path)
            do {
                let info = try FileManager.default.attributesOfItem(atPath: path)
                print("read CPLAssets", info)
            } catch {
                print("read CPLAssets", error)
            }
        }
    }
    
    func testFileSizeAL() {
        measureTime("al total size") {
            let helper = ALHelper()
            helper.alTotalSize()
        }
    }
}

func convertByteToHumanReadable(_ bytes: Int64) -> String {
     let formatter:ByteCountFormatter = ByteCountFormatter()
     formatter.countStyle = .binary

    return formatter.string(fromByteCount: bytes)
 }
