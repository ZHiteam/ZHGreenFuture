//
//  RecpieExampleModel.h
//  ZHGreenFuture
//
//  Created by elvis on 9/17/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "BaseModel.h"

@interface RecpieExampleModel : BaseModel

@property (nonatomic,strong) NSString*  count;
@property (nonatomic,strong) NSArray*   images;
@end

@interface RecipeExampleImageContent : BaseModel<FEImageItemProtocol>

@property (nonatomic,strong) NSString*  url;
@property (nonatomic,strong) NSString*  content;
@property (nonatomic,strong) NSString*  placeholderImage;
@end