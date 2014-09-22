//
//  AddressModel.h
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "BaseModel.h"

@interface AddressModel : BaseModel

@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* phone;
@property (nonatomic,strong) NSString* address;
@property (nonatomic,strong) NSString* receiveId;
@property (nonatomic,strong) NSString* currentAddress;

@end
