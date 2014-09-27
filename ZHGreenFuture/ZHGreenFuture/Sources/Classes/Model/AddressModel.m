//
//  AddressModel.m
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

+(id)praserModelWithInfo:(id)info{
    AddressModel* model = [[AddressModel alloc]init];
    
    if (![info isKindOfClass:[NSDictionary class]]){
        return model;
    }
    
    NSDictionary* dic = (NSDictionary*)info;
    
    model.address   = dic[@"address"];
    model.name      = dic[@"name"];
    model.phone     = dic[@"phone"];
    model.currentAddress    = [NSString stringWithFormat:@"%d",[dic[@"currentAddress"]intValue]];
    model.receiveId = [NSString stringWithFormat:@"%d", [dic[@"receiveId"]intValue]];
    
    return model;
}
@end
