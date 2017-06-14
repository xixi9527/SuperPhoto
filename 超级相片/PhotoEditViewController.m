//
//  PhotoEditViewController.m
//  超级相片
//
//  Created by 喻佳珞 on 2017/6/12.
//  Copyright © 2017年 喻佳珞. All rights reserved.
//

#import "PhotoEditViewController.h"
#import "SavePhotoView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UITextView+PlaceHolder.h"
#import "RecordArcView.h"

@interface PhotoEditViewController ()<RecordArcViewDelegate>
@property (nonatomic,strong) UIImageView *photoImgView;
@property (nonatomic,strong) SavePhotoView *saveView;
@property (nonatomic,strong) UIButton *editBtn;
@property (nonatomic,strong) UIButton *speakBtn;
@property (nonatomic,strong) UIButton *shareBtn;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIButton *OKBtn;
@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,strong) RecordArcView *recordView;

@end

@implementation PhotoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)setUI
{
    //设置显示图片
    
    [self.view addSubview:self.photoImgView];
    
    //
    [self.view addSubview:self.saveView];
    //保存回调
    __weak PhotoEditViewController *weakSelf = self;
    [self.saveView setBlockBaca:^(bool save){
        __strong PhotoEditViewController *strongSelf = weakSelf;
        if (save) {
            //保存
        } else {
            //取消
            [strongSelf dismissViewControllerAnimated:NO completion:nil];
        }
    }];
    
    
    [self.view addSubview:self.editBtn];
    [self.view addSubview:self.speakBtn];
    [self.view addSubview:self.shareBtn];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.OKBtn];
    
    //录音控件
    [self.view addSubview:self.recordView];
    self.recordView.hidden = YES;
    
}


#pragma -mark RecordArcViewDelegate
- (void)recordArcView:(RecordArcView *)arcView voiceRecorded:(NSString *)recordPath length:(float)recordLength
{
    NSLog(@"%@",recordPath);
}

#pragma mark -按钮事件响应
- (void)editClick
{
    self.textView.hidden = !self.textView.hidden;
    self.cancelBtn.hidden = !self.cancelBtn.hidden;
    self.OKBtn.hidden = !self.OKBtn.hidden;
    [self.textView endEditing:YES];
}

- (void)talkClick
{
    self.recordView.hidden = !self.recordView.hidden;
    self.saveView.hidden = !self.saveView.hidden;
}

#pragma -mark 懒加载

- (RecordArcView *)recordView
{
    if (!_recordView) {
        _recordView = [[RecordArcView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-40, [UIScreen mainScreen].bounds.size.width, 40)];
        _recordView.delegate = self;
        self.recordView.filePath = [RecordArcView fullPathAtCache:@"record.wav"];
    }
    return _recordView;
}



- (UIButton *)editBtn
{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
        _editBtn.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/13, [UIScreen mainScreen].bounds.size.width/13);
        _editBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/13+[UIScreen mainScreen].bounds.size.width/2 , 20+[UIScreen mainScreen].bounds.size.width/13/2);
        [_editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}


- (UIButton *)speakBtn
{
    if (!_speakBtn) {
        _speakBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_speakBtn setImage:[UIImage imageNamed:@"麦克风"] forState:UIControlStateNormal];
        _speakBtn.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/13, [UIScreen mainScreen].bounds.size.width/13);
        _speakBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/13*3+[UIScreen mainScreen].bounds.size.width/2 , 20+[UIScreen mainScreen].bounds.size.width/13/2);
        [_speakBtn addTarget:self action:@selector(talkClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _speakBtn;
}

- (UIButton *)shareBtn
{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
        _shareBtn.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/13, [UIScreen mainScreen].bounds.size.width/13);
        _shareBtn.center = CGPointMake([UIScreen mainScreen].bounds.size.width/13*5+[UIScreen mainScreen].bounds.size.width/2 , 20+[UIScreen mainScreen].bounds.size.width/13/2);
    }
    return _shareBtn;
}


- (SavePhotoView *)saveView
{
    if (!_saveView) {
        _saveView = [[SavePhotoView alloc] init];
        _saveView.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/4);
        _saveView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/8*7);
    }
    return _saveView;
}

- (UIImageView *)photoImgView
{
    if (!_photoImgView) {
        _photoImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _photoImgView.image = [UIImage imageWithData:self.imageData];
    }
    return _photoImgView;
}

- (UIButton *)OKBtn
{
    if (!_OKBtn) {
        _OKBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_OKBtn setTitle:@"ok" forState:UIControlStateNormal];
        [_OKBtn addTarget:self action:@selector(OKClick) forControlEvents:UIControlEventTouchUpInside];
        _OKBtn.backgroundColor = [UIColor greenColor];
        _OKBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height-30, [UIScreen mainScreen].bounds.size.width/2, 30);
        _OKBtn.hidden = YES;
    }
    return _OKBtn;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"cancel" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-30, [UIScreen mainScreen].bounds.size.width/2, 30);
        _cancelBtn.backgroundColor = [UIColor redColor];
        _cancelBtn.hidden = YES;
    }
    return _cancelBtn;
}

- (UITextView *)textView
{
    if (!_textView) {
        
        _textView = [[UITextView alloc] init];
        _textView.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height/4-20);
        _textView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/8*7-15);
        _textView.hidden = YES;
        //键盘弹起落下通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
        
        //添加单击取消键盘的方法
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapgr)];
        [self.view addGestureRecognizer:tap];
        _textView.placeholder = @"说点什么吧!";
        
    
    }
    return _textView;
}




- (void)OKClick
{
    NSString *str = self.textView.text;
    [self.imageData appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    UIImage* image = [UIImage imageWithData:self.imageData];
    
    UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
}

- (void)cancelClick
{
    NSString *str = self.textView.text;
    [self.imageData appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    UIImage* image = [UIImage imageWithData:self.imageData];
    
    UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
    
}

- (void)tapgr
{
    [self.textView endEditing:YES];
}

- (void)keyboardWillAppear:(NSNotification *)notif
{
    CGFloat change = [self keyboardEndingFrameHeight:notif.userInfo];
    self.textView.center = CGPointMake(self.textView.center.x, [UIScreen mainScreen].bounds.size.height/8*7-15-change);
    self.cancelBtn.center = CGPointMake(self.cancelBtn.center.x, [UIScreen mainScreen].bounds.size.height-15-change);
    self.OKBtn.center = CGPointMake(self.OKBtn.center.x, [UIScreen mainScreen].bounds.size.height-15-change);
}
- (void)keyboardWillDisappear:(NSNotification *)notif
{
    CGRect currentFrame = self.view.frame;
    CGFloat change = [self keyboardEndingFrameHeight:[notif userInfo]];
    currentFrame.origin.y = currentFrame.origin.y + change ;
    self.textView.center = CGPointMake(self.textView.center.x, self.textView.center.y+30+change);
    self.cancelBtn.center = CGPointMake(self.cancelBtn.center.x, self.cancelBtn.center.y+change);
    self.OKBtn.center = CGPointMake(self.OKBtn.center.x, self.OKBtn.center.y+change);

}

-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo//计算键盘的高度
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableData *)imageData
{
    if (!_imageData) {
        _imageData = [[NSMutableData alloc] init];
    }
    return _imageData;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
