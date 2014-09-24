//
//  ZHAddressManager.h
//  ZHGreenFuture
//
//  Created by elvis on 9/24/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressModel.h"

@interface ZHAddressManager : NSObject

@property (nonatomic,strong) NSArray*   addressList;

+(id)instance;
@end
