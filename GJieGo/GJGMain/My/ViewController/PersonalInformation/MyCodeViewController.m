//
//  MyCodeViewController.m
//  GJieGo
//
//  Created by dujinxin on 16/11/23.
//  Copyright © 2016年 yangzx. All rights reserved.
//

#import "MyCodeViewController.h"

@interface MyCodeViewController (){
    UIView      * _contentView;
    UILabel     * _codeLabel;
    UIImageView * _codeImage;
    UILabel     * _infoLabel;
    UIButton    * _saveButton;
}

@property (nonatomic, strong)UIView      * contentView;
@property (nonatomic, strong)UILabel     * codeLabel;
@property (nonatomic, strong)UIImageView * codeImage;
@property (nonatomic, strong)UILabel     * infoLabel;
@property (nonatomic, strong)UIButton    * saveButton;
@end

@implementation MyCodeViewController

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
    
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.codeLabel];
    [self.view addSubview:self.codeImage];
    [self.view addSubview:self.infoLabel];
    [self.view addSubview:self.saveButton];
    
    [self layoutSubViews];
    
    
//    _imageView =[[UIImageView alloc ]init ];
//    [self.view addSubview:_imageView];
//    
//    _imageView.frame = CGRectMake(0, 0, kScreenWidth -128, kScreenWidth -128);
//    [_imageView makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(self.view).offset(128);
//        make.height.width.equalTo(kScreenWidth -128);
//    }];
    
    
    
    [self showLoadView];
    [DJXRequest requestWithBlock:kApiInvitationCode param:nil success:^(id object,NSString *msg) {
        //
        [self hideLoadView];
        if ([object isKindOfClass:[NSDictionary class]]){
            NSDictionary * dict = (NSDictionary *)object;
            self.codeLabel.text = [NSString stringWithFormat:@"我的邀请码：%@",dict[@"InvitedCode"]];
            [self erweima:dict[@"InvitedCode"]];
        }
    } failure:^(id object,NSString *msg) {
        [self hideLoadView];
    }];
}
- (void)didReceiveMemoryWarning{
    
}
- (void)dealloc{
    
}
- (void)loadView{
    [super loadView];
    
    self.title = @"我的邀请码";
}

#pragma mark - lazy load
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
        _contentView.backgroundColor = JXFfffffColor;
    }
    return _contentView;
}
- (UILabel *)codeLabel{
    if (!_codeLabel) {
        _codeLabel = [UILabel new];
        _codeLabel.backgroundColor = JXDebugColor;
        //_codeLabel.text = @"我的邀请码：0016";
        _codeLabel.font = JXFontForNormal(17);
        _codeLabel.textAlignment = NSTextAlignmentCenter;
        _codeLabel.textColor = JXTextColor;
    }
    return _codeLabel;
}

- (UIImageView *)codeImage{
    if (!_codeImage) {
        _codeImage = [UIImageView new];
        _codeImage.backgroundColor = JXDebugColor;
        //_codeImage.image = JXImageNamed(@"image_qr_code");
    }
    return _codeImage;
}

- (UILabel *)infoLabel{
    if (!_infoLabel) {
        _infoLabel = [UILabel new];
        _infoLabel.backgroundColor = JXDebugColor;
        _infoLabel.text = @"请用逛街购APP扫描此二维码~";
        _infoLabel.font = JXFontForNormal(13);
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.textColor = JX666666Color;
    }
    return _infoLabel;
}

- (UIButton *)saveButton{
    if (!_saveButton){
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"保存邀请码" forState:UIControlStateNormal];
        [_saveButton setTitleColor:JX333333Color forState:UIControlStateNormal];
        [_saveButton setBackgroundImage:JXImageNamed(@"btn_default") forState:UIControlStateNormal];
        _saveButton.titleLabel.font = JXFontForNormal(16);
        _saveButton.layer.cornerRadius = 5.f;
        [_saveButton addTarget:self action:@selector(saveEvent:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _saveButton;
}

- (void)layoutSubViews{
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavStatusHeight +10);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.codeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(55);
        make.centerX.equalTo(self.contentView.centerX);
        make.height.equalTo(17);
    }];
    [self.codeImage makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeLabel.bottom).offset(49);
        make.centerX.equalTo(self.contentView.centerX);
        make.width.height.equalTo(188);
    }];
    [self.infoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeImage.bottom).offset(36);
        make.centerX.equalTo(self.contentView.centerX);
        make.height.equalTo(13);
    }];
    [self.saveButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLabel.bottom).offset(62);
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.height.equalTo(44);
    }];
}
#pragma mark - click events
- (void)saveEvent:(UIButton *)button{
    [self showLoadView:@"保存中..."];
    UIImageWriteToSavedPhotosAlbum(_codeImage.image, self, @selector(image: didFinishSavingWithError: contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    [self hideLoadView];
    if (!error){
        [self showJXNoticeMessage:@"保存成功"];
    }else{
        NSLog(@"保存二维码失败：%@",error);
        [self showJXNoticeMessage:@"保存失败"];
    }
}
#pragma mark - code method
- (void)erweima:(NSString *)codeString{
    
    //二维码滤镜
    CIFilter *filter =[CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //恢复滤镜的默认属性
    [filter setDefaults];
    
    //将字符串转换成NSData
    NSData *data = [codeString dataUsingEncoding:NSUTF8StringEncoding];
    
    //设置内容
    [filter setValue:data forKey:@"inputMessage"];
    //设置纠错级别
    [filter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    //获得滤镜输出的图像
    CIImage *outputImage =[filter outputImage];
    
    //将CIImage转换成UIImage,并放大显示
    UIImage *customQrcode =[self createNonInterpolatedUIImageFormCIImage:outputImage withSize:CGRectGetWidth(_codeImage.frame)];
    _codeImage.image = [self imageBlackToTransparent:customQrcode withRed:60.0f andGreen:74.0f andBlue:89.0f];
    
    //如果还想加上阴影，就在ImageView的Layer上使用下面代码添加阴影
    
    _codeImage.layer.shadowOffset =CGSizeMake(0, 0.5);//设置阴影的偏移量
    _codeImage.layer.shadowRadius =1;//设置阴影的半径
    _codeImage.layer.shadowColor =[UIColor blackColor].CGColor;//设置阴影的颜色为黑色
    _codeImage.layer.shadowOpacity =0.3;
    
    
}



//改变二维码大小
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}
@end
