//
//  NSString+HKWF.m
//  Stock4HKWF
//
//  Created by elvis on 7/11/13.
//  Copyright (c) 2013 HKWF. All rights reserved.
//

#import "NSString+ZHitem.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (ZHitem)

- (BOOL)isPureInt{
    
    NSScanner* scan = [NSScanner scannerWithString:self];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

//判断是否为浮点形：

- (BOOL)isPureFloat{
    
    NSScanner* scan = [NSScanner scannerWithString:self];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}


- (NSString*)urlEncode {
    
    NSArray *escapeChars = [NSArray arrayWithObjects:@";" , @"/" , @"?" , @":" ,
                            @"@" , @"&" , @"=" , @"+" ,    @"$" , @"," ,
                            @"!", @"'", @"(", @")", @"*", nil];
    
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F", @"%3F" , @"%3A" ,
                             @"%40" , @"%26" , @"%3D" , @"%2B" , @"%24" , @"%2C" ,
                             @"%21", @"%27", @"%28", @"%29", @"%2A", nil];
    
    int len = [escapeChars count];
    
    NSMutableString *temp = [[self
                              stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                             mutableCopy];
    
    int i;
    for (i = 0; i < len; i++) {
        
        [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
                              withString:[replaceChars objectAtIndex:i]
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, [temp length])];
    }
    
    NSString *outStr = [NSString stringWithString:temp];
    
    return outStr;
}

-(NSURL*)formateToURL{
    NSString* temp = self;
    if ([self hasPrefix:@"http://"]) {
        temp = [self substringFromIndex:6];
    }
    
    NSArray* arry = [temp componentsSeparatedByString:@"/"];
    if (arry.count > 0) {
        temp = @"http:/";
        for (int i = 0; i < arry.count; ++i) {
            if (isEmptyString(arry[i])) {
                continue;
            }
            temp = [temp stringByAppendingFormat:@"/%@",[arry[i] urlEncode]];
        }
    }
    else{
        temp = [temp urlEncode];
        temp = [NSString stringWithFormat:@"http://%@",temp];
    }
    
    return [[NSURL alloc]initWithString:temp];
}

//利用正则表达式验证
-(BOOL)isValidateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

-(NSString *)bankNo2NormalString{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}


-(BOOL)isIDCard{
    
    NSString *idRegex1 = @"/^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$/";
    NSString *idRegex2 = @"/^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{4}$/";

    NSString* regex = @"";
    if (self.length == 15) {
        regex = idRegex1;
    }
    else if (self.length == 18) {
        regex = idRegex2;
    }
    
    NSPredicate *idTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [idTest evaluateWithObject:self];
    
}

-(NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end
