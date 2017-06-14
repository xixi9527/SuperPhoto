//
//  RecordArcView.m
//  pqtelRecord
//
//  Created by Hellen Yang on 2017/6/14.
//  Copyright © 2017年 Hellen Yang. All rights reserved.
//

#import "RecordArcView.h"

@interface RecordArcView (){
    int soundMeters[SOUND_METER_COUNT];
}

@property(readwrite, nonatomic, strong) NSDictionary *recordSettings;
@property(readwrite, nonatomic, strong) AVAudioRecorder *recorder;
@property(readwrite, nonatomic, strong) NSString *recordPath;
@property(readwrite, nonatomic, strong) NSTimer *timer;
@property(readwrite, nonatomic, assign) CGFloat recordTime;
@property(readwrite, nonatomic, assign) CGRect hudRect;





//说话按钮
@property(readwrite, nonatomic, strong) UIImageView *recordBtn;


@property(nonatomic, strong) AVAudioPlayer *player;
@property(readwrite, nonatomic, strong) UILabel *showLabel;
@property(readwrite, nonatomic, copy) NSString* addNSString;


//
@property(nonatomic,assign) BOOL isSend;



@end

@implementation RecordArcView




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.recordSettings = @{AVFormatIDKey : @(kAudioFormatLinearPCM), AVEncoderBitRateKey:@(16),AVEncoderAudioQualityKey : @(AVAudioQualityMax), AVSampleRateKey : @(8000.0), AVNumberOfChannelsKey : @(1)};
        for(int i=0; i<SOUND_METER_COUNT; i++) {
            soundMeters[i] = SILENCE_VOLUME;
        }
        
        self.backgroundColor = [UIColor clearColor];
       
        
        self.hudRect = CGRectMake(self.center.x - (HUD_SIZE / 2), self.center.y - (HUD_SIZE / 2), HUD_SIZE, 10);
        self.backgroundColor = [UIColor whiteColor];
        
        self.recordBtn = [[UIImageView alloc] init];;
        self.recordBtn.image = [UIImage imageNamed:@"语音"];
        self.recordBtn.userInteractionEnabled = YES;
        
        [self addSubview:self.recordBtn];
        
        
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recordGes:)];
        longGes.minimumPressDuration = 0;
        [self.recordBtn addGestureRecognizer:longGes];
        
        
        self.showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2-15, [UIScreen mainScreen].bounds.size.width, 30)];
        self.showLabel.backgroundColor = [UIColor greenColor];
        self.showLabel.textAlignment = NSTextAlignmentCenter;
        self.showLabel.text = @"0s";

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.recordBtn.frame = self.bounds;
}

//音量 以及秒数刷新
- (void)updateMeters{
    [self.recorder updateMeters];
    if (self.recordTime > 60.0) {
        return;
    }
    self.recordTime += WAVE_UPDATE_FREQUENCY;
    
    [self.showLabel setText:[NSString stringWithFormat:@"%@---%.0fs",self.addNSString,self.recordTime]];
    
    NSLog(@"volume:%f",[self.recorder averagePowerForChannel:0]);
}


- (void)recordGes:(UIGestureRecognizer *)ges
{
    CGPoint point = [ges locationInView:self];
    switch (ges.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.recordBtn.image = [UIImage imageNamed:@"语音2"];
           [self startForFilePath:self.filePath];
            [[UIApplication sharedApplication].keyWindow addSubview:self.showLabel];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (point.y >= -30) {
                self.addNSString = @"上滑取消";
                self.showLabel.backgroundColor = [UIColor greenColor];
            } else {
                self.addNSString = @"松开手指,取消发送";
                self.showLabel.backgroundColor = [UIColor redColor];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (point.y >= 0) {
                NSLog(@"发送语音");
                self.isSend = YES;
            } else {
                self.isSend = NO;
                NSLog(@"取消语音");
            }
            self.recordBtn.image = [UIImage imageNamed:@"语音"];
            [self commitRecording];
            
            [self.showLabel removeFromSuperview];
        }
            break;
            
        default:
            break;
    }
}

//播放录音
- (void)play
{
    //初始化播放器的时候如下设置
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.filePath] error:nil];//amr
    [self.player play];
}


//开始录音到xx目录
- (void)startForFilePath:(NSString *)filePath{
    NSLog(@"file path:%@",filePath);
    if (self.recorder.isRecording) {
        return;
    }
    
    
    
    self.recordTime = 0.0;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    self.recordPath = filePath;
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSDate *existedData = [NSData dataWithContentsOfFile:[url path] options:NSDataReadingMapped error:&err];
    if (existedData) {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[url path] error:&err];
    }
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:self.recordSettings error:&err];
    [self.recorder setDelegate:self];
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    
    [self.recorder recordForDuration:MAX_RECORD_DURATION];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
}

- (void)commitRecording{
    [self.recorder stop];
}





- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error{
    NSLog(@"error : %@",error);
}


- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    [self.timer invalidate];
    if (self.isSend) {
        if ([self.delegate respondsToSelector:@selector(recordArcView:voiceRecorded:length:)]) {
            [self.delegate recordArcView:self voiceRecorded:self.recordPath length:self.recordTime];
        }
    }
    [self setNeedsDisplay];
}


+ (NSString *)fullPathAtCache:(NSString *)fileName{
    NSError *error;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (YES != [fm fileExistsAtPath:path]) {
        if (YES != [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"create dir path=%@, error=%@", path, error);
        }
    }
    return [path stringByAppendingPathComponent:fileName];
}

- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    self.recorder.delegate = nil;
}

@end
