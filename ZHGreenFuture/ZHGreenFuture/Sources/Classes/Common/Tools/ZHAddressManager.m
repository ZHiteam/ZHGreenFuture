//
//  ZHAddressManager.m
//  ZHGreenFuture
//
//  Created by elvis on 9/24/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHAddressManager.h"

@implementation ZHAddressManager

+(id)instance{
    return [ZHAddressManager instanceWithCLass:[ZHAddressManager class]];
}

-(instancetype)init{
    self = [super init];
    if (self){
        
    }
    
    return self;
}

-(void)loadListRequest{
//    if (![[ZHAuthorizationManager shareInstance]isLogin] || isEmptyString([ZHAuthorizationManager shareInstance].userId)){
//        return;
//    }
//
//    NSString* userId= [ZHAuthorizationManager shareInstance].userId;
#warning 用户ID
    NSString* userId = @"1";
    
    [HttpClient requestDataWithURL:@"serverAPI.action" paramers:@{@"userId":userId} success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}

@end
