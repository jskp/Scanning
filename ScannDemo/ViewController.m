//
//  ViewController.m
//  ScannDemo
//
//  Created by an on 17/5/18.
//  Copyright © 2017年 hua. All rights reserved.
//

#import "ViewController.h"
#import "ScannViewController.h"
@interface ViewController ()
@property (nonatomic,strong)ScannViewController *scannVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pushToScann:(id)sender {
    
    UINavigationController *NC = [[UINavigationController alloc]initWithRootViewController:self.scannVC];
    [self presentViewController:NC animated:YES completion:^{
        
    }];
    
}

#pragma getter And  setter
-(ScannViewController *)scannVC{
    if (!_scannVC) {
        _scannVC = [[ScannViewController alloc]init];
    }
    
    return _scannVC;
}
@end
