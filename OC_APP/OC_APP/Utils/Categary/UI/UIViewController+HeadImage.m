//
//  UIViewController+HeadImage.m
//  OC_APP
//
//  Created by xingl on 2017/7/13.
//  Copyright © 2017年 yjpal. All rights reserved.
//

#import "UIViewController+HeadImage.h"
#import <AVFoundation/AVFoundation.h>
#import <objc/runtime.h>

#import "ViewController.h"

static const char *HeadPictureViewKey = "HeadPictureViewKey";
static const char *ImagePickerControllerKey = "ImagePickerControllerKey";


@implementation UIViewController (HeadImage)

- (void)setHeadPictureView:(UIImageView *)headPictureView {
    // 第一个参数：给哪个对象添加关联
    // 第二个参数：关联的key，通过这个key获取
    // 第三个参数：关联的value
    // 第四个参数:关联的策略
    objc_setAssociatedObject(self, HeadPictureViewKey, headPictureView, OBJC_ASSOCIATION_ASSIGN);
}

- (UIImageView *)headPictureView {
    return objc_getAssociatedObject(self, HeadPictureViewKey);
}
- (UIImagePickerController *)imagePicker {
    return objc_getAssociatedObject(self, ImagePickerControllerKey);
}
- (void)setImagePicker:(UIImagePickerController *)imagePicker {
    objc_setAssociatedObject(self, ImagePickerControllerKey, imagePicker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)changeHeadImageWithHeadImageView:(UIImageView *)imgV {
    
    self.headPictureView = imgV;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headImageChange:)];
    self.headPictureView.userInteractionEnabled = YES;
    [self.headPictureView addGestureRecognizer:tap];
}
- (void)headImageChange:(UIGestureRecognizer *)gesture {
    
    if (!self.imagePicker) {
        
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        //设置拍照后的图片可被编辑
        self.imagePicker.allowsEditing = YES;
    }
    
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self openTakePhoto];
        }];
        UIAlertAction *pickPhoto = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self openPhotoalbums];
        }];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertCtl addAction:takePhoto];
        [alertCtl addAction:pickPhoto];
        [alertCtl addAction:cancle];
        [self presentViewController:alertCtl animated:YES completion:nil];
    }
}

- (void)openTakePhoto {
    
    if (![self checkCameraAvailability]) {
        NSLog(@"没有访问相机权限");
        return;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    } else {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

- (void)openPhotoalbums {
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    self.imagePicker.sourceType = sourceType;
    
    [self presentViewController:self.imagePicker animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        //图片可编辑
        UIImage *newHeaderImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        
        self.headPictureView.image = newHeaderImage;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark 相机权限
- (BOOL)checkCameraAvailability {
    
    __block BOOL status = NO;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusAuthorized) {
        status = YES;
    } else if (authStatus == AVAuthorizationStatusDenied) {
        status = NO;
        [self goToSettingCameraPrivilege];
    } else if (authStatus == AVAuthorizationStatusRestricted) {
        status = NO;
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            
            status = granted;
        }];
        
    }
    return status;
}

#pragma mark 提示用户去系统设置修改相机权限
- (void)goToSettingCameraPrivilege
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"相机权限已被禁用，基础功能暂无法使用，是否去开启？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"去开启" style:0 handler:^(UIAlertAction * _Nonnull action) {
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL])
            {
                [[UIApplication sharedApplication] openURL:settingsURL];
            }
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"暂不开启" style:1 handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:confirm];
        [alertController addAction:cancel];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
}



@end
