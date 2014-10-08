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
    
    model.address   = VALIDATE_VALUE(dic[@"address"]);
    model.name      = VALIDATE_VALUE(dic[@"name"]);
    model.phone     = VALIDATE_VALUE(dic[@"phone"]);
    model.currentAddress    = VALIDATE_VALUE(dic[@"currentAddress"]);
    model.receiveId = VALIDATE_VALUE(dic[@"receiveId"]);
    
    return model;
}
@end
