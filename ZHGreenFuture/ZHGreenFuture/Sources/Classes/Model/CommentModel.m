//
//  CommentModel.m
//  ZHGreenFuture
//
//  Created by elvis on 9/17/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

+(id)praserModelWithInfo:(id)info{
    CommentModel* model = [[CommentModel alloc]init];
    if (![info isKindOfClass:[NSDictionary class]]){
        return model;
    }
    
    NSDictionary* dic = (NSDictionary*)info;
    
    model.contenet = dic[@"content"];
    model.comment_date = dic[@"commentDate"];
    model.userName = dic[@"nickName"];
    model.userId = [NSString stringWithFormat:@"%d", [dic[@"userId"]intValue]];
    model.userAvatarURL = dic[@"userAvatarURL"];
    model.commentId = [NSString stringWithFormat:@"%d",[dic[@"commentId"]intValue]];
    
    return model;
}

@end