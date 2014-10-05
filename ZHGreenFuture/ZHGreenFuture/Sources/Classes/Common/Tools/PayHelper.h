//
//  PayHelper.h
//  ZHGreenFuture
//
//  Created by elvis on 10/5/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayHelper : NSObject

+(void)aliPayWithTitle:(NSString*)productTitle
        productInfo:(NSString*)info
         totalPrice:(NSString*)totalPrice
            orderId:(NSString*)orderId;

@end
