//
//  MyQRViewController.m
//  OC_APP
//
//  Created by xingl on 2017/7/21.
//  Copyright © 2017年 兴林. All rights reserved.
//


#import <Photos/Photos.h>

#import "MyQRViewController.h"

@interface MyQRViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, assign) CGFloat brightness;

@end

@implementation MyQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"二维码";
    
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(30, 80, kScreenWidth-60, kScreenWidth-60)];
    [self.view addSubview:imgV];
    
    if (IOS_Foundation_Later_8) {
    
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle :@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(albumAction:)];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(dealLongPress:)];
        [imgV addGestureRecognizer:longPress];
        imgV.userInteractionEnabled = YES;
    }

    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame = imgV.bounds;
    activityIndicator.color = THEME_CLOLR;
    [imgV addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        UIImage *image = [UIImage xl_qrCodeImageWithContent:@"http://weixin.qq.com/r/osx1bTzE12GorXgO95mw" codeImageLenght:400 logo:[UIImage imageNamed:@"weixin.png"] radius:10];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
            
            imgV.image = image;
        });
    });
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgV.frame), kScreenWidth, 40)];
    label.text = @"扫一扫上面的二维码图案，加我微信";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.brightness = [UIScreen mainScreen].brightness;
    
    [[UIScreen mainScreen] setBrightness:0.7f];
}
- (void)viewWillDisappear:(BOOL)animated {
    
    [[UIScreen mainScreen] setBrightness:self.brightness];
    [super viewWillDisappear:animated];
}
- (void)albumAction:(UIBarButtonItem *)item {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark-> 长按识别二维码
-(void)dealLongPress:(UIGestureRecognizer*)gesture{
    
    if(gesture.state==UIGestureRecognizerStateBegan){
        
        UIImageView *tempImageView=(UIImageView*)gesture.view;
        
        [self checkQRWithImage:tempImageView.image];
     
        /** iOS8后才能使用
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *changeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:tempImageView.image];
            changeRequest.creationDate = [NSDate date];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                NSLog(@"success");
            } else {
                NSLog(@"error saving to photos: %@", error);
            }
        }];
        */
        
        UIImageWriteToSavedPhotosAlbum(tempImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if(!error) {
        
        NSLog(@"successfully saved");
    } else {
        
        NSLog(@"error saving to photos: %@", error);
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *pickImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        
        //        self.qrImageV.image = pickImage;
        [self checkQRWithImage:pickImage];
    }];
}

- (void)checkQRWithImage:(UIImage *)image {
    
    if(image){
        
        //1. 初始化扫描仪，设置设别类型和识别质量
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyLow }];
        //2. 扫描获取的特征组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count < 1) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:@"您还没有生成二维码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        //3. 获取扫描结果
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scannedResult = feature.messageString;
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:scannedResult delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:@"您还没有生成二维码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
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
