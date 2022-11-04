//
//  PHPickerDemo.swift
//  LearnPhotoKit
//
//  Created by Brook_Mobius on 2022/11/4.
//

import Foundation
import Photos
import PhotosUI

struct PHPickerDemo {
   
    static func show(from vc: UIViewController) {
        let config = PHPickerConfiguration(photoLibrary: .shared())
        let picker = PHPickerViewController(configuration: config)
        let delegate = SaveSelfDelegate()
        picker.delegate = delegate
        
        vc.present(picker, animated: true)
    }
}

extension PHPickerDemo {
    class SaveSelfDelegate: NSObject {
        private var saveSelf: SaveSelfDelegate?
        
        func leave() {
            saveSelf = nil
        }
        
        override init() {
            super.init()
            saveSelf = self
        }
    }
}

extension PHPickerDemo.SaveSelfDelegate: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        
        // 这里尝试在用户授权的情况下，通过 PHPicker 的 assetIdentifier 来获取 PHAsset 看起来是行不通的
        let idList = results.compactMap(\.assetIdentifier)
        print("fetched idList:", idList)
        
        let assetList = PHAsset.fetchAssets(withLocalIdentifiers: idList, options: nil)
        print("fetched PHAsset count:", assetList.count)
    }
}
