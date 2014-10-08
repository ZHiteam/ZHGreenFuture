//
//  ShoppingChartModel.m
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ShoppingChartModel.h"

@implementation ShoppingChartModel

-(id)init{
    self = [super init];
    
    if (self){
        self.checked = NO;
    }
    
    return self;
}

+(id)praserModelWithInfo:(id)info{
    ShoppingChartModel* model = [[ShoppingChartModel alloc]init];
    
    if (![info isKindOfClass:[NSDictionary class]]){
        return model;
    }
    
    NSDictionary* dic = (NSDictionary*)info;
    
    model.shoppingChartId   = VALIDATE_VALUE(dic[@"shoppingCartId"]);
    model.imageURL          = VALIDATE_VALUE(dic[@"imageURL"]);
    model.title             = VALIDATE_VALUE(dic[@"title"]);
    model.skuInfo           = VALIDATE_VALUE(dic[@"skuInfo"]);
    model.marketPrice       = VALIDATE_VALUE(dic[@"marketPrice"]);
    model.promotionPrice    = VALIDATE_VALUE(dic[@"promotionPrice"]);
    model.buyCout           = VALIDATE_VALUE(dic[@"buyCount"]);
    model.productId         = VALIDATE_VALUE(dic[@"productId"]);
    model.validate          = VALIDATE_VALUE(dic[@"validate"]);
    
    model.oldCount          = @"-1";
    return model;
}

-(void)setBuyCout:(NSString *)buyCout{
    if ([self.oldCount floatValue] < 0){
        self.oldCount = buyCout;
    }
    _buyCout = buyCout;
}
@end
