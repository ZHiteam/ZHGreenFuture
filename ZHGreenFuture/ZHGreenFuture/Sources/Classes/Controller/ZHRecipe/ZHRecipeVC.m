//
//  ZHRecipeVC.m
//  ZHGreenFuture
//
//  Created by admin on 14-8-30.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHRecipeVC.h"
#import "LunarCalendar.h"
#import <DBCamera/DBCameraContainerViewController.h>
#import <DBCamera/DBCameraViewController.h>

@interface ZHRecipeVC ()<DBCameraViewControllerDelegate,DBCameraViewControllerDelegate>

@property (nonatomic,strong) UIView*            titleViewPanel;
@property (nonatomic,strong) UILabel*           weekLabel;
@property (nonatomic,strong) UILabel*           dateLabel;

@end

@implementation ZHRecipeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadContent{
    NSDate* date = [NSDate date];
    NSDateFormatter* formater = [[NSDateFormatter alloc]init];
    
    [formater setDateFormat: @"yyyy.MM.dd"];
    self.dateLabel.text = [formater stringFromDate:date];
    
    [formater setDateFormat:@"EE"];
    LunarCalendar* lunar = [date chineseCalendarDate];
    
    self.weekLabel.text = [NSString stringWithFormat:@"%@/%@",lunar.DayLunar,[formater stringFromDate:date]];///@"大暑/周一";

    
    [self.navigationBar setTitleView:self.titleViewPanel];
    
    self.navigationBar.rightBarItem = [UIButton barItemWithTitle:@"" image:[UIImage themeImageNamed:@"btn_camera"] action:self selector:@selector(cameraAction)];
}

-(UIView *)titleViewPanel{
    if (!_titleViewPanel){
        _titleViewPanel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width-88, NAVIGATION_BAR_HEIGHT)];
        
        [_titleViewPanel addSubview:self.weekLabel];
        [_titleViewPanel addSubview:self.dateLabel];
        
        self.weekLabel.frame = CGRectMake(0, 2, _titleViewPanel.width, NAVIGATION_BAR_HEIGHT/3*2);
        self.dateLabel.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT/2, _titleViewPanel.width, NAVIGATION_BAR_HEIGHT/3);
    }
    
    return _titleViewPanel;
}

-(UILabel *)weekLabel{
    if (!_weekLabel){
        _weekLabel = [UILabel labelWithText:@"" font:FONT(18) color:WHITE_TEXT textAlignment:NSTextAlignmentCenter];
        
    }
    return _weekLabel;
}

-(UILabel *)dateLabel{
    if (!_dateLabel){
        _dateLabel = [UILabel labelWithText:@"" font:FONT(12) color:WHITE_TEXT textAlignment:NSTextAlignmentCenter];
    }
    
    return _dateLabel;
}

- (void)cameraAction{
    
    DBCameraContainerViewController *container = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    DBCameraViewController *cameraController = [DBCameraViewController initWithDelegate:self];
    [cameraController setUseCameraSegue:NO];
    [container setCameraViewController:cameraController];

    [container setFullScreenMode];
    
    UIViewController* mainVC = [MemoryStorage valueForKey:k_NAVIGATIONCTL];

    [mainVC presentViewController:container animated:YES completion:^{

    }];
}

#pragma -mark DBCameraViewControllerDelegate
- (void) dismissCamera:(id)cameraViewController{
    [cameraViewController restoreFullScreenMode];
    UIViewController* mainVC = [MemoryStorage valueForKey:k_NAVIGATIONCTL];
    [mainVC dismissViewControllerAnimated:YES completion:nil];
}

- (void) camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata{
    [cameraViewController restoreFullScreenMode];
    UIViewController* mainVC = [MemoryStorage valueForKey:k_NAVIGATIONCTL];
    [mainVC dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObject:@"ZHRecipePublishVC" forKey:@"controller"];
    
    if (image){
        [dic setValue:image forKey:@"userinfo"];
        [[MessageCenter instance]performActionWithUserInfo:dic];
    }
}
@end
