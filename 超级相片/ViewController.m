//
//  ViewController.m
//  超级相片
//
//  Created by 喻佳珞 on 2017/6/12.
//  Copyright © 2017年 喻佳珞. All rights reserved.
//

#import "ViewController.h"
#import "PhotoViewController.h"



@interface ViewController ()




@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [UIApplication sharedApplication].statusBarHidden = NO;
    
}

- (IBAction)gotoPhoto:(id)sender {
    PhotoViewController *vc = [[PhotoViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
