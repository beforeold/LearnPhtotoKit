//
//  Uitls.swift
//  LearnPhotoKit
//
//  Created by Brook_Mobius on 2022/11/4.
//

import Foundation

func measureTime<T>(_ title: String, block: () -> T) -> T {
    let start = CFAbsoluteTimeGetCurrent()
    let ret = block()
    let end = CFAbsoluteTimeGetCurrent()
    print("measure \(title):", "\((end - start) * 1000) ms")
    
    return ret
}
