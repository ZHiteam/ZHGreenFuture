//
//  ZHAddressManagerVC.h
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHViewController.h"
#import "AddressModel.h"

@protocol ZHAddressManagerDelegate <NSObject>

-(void)selectedAtAddress:(AddressModel*)address;
-(void)deleteAddress:(AddressModel*)address;
@end

@interface ZHAddressManagerVC : ZHViewController
@property (nonatomic,assign) id delegate;
@end
