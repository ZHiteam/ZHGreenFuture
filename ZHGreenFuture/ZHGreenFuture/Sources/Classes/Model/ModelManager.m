//
//  ModelManager.m
//  GreenFuture
//
//  Created by elvis on 8/27/14.
//  Copyright (c) 2014 HKWF. All rights reserved.
//

#import "ModelManager.h"
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>


@implementation ModelManager

+(id)instance{
    return [ModelManager instanceWithCLass:[ModelManager class]];
}

+(void)buildModelWithPath:(NSString*)path
                 paramers:(NSDictionary*)paramers
                  success:(void (^)(NSArray* models))success
                  failure:(void (^)(NSError *error))failure{
    
    @try {
        [HttpClient requestDataWithURL:path paramers:paramers success:^(id responseObject) {
            NSArray* models = [[ModelManager instance]buildWithJSON:responseObject];
            success(models);
        } failure:failure];
    }
    @catch (NSException *exception) {
        ZHLOG(@"%@",exception);
    }
    @finally {
        
    }
    
    
}

-(NSArray*)buildWithJSON:(id)jsonData{
    NSArray* backModels = nil;
    
    if ([jsonData isKindOfClass:[NSDictionary class]]) {
        BaseModel* model = [self buildJSONWithDic:jsonData];
        if (model) {
            backModels = [NSArray arrayWithObject:model];
        }
    }
    else if([jsonData isKindOfClass:[NSArray class]]){
        backModels = [self buildJSONWithArray:jsonData];
    }
    
    return backModels;
}

-(NSArray*)buildJSONWithArray:(NSArray*)data{
    NSMutableArray* array = [[NSMutableArray alloc]initWithCapacity:data.count];
    
    for (id json in data) {
        if ([json isKindOfClass:[NSDictionary class]]) {
            [array addObject:[self buildJSONWithDic:json]];
        }
    }
    
    return array;
}

-(BaseModel*)buildJSONWithDic:(NSDictionary*)dic{
    BaseModel* model = nil;
    
    do {
        /// 类型异常
        if (![dic isKindOfClass:[NSDictionary class]]) {
            break;
        }
        
        /// 获取model类型
        NSString* type = [self convertClassType:dic[@"_model"]];
        if (isEmptyString(type)) {
            break;
        }
        /// 获取对应Class
        const char* cClassName = [type UTF8String];
        id theClass = objc_getClass(cClassName);
        
        /// class类型不存在
        if (!theClass) {
            ZHLOG(@"没有对应类型： %@",type);
            break;
        }
        
        /// 解析属性数据
        id values = dic[@"_value"];
        if (!values) {
            ZHLOG(@"Model：%@ 数据为空",theClass);
            break;
        }
        
        /// 解析属性
        if ([values isKindOfClass:[NSArray class]]) {
            
        }
        else if ([values isKindOfClass:[NSDictionary class]]){
            
        }
        else{
            ZHLOG(@"Model数据解析异常");
        }
        
//        /// 生成Object
//        id object = [[[theClass class]alloc]init];
//        
//        [object setValue:@"" forKey:@""];
//        
//        /// 解析属性
//        unsigned int outCount, i;
//        
//        objc_property_t *properties = class_copyPropertyList(theClass, &outCount);
//        
//        NSMutableArray *propertyNames = [[NSMutableArray alloc] initWithCapacity:1];
//        
//        for (i = 0; i < outCount; i++) {
//            
//            objc_property_t property = properties[i];
//            
//            NSString *propertyNameString = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
//            
//            [propertyNames addObject:propertyNameString];
//            
////            [propertyNameString release];
//            
//            NSLog(@"%s %s\n", property_getName(property), property_getAttributes(property));
//        }
    } while (NO);
    
    return model;
}


-(NSString*)convertClassType:(NSString*)type{
    NSMutableString* name = [[NSMutableString alloc]initWithCapacity:1];
    NSArray* types = [type componentsSeparatedByString:@"_"];
    
    for (NSString* sub in types) {
        [name appendString:[sub capitalizedString]];
    }
    
    return name;
}

@end
