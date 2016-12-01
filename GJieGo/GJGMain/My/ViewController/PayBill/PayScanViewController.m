//
//  PayScanViewController.m
//  PRJ_Shopping
//
//  Created by dujinxin on 16/4/26.
//  Copyright © 2016年 GuangJiegou. All rights reserved.
//

#import "PayScanViewController.h"
#import "PayImportViewController.h"

static CGFloat length = 260;

@interface PayScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIAlertViewDelegate>{
    AVCaptureSession * session;
}

@end

@implementation PayScanViewController

#pragma mark - viewController life circle function
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        NSLog(@"authStatus = %@",@(authStatus));
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您的相机功能未开启，请去(设置>隐私>相机)开启一下吧！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    NSError * error;
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        NSLog(@"error:%@",error.localizedDescription);
        return;
    }
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    if (!output) {
        NSLog(@"error:%@",error.localizedDescription);
        return;
    }
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    CGFloat x = (kScreenWidth -length*kPercent)/2;
    CGFloat y = (kScreenHeight -kNavStatusHeight-length*kPercent)/2 +kNavStatusHeight;
    CGFloat width = length*kPercent;
    CGFloat height = length*kPercent;
    
    [self addBackView];
    
    //output.rectOfInterest = CGRectMake(y,x,width,width);
    output.rectOfInterest = [self getScanCrop:CGRectMake(x, y, width, height) readerViewBounds:self.view.frame];
    
//    AVCaptureSession * session;//输入输出的中间桥梁
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [session addInput:input];
    [session addOutput:output];
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [session startRunning];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
- (void)loadView{
    [super loadView];
    //self.navigationItem.rightBarButtonItem = [self getNavigationItem:self selector:@selector(test) title:@"保存" style:kDefault];
    
}
- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds {
    
    CGFloat x,y,width,height;
    
    x = rect.origin.y/(kScreenHeight -kNavStatusHeight) - 0.1;
    y = rect.origin.x/kScreenWidth;
    width = rect.size.height/(kScreenHeight -kNavStatusHeight);
    height = rect.size.width/kScreenWidth;
    
    return CGRectMake(x, y, width, height);
    
}
- (void)addBackView{
    UIView * topView = [UIView new];
    topView.backgroundColor = [UIColor blackColor];
    topView.alpha = 0.2f;
    [self.view addSubview:topView];
    
    UIView * leftView = [UIView new];
    leftView.backgroundColor = [UIColor blackColor];
    leftView.alpha = 0.2f;
    [self.view addSubview:leftView];
    
    UIView * rightView = [UIView new];
    rightView.backgroundColor = [UIColor blackColor];
    rightView.alpha = 0.2f;
    [self.view addSubview:rightView];
    
    UIView * bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.2f;
    [self.view addSubview:bottomView];
    
    UIImageView * centerView = [UIImageView new];
    centerView.backgroundColor = [UIColor clearColor];
    centerView.image = [JXImageNamed(@"angle") stretchableImageWithLeftCapWidth:30 topCapHeight:30];
    [self.view addSubview:centerView];
    
    
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(kNavStatusHeight);
        make.height.equalTo((kScreenHeight -kNavStatusHeight -length)/2);
    }];
    [bottomView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.equalTo(self.view);
        make.height.equalTo((kScreenHeight -kNavStatusHeight  -length)/2);
    }];
    [leftView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.bottom);
        make.left.equalTo(self.view);
        make.width.equalTo((kScreenWidth -length)/2);
        make.bottom.equalTo(bottomView.top);
    }];
    [rightView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.bottom);
        make.right.equalTo(self.view);
        make.width.equalTo((kScreenWidth -length)/2);
        make.bottom.equalTo(bottomView.top);
    }];
    [centerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.bottom);
        make.right.equalTo(rightView.left);
        make.left.equalTo(leftView.right);
        make.bottom.equalTo(bottomView.top);
    }];
    
}
#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        NSLog(@"metadataObjects = %@",metadataObject);
        if (self.backBlock) {
            self.backBlock(metadataObject.stringValue);
        }
        [session stopRunning];
        [self.navigationController popViewControllerAnimated:YES];
        
//        PayImportViewController * pvc = [[PayImportViewController alloc ] init];
//        [self.navigationController pushViewController:pvc animated:YES];
    }
}
#pragma mark - Click events
- (void)test{
    PayImportViewController * pvc = [[PayImportViewController alloc ] init];
    [self.navigationController pushViewController:pvc animated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:@"prefs:root=com.guangjiegou.GJieGo"];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
