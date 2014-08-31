//
//  ZHShoppingVC.m
//  ZHGreenFuture
//
//  Created by admin on 14-8-30.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHShoppingVC.h"

@interface ZHShoppingVC ()

@end

@implementation ZHShoppingVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadContent];
}


-(void)loadContent{    
//    UIButton* btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    
//    [btn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.navigationBar.rightBarItem = btn;
    
    self.navigationBar.rightBarItem = [UIButton barItemWithTitle:nil image:[UIImage themeImageNamed:@"btn_search"] action:self selector:@selector(action)];
    [self.navigationBar setTitle:@"粮仓分类"];

}


-(void)action{
    [[MessageCenter instance]performActionWithUserInfo:@{@"controller": @"ZHViewController",
                                                         @"title":@"测试"}];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
