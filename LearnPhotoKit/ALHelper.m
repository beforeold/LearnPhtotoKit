//
//  ALHelper.m
//  LearnPhotoKit
//
//  Created by Brook_Mobius on 2022/11/4.
//

#import "ALHelper.h"

@import UIKit;
@import AssetsLibrary;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation ALHelper

- (void)alTotalSize {
    NSLog(@"alTotalSize begin");
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    __block long long totalSize = 0;
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group setAssetsFilter:[ALAssetsFilter allAssets]];
        [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
         {
            __auto_type rep = [asset defaultRepresentation];
            totalSize += rep.size;
        }];
        NSLog(@"total size: %lld", totalSize);
    }
                         failureBlock:^(NSError *error) {
        NSLog(@"%@",error.description);
    }];
    NSLog(@"alTotalSize end");
}

- (void)usePhotolibraryimage:(UIImage *)myImage {
    //Do your all UI related and all stuff here
    long long totalImageSize = 0;
    
    NSData *imageData = UIImageJPEGRepresentation(myImage, 0.5);
    
    long long imageSize = imageData.length / 1024;
    totalImageSize = totalImageSize + imageSize;
}

@end

#pragma clang diagnostic pop
