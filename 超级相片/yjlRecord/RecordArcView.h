//
//  RecordArcView.h
//  pqtelRecord
//
//  Created by Hellen Yang on 2017/6/14.
//  Copyright © 2017年 Hellen Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define MAX_RECORD_DURATION 60.0
#define WAVE_UPDATE_FREQUENCY   0.1
#define SILENCE_VOLUME   45.0
#define SOUND_METER_COUNT  6
#define HUD_SIZE  [UIScreen mainScreen].bounds.size.width

@class RecordArcView;
@protocol RecordArcViewDelegate <NSObject>

- (void)recordArcView:(RecordArcView *)arcView voiceRecorded:(NSString *)recordPath length:(float)recordLength;

@end

@interface RecordArcView : UIView<AVAudioRecorderDelegate>
@property(weak, nonatomic) id<RecordArcViewDelegate> delegate;
@property(copy, nonatomic) NSString *filePath;
- (void)startForFilePath:(NSString *)filePath;
- (void)commitRecording;
+ (NSString *)fullPathAtCache:(NSString *)fileName;

@end
