//
//  BaseModel.h
//  GreenFuture
//
//  Created by elvis on 8/27/14.
//  Copyright (c) 2014 HKWF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

@property (nonatomic) NSString* state;

+(BaseModel*)praserModelWithInfo:(id)info;
@end
