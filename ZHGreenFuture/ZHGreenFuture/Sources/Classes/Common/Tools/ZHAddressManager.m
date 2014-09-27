//
//  ZHAddressManager.m
//  ZHGreenFuture
//
//  Created by elvis on 9/24/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHAddressManager.h"

@implementation ZHAddressManager

+(ZHAddressManager*)instance{
    return [ZHAddressManager instanceWithCLass:[ZHAddressManager class]];
}

-(instancetype)init{
    self = [super init];
    if (self){
        [self loadListRequest];
    }
    
    return self;
}

-(void)loadListRequestWithBlock:(void (^)(BOOL success))SuccessBlock{

    //    if (![[ZHAuthorizationManager shareInstance]isLogin] || isEmptyString([ZHAuthorizationManager shareInstance].userId)){
    //        return;
    //    }
    //
    //    NSString* userId= [ZHAuthorizationManager shareInstance].userId;
#warning 用户ID
    NSString* userId = @"1";
    
    [HttpClient requestDataWithParamers:@{@"scene":@"16",@"userId":userId} success:^(id responseObject) {
        [self setAddressWithInfo:responseObject];
        
        if (SuccessBlock){
            SuccessBlock(YES);
        }
    } failure:^(NSError *error) {
        if (SuccessBlock){
            SuccessBlock(NO);
        }
    }];

    
}

-(void)loadListRequest{
    [self loadListRequestWithBlock:nil];
}

-(void)updateAddressListWithBlock:(void (^)(BOOL success))SuccessBlock{
    [self loadListRequestWithBlock:SuccessBlock];
}

-(void)setAddressWithInfo:(id)info{
    if ([info isKindOfClass:[NSDictionary class]]){
        if ([info[@"receiveInfoList"] isKindOfClass:[NSArray class]]){
            NSArray* array = (NSArray*)info[@"receiveInfoList"];
            
            NSMutableArray* muData = [[NSMutableArray alloc]initWithCapacity:array.count];
            for (id val in array){
                AddressModel* model = [AddressModel praserModelWithInfo:val];
                if (model){
                    [muData addObject:model];
                }
            }
            
            self.addressList = muData;
        }
    }
}

-(AddressModel*)defaultAddress{
    for (AddressModel* model in self.addressList){
        if ([model.currentAddress boolValue]){
            return model;
        }
    }
    
    if (self.addressList.count > 0){
        return self.addressList[0];
    }
    return nil;
}
@end
