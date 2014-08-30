//
//  InitCatagory.h
//  GreenFuture
//
//  Created by elvis on 8/27/14.
//  Copyright (c) 2014 HKWF. All rights reserved.
//

#import "BaseModel.h"

@interface InitCatagory : BaseModel

@property (nonatomic) NSString*     name;
@property (nonatomic) NSArray*      subCatagory;
@property (nonatomic) BaseModel*    model;

@end
