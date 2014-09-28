//
//  ZHConst.h
//  ZHGreenFuture
//
//  Created by admin on 14-8-30.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TABBAR_COUNT 4

#define k_NAVIGATIONCTL @"k_navigation_controller"

typedef void(^ZHCompletionBlock)(BOOL isSuccess);
typedef void(^ZHProgressBlock)(float progress);

#define GREEN_COLOR         RGB(102,170,0)
#define GRAY_LINE           RGB(204, 204, 204)
#define WHITE_BACKGROUND    RGB(255,255,255)
#define WHITE_TEXT          RGB(255,255,255)
#define BLACK_TEXT          RGB(0,0,0)

//#define ALERT_MESSAGE(msg)  {UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];[alert show];}

#define ALERT_MESSAGE(msg)     DoAlertView* a = [[DoAlertView alloc]init];[a doYes:msg yes:^(DoAlertView *alertView) {}];

#define SHOW_MESSAGE(msg,dur)         DoAlertView* alert = [[DoAlertView alloc]init];[alert doAlert:@"" body:msg duration:dur done:^(DoAlertView *alertView) {}];

#define ZHSTATUS_BAR_CHANGE @"zh_status_bar_change"

#define SHARE_APPKEY                    @"3028b230599a"
#define COMMENT_URL                     @"http://cmt.sharesdk.cn:5566/countInteract"


#define BASE_SITE                       @"http://115.29.207.63:8080"
#define SCHEME                          @"greenFuture"
//#define BASE_SITE                       @"http://192.168.18.38:8983"
//#define SCHEME                          @"gf"
#define BASE_URL                        [NSString stringWithFormat:@"%@/%@/serverAPI.action",SCHEME,BASE_SITE]
#define kTimeoutInterval                6.0

#define ZHALERTVIEW(TARGET,TITLE,MESSAGE,CANCELBUTTON,OTHERBUTTONS...) {UIAlertView *av =[[UIAlertView alloc] initWithTitle:TITLE message:MESSAGE delegate:TARGET cancelButtonTitle:CANCELBUTTON otherButtonTitles:OTHERBUTTONS];[av show];av=nil;}


//URL
#define ZHGotoDetailVC(productId)      {   productId = [productId length] > 0 ? productId : @"";                       \
    [[MessageCenter instance]performActionWithUserInfo:@{@"controller": @"ZHDetailVC",@"userinfo" : productId}];       \
}


#define ZHGotoCategoryDetailVC(categoryId,type)      {   categoryId = [categoryId length] > 0 ? categoryId : @"";       \
type = [type length] > 0 ? type : @"";                                                                                  \
SecondCatagoryModel* secondModel =  [[SecondCatagoryModel alloc] init]; secondModel.categoryId = categoryId;            \
[[MessageCenter instance]performActionWithUserInfo:@{@"controller": @"ZHSubCatagoryVC",@"userinfo" : secondModel}];     \
}
