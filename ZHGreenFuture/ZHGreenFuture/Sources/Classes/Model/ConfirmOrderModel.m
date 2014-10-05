//
//  ConfirmOrderModel.m
//  ZHGreenFuture
//
//  Created by elvis on 10/5/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ConfirmOrderModel.h"

@implementation ConfirmOrderModel

+(id)praserModelWithInfo:(id)info{
    ConfirmOrderModel* model = [[ConfirmOrderModel alloc]init];
    
    if (![info isKindOfClass:[NSDictionary class]]){
        return model;
    }
    
    NSDictionary* dic = (NSDictionary*)info;
    
    if ([dic[@"receiveInfo"] isKindOfClass:[NSDictionary class]]){
        model.receiveInfo = [AddressModel praserModelWithInfo:dic[@"receiveInfo"]];
    }
    if ([dic[@"shoppingList"] isKindOfClass:[NSArray class]]){
        NSArray* shoppingList = dic[@"shoppingList"];
        
        NSMutableArray* list = [[NSMutableArray alloc]initWithCapacity:shoppingList.count];
        
        for (NSDictionary* productInfo in shoppingList) {
            if (![productInfo isKindOfClass:[NSDictionary class]]){
                continue;
            }
            
            ShoppingChartModel* chart = [ShoppingChartModel praserModelWithInfo:productInfo];
            [list addObject:chart];
        }
        
        model.shoppingList = list;
    }
    
    
    model.productTotalPrice     = [NSString stringWithFormat:@"%.2f",[dic[@"productTotalPrice"]floatValue]];
    model.reducePrice           = [NSString stringWithFormat:@"%.2f",[dic[@"reducePrice"]floatValue]];
    model.totalPrice            = [NSString stringWithFormat:@"%.2f",[dic[@"totalPrice"]floatValue]];
    if ([dic[@"express"] isKindOfClass:[NSString class]]){
        model.express           = dic[@"express"];
    }
    else{
        model.express           = [NSString stringWithFormat:@"%.2f",[dic[@"express"]floatValue]];
    }
    
    model.shoppingCartIdList    = dic[@"shoppingCartIdList"];

    return model;
}

@end
