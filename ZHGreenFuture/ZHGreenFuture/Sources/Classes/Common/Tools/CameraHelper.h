//
//  CameraHelper.h
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CameraHelperDelegate

-(void)cameraTakePhotoSuccess:(UIImage*)image;

@end
@interface CameraHelper : NSObject

+(void)takePhone:(id<CameraHelperDelegate>)successDelegate;
@end
