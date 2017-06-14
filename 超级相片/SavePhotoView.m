//
//  SavePhotoView.m
//  超级相片
//
//  Created by 喻佳珞 on 2017/6/12.
//  Copyright © 2017年 喻佳珞. All rights reserved.
//

#import "SavePhotoView.h"

@interface SavePhotoView ()

@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,strong) UIButton *sureBtn;

@end

@implementation SavePhotoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.cancelBtn];
        [self addSubview:self.sureBtn];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    self.cancelBtn.bounds = CGRectMake(0, 0, bounds.size.width/5,  bounds.size.width/5);
    self.sureBtn.bounds = CGRectMake(0, 0, bounds.size.width/5,  bounds.size.width/5);
    
    self.cancelBtn.center = CGPointMake( bounds.size.width/5, bounds.size.height/2);
    self.sureBtn.center = CGPointMake(bounds.size.width/10*8, bounds.size.height/2);
    
}



#pragma -mark 懒加载

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_cancelBtn setImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
        
        [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setImage:[UIImage imageNamed:@"完成"] forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

- (void)cancelClick
{
    if (self.blockBaca) {
        self.blockBaca(NO);
    }
}

- (void)sureClick
{
    if (self.blockBaca) {
        self.blockBaca(YES);
    }
}




@end
