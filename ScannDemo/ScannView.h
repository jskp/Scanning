//
//  ScannView.h
//  ScannDemo
//
//  Created by an on 17/5/18.
//  Copyright © 2017年 hua. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ScannViewDelegate <NSObject>
-(void)getScannResult:(NSString *)resule;
@end
@interface ScannView : UIView
@property(nonatomic,weak)id<ScannViewDelegate>delegate;


@property (nonatomic,copy)UIImageView * readLineView;
@property (nonatomic,assign)BOOL is_Anmotion;
@property (nonatomic,assign)BOOL is_AnmotionFinished;
- (void)loopDrawLine;//初始化扫描线
-(void)start;
-(void)stop;
@end
