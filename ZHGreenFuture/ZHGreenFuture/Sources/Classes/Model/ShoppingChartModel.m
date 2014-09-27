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
    
    model.shoppingChartId   = [NSString stringWithFormat:@"%d",[dic[@"shoppingCartId"]intValue]];
    model.imageURL          = dic[@"imageURL"];
    model.title             = dic[@"title"];
    model.skuInfo           = dic[@"skuInfo"];
    model.marketPrice       = [NSString stringWithFormat:@"%.2f",[dic[@"marketPrice"]floatValue]];
    /// 容错服务端错别字
    if ([model.marketPrice isEqualToString:@"0.00"]){
        model.marketPrice       = [NSString stringWithFormat:@"%.2f",[dic[@"marketPirce"]floatValue]];
    }
    model.promotionPrice    = [NSString stringWithFormat:@"%.2f",[dic[@"promotionPrice"]floatValue]];
    model.buyCout           = [NSString stringWithFormat:@"%d",[dic[@"buyCount"]intValue]];
    model.productId         = [NSString stringWithFormat:@"%d",[dic[@"productId"]intValue]];
    model.validate          = dic[@"validate"];
    
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
