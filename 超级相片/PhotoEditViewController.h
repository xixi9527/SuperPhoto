//
//  PhotoEditViewController.h
//  超级相片
//
//  Created by 喻佳珞 on 2017/6/12.
//  Copyright © 2017年 喻佳珞. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface PhotoEditViewController : UIViewController
@property (nonatomic,strong) NSMutableData *imageData;
@property(nonatomic,assign) CMSampleBufferRef imageDataSampleBuffer;

@end
