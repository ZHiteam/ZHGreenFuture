//
//  CameraHelper.m
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "CameraHelper.h"
#import <DBCamera/DBCameraContainerViewController.h>
#import <DBCamera/DBCameraViewController.h>

@interface CameraHelper()<DBCameraViewControllerDelegate,DBCameraViewControllerDelegate>

@property (nonatomic,strong) DBCameraContainerViewController*   cameraContainerVC;
@property (nonatomic,strong) DBCameraViewController*            cameraVC;

@property (nonatomic,assign) id<CameraHelperDelegate>           cameraDelegate;
@end

@implementation CameraHelper

+(id)instance{
    return [CameraHelper instanceWithCLass:[CameraHelper class]];
}

-(DBCameraContainerViewController *)cameraContainerVC{
    
    if (!_cameraContainerVC){
        DBCameraContainerViewController *container = [[DBCameraContainerViewController alloc] initWithDelegate:self];
        [container setCameraViewController:self.cameraVC];
        [container setFullScreenMode];
        
        _cameraContainerVC = container;
        
    }
    
    return _cameraContainerVC;
}

-(DBCameraViewController *)cameraVC{
    if (!_cameraVC){
        DBCameraViewController *cameraController = [DBCameraViewController initWithDelegate:self];
        [cameraController setUseCameraSegue:NO];
        
        _cameraVC = cameraController;
    }
    
    return _cameraVC;
}

+(void)takePhone:(id<CameraHelperDelegate>)successDelegate{
    [[CameraHelper instance]takePhone:successDelegate];
}

-(void)takePhone:(id<CameraHelperDelegate>)successDelegate{
    self.cameraDelegate = successDelegate;
    
    UIViewController* mainVC = [MemoryStorage valueForKey:k_NAVIGATIONCTL];
    [mainVC presentViewController:self.cameraContainerVC animated:YES completion:^{
        
    }];
}

#pragma -mark DBCameraViewControllerDelegate
- (void) dismissCamera:(id)cameraViewController{
    [self dismissVC];
    
    self.cameraDelegate = nil;
}

- (void) camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata{
    if (image){
        UIImage* scImage = [UIImage scaleImage:image toScale:0.3];

        if (scImage){
            [self.cameraDelegate cameraTakePhotoSuccess:scImage];
        }
    }
    [self dismissVC];
    self.cameraContainerVC = nil;
}

-(void)dismissVC{
    [self.cameraContainerVC restoreFullScreenMode];
    UIViewController* mainVC = [MemoryStorage valueForKey:k_NAVIGATIONCTL];
    [mainVC dismissViewControllerAnimated:YES completion:nil];
}

@end
