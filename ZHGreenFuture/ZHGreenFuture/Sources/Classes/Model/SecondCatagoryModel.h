//
//  SecondCatagoryModel.h
//  ZHGreenFuture
//
//  Created by elvis on 8/31/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "BaseModel.h"
#import "ZHProductItem.h"
#import "PageingDelegate.h"

@protocol CategoryPageingDelegate <PageingDelegate>
-(NSString*)categoryIdentify;
@end

@interface SecondCatagoryModel : BaseModel<CategoryPageingDelegate>

@property (nonatomic,strong) NSString*  title;
@property (nonatomic,strong) NSString*  imageUrl;
@property (nonatomic,strong) NSString*  descript;
@property (nonatomic,strong) NSString*  categoryId;

@property (nonatomic,strong) NSMutableArray*   dataItems;

@property (nonatomic,assign) BOOL       lastPage;
@property (nonatomic,assign) NSInteger  page;
@end
