//
//  ScannViewController.m
//  ScannDemo
//
//  Created by an on 17/5/18.
//  Copyright © 2017年 hua. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ScannViewController.h"
#import "ScannView.h"
@interface ScannViewController ()<ScannViewDelegate>

@end

@implementation ScannViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    UIButton *bacnBnt = [UIButton buttonWithType:UIButtonTypeCustom];
    bacnBnt.frame = CGRectMake(0, 0, 40, 40);
    [bacnBnt setTitle:@"返回" forState:UIControlStateNormal];
    [bacnBnt addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [bacnBnt setTintColor:[UIColor blackColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bacnBnt];
    
    ScannView *scannView = [[ScannView alloc]initWithFrame:self.view.bounds];
    scannView.delegate = self;
    [scannView loopDrawLine];
    [self.view addSubview:scannView];
   
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"    你好,消失了......    ");
    }];
   
}
-(void)getScannResult:(NSString *)resule{
    
    SystemSoundID soundID;
    NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
    AudioServicesPlaySystemSound(soundID);
    
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:resule delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
    NSURL *url = [NSURL URLWithString:resule];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

@end
