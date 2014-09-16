//
//  ZHRecipeDetailVC.m
//  ZHGreenFuture
//
//  Created by elvis on 9/9/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHRecipeDetailVC.h"
#import <ShareSDK/ShareSDK.h>
#import "RecipeImageView.h"
#import "RecipeItemDetailModel.h"

@interface ZHRecipeDetailVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView*   contentTable;
@property (nonatomic,strong) RecipeItemDetailModel*     detailData;

@end

@implementation ZHRecipeDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadContnet];

    [self loadRequest];
}

- (void)loadContnet{
    self.navigationBar.title = @"芒果椰浆檽米饭";
    
    self.navigationBar.rightBarItem = [UIButton barItemWithTitle:@"" image:[UIImage themeImageNamed:@"btn_share"] action:self selector:@selector(shareAction)];
    
    [self whithNavigationBarStyle];
    
    [self.view addSubview:self.contentTable];
}

-(void)loadRequest{
//    [HttpClient requestDataWithURL:@"" paramers:@{@"recipeId": self.recipeId} success:^(id responseObject) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
#warning TEST
    self.detailData = [[RecipeItemDetailModel alloc]init];
    self.detailData.backgroundImage = @"";
    self.detailData.author = @"哎米饭";
    self.detailData.done = @"10";
    self.detailData.health = @"糯米：补中益气，健胃止泻解毒";
    
    [self.contentTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -mark getter

-(UITableView *)contentTable{
    
    if (!_contentTable) {
        _contentTable = [[UITableView alloc]initWithFrame:self.contentBounds];
        _contentTable.backgroundColor = GRAY_LINE;
        _contentTable.delegate = self;
        _contentTable.dataSource = self;
        _contentTable.showsVerticalScrollIndicator = NO;
        _contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _contentTable;
}

#pragma -mark getter end

#pragma -mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* identify = [NSString stringWithFormat:@"recipeIdentify%d",indexPath.row];
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell){
        
        switch (indexPath.row){
            case 0:
                cell = [[RecipeImageView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                break;
//            case 1:
//                break;
//            case 2:
//                break;
//            case 3:
//                break;
//            case 4:
//                break;
//            case 5:
//                break;
            default:
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                break;
        }
    }
    
    switch (indexPath.row) {
        case 0:
        {
            RecipeImageView* imageCell = (RecipeImageView*)cell;
            imageCell.model = self.detailData;
        }
            
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0.0f;
    
    switch (indexPath.row) {
        case 0:
            height = [RecipeImageView viewHeightWithContent:self.detailData.health];
            break;
            
        default:
            break;
    }
    
    return height;
}

#pragma -mark share action
-(void)shareAction{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
#warning TEST SHARE
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.sharesdk.cn"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}
@end
