//
//  ScannView.m
//  ScannDemo
//
//  Created by an on 17/5/18.
//  Copyright © 2017年 hua. All rights reserved.
//

#import "ScannView.h"
#import <AVFoundation/AVFoundation.h>
@interface ScannView()<AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession * _session;
    NSTimer * _timer;
}
@property(nonatomic,strong) CAShapeLayer *myLayer;
@end
@implementation ScannView
#define DeviceMaxHeight  ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth   ([UIScreen mainScreen].bounds.size.width)

#define widthRate         DeviceMaxWidth/320.0


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self instanceDevice];
        
    }
    return self;
}
-(void)instanceDevice{
    
    //扫描区域  , 其实这个扫描区域专门是给用户提供的一个标识,有没有都可以把二维码读取出来,
    UIImage *scannImage = [UIImage imageNamed:@"scanscanBg"];
    UIImageView *scannImageView = [[UIImageView alloc]init];
    scannImageView.backgroundColor = [UIColor clearColor];
    scannImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    scannImageView.layer.borderWidth = 2.4;
    scannImageView.image = scannImage;
    CGRect imageRect = CGRectMake(60*widthRate, (DeviceMaxHeight - 200*widthRate)/2, 200*widthRate, 200*widthRate);
    scannImageView.frame = imageRect;
    [self addSubview:scannImageView];
    
    
    
    // 获取视频设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 创建输入流
    AVCaptureDeviceInput * inputDevice = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 设置代理并在主线程刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    // 高质量采集
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    if (inputDevice) {
        [_session addInput:inputDevice];
    }
    if (output) {
        [_session addOutput:output];
        NSMutableArray *a  = [NSMutableArray array];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]){
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes = a;
    }
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.layer.bounds;
    layer.backgroundColor = [UIColor orangeColor].CGColor;
    [self.layer insertSublayer:layer atIndex:0];
    
    // 为了给扫描区域之外的 view 添加背景放射
    [self setOverlayPickerView];
    // 开始读取
    [_session startRunning];
}
#pragma mark - 扫描结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects && metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        if (_delegate && [_delegate respondsToSelector:@selector(getScannResult:)]) {
            [self stop];
            [_delegate getScannResult:metadataObject.stringValue];
        }
    }
}
-(void)start{
    [_session startRunning];
    
}
-(void)stop{
    [_session stopRunning];
    _is_Anmotion = YES;
    _readLineView.hidden = YES;
}
-(void)loopDrawLine
{
    _is_AnmotionFinished = NO;
    CGRect rect = CGRectMake(60*widthRate, (DeviceMaxHeight-200*widthRate)/2, 200*widthRate, 2);
    if (_readLineView) {
        _readLineView.alpha = 1;
        _readLineView.frame = rect;
        _readLineView.hidden = NO;
    }
    else{
        _readLineView = [[UIImageView alloc] initWithFrame:rect];
        [_readLineView setImage:[UIImage imageNamed:@"scanLine"]];
        [self addSubview:_readLineView];
    }
    
    [UIView animateWithDuration:1.5 animations:^{
        //修改fream的代码写在这里
        _readLineView.frame =CGRectMake(60*widthRate, (DeviceMaxHeight-200*widthRate)/2+200*widthRate-5, 200*widthRate, 2);
    } completion:^(BOOL finished) {
        if (!_is_Anmotion) {
            [self loopDrawLine];
        }
        _is_AnmotionFinished = YES;
    }];
}
-(void)setOverlayPickerView{
    
    CGFloat wid = 60*widthRate;
    CGFloat heih = (DeviceMaxHeight-200*widthRate)/2;
    
    //最上部view
    CGFloat alpha = 0.5;
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, heih)];
    upView.alpha = alpha;
    upView.backgroundColor = [UIColor grayColor];
    [self addSubview:upView];
    
    //左侧的view
    UIView * cLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, heih, wid, 200*widthRate)];
    cLeftView.alpha = alpha;
    cLeftView.backgroundColor = [UIColor grayColor];
    [self addSubview:cLeftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(DeviceMaxWidth-wid, heih, wid, 200*widthRate)];
    rightView.alpha = alpha;
    rightView.backgroundColor = [UIColor grayColor];
    [self addSubview:rightView];
    
    //底部view
    UIView * downView = [[UIView alloc] initWithFrame:CGRectMake(0, heih+200*widthRate, DeviceMaxWidth, DeviceMaxHeight - heih-200*widthRate)];
    downView.alpha = alpha;
    downView.backgroundColor = [UIColor grayColor];
    [self addSubview:downView];
    
    //开关灯button
    UIButton * turnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    turnBtn.backgroundColor = [UIColor clearColor];
    [turnBtn setBackgroundImage:[UIImage imageNamed:@"lightSelect"] forState:UIControlStateNormal];
    [turnBtn setBackgroundImage:[UIImage imageNamed:@"lightNormal"] forState:UIControlStateSelected];
    turnBtn.frame=CGRectMake((DeviceMaxWidth-50*widthRate)/2, (CGRectGetHeight(downView.frame)-50*widthRate)/2, 50*widthRate, 50*widthRate);
    [turnBtn addTarget:self action:@selector(turnBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:turnBtn];
    
    
}
- (void)turnBtnEvent:(UIButton *)bnt{
    bnt.selected = !bnt.selected;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash]){
        [device lockForConfiguration:nil];
        if (bnt.selected) {
            [device setTorchMode:AVCaptureTorchModeOn];
            [device setFlashMode:AVCaptureFlashModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
            [device setFlashMode:AVCaptureFlashModeOff];
        }
        [device unlockForConfiguration];
    }
}
















@end
