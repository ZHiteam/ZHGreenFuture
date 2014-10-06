//
//  CatagoryModel.m
//  ZHGreenFuture
//
//  Created by elvis on 8/31/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "CatagoryModel.h"

@implementation CatagoryModel

+(id)praserModelWithInfo:(id)info{
    CatagoryModel* model = [[CatagoryModel alloc]init];
    
    if (![info isKindOfClass:[NSDictionary class]]){
        return model;
    }
    NSDictionary* dic = (NSDictionary*)info;

    model.lastPage = NO;
    model.title                 = dic[@"title"];
    model.subtitle              = dic[@"title"];
    model.backgourndImageUrl    = dic[@"iconURL"];
    model.categoryId            = [NSString stringWithFormat:@"%d",[dic[@"categoryId"]intValue]];

    id val = dic[@"shortTitles"];
    if ([val isKindOfClass:[NSArray class]]){
        NSMutableArray* array = [[NSMutableArray alloc]initWithCapacity:((NSArray*)val).count];
        for (id value in val){
            SecondCatagoryModel* scModel = (SecondCatagoryModel*)[SecondCatagoryModel praserModelWithInfo:value];
            [array addObject:scModel];
        }
        
        model.productList = array;
    }
    
    return model;
}

#pragma -mark CategoryPageingDelegate
-(BOOL)isLastPage{
    return self.lastPage;
}

-(NSInteger)currentPage{
    return self.page;
}

-(void)setCurrentPage:(NSInteger)page{
    self.page = page;
}

-(void)setLastPage:(BOOL)bLastPage{
    _lastPage = bLastPage;
}

-(void)appendData:(NSArray*)data{
    if (!self.dataItems){
        [self setData:data];
    }
    else{
        [self.dataItems addObjectsFromArray:data];
    }
}

-(void)setData:(NSArray*)data{
    if (!data){
        self.dataItems = nil;
    }
    else{
        self.dataItems = [NSMutableArray arrayWithArray:data];
    }
}

-(NSArray *)datas{
    return self.dataItems;
}

-(NSString *)categoryIdentify{
    return self.categoryId;
}
@end
