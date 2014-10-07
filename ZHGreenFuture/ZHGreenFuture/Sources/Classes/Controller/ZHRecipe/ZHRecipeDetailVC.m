//
//  ZHRecipeDetailVC.m
//  ZHGreenFuture
//
//  Created by elvis on 9/9/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHRecipeDetailVC.h"
#import <ShareSDK/ShareSDK.h>
#import "RecipeImageCell.h"
#import "RecipeItemDetailModel.h"
#import "RecipeMaterialCell.h"
#import "RecipeMadeStepCell.h"
#import "RecipeTipsCell.h"
#import "RecipeCommentCell.h"
#import "RecipeExampleCell.h"
#import "ZHAuthorizationVC.h"

#import "CameraHelper.h"

@interface ZHRecipeDetailVC ()<UITableViewDataSource,UITableViewDelegate,CameraHelperDelegate>

@property (nonatomic,strong) UITableView*               contentTable;
@property (nonatomic,strong) RecipeItemDetailModel*     detailData;
@property (nonatomic,strong) UIButton*                    toolBar;

@end

@implementation ZHRecipeDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadContnet];
}

-(void)viewWillAppear:(BOOL)animated{
//    if (self.navigationCtl.topViewController != self){
//        return;
//    }
    [self loadRequest];
}

- (void)loadContnet{
    
    if ([self.userInfo isKindOfClass:[RecipeItemModel class]]){
        self.model = self.userInfo;
    }
    
    self.navigationBar.title = self.model.title;
    
    self.navigationBar.rightBarItem = [UIButton barItemWithTitle:@"" image:[UIImage themeImageNamed:@"btn_share"] action:self selector:@selector(shareAction)];
    
    [self whithNavigationBarStyle];
    
    [self.view addSubview:self.contentTable];
    
    [self.view addSubview:self.toolBar];
}

-(void)loadRequest{
    if (isEmptyString(self.model.recipeId)){
        return;
    }
    
    [HttpClient requestDataWithParamers:@{@"scene":@"7",@"recipeId": self.model.recipeId} success:^(id responseObject) {
        FELOG(@"%@",responseObject);
        
        self.detailData = [RecipeItemDetailModel praserModelWithInfo:responseObject];
        
        [self.contentTable reloadData];
        
    } failure:^(NSError *error) {
        
    }];
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
        
        _contentTable.height -= TAB_BAR_HEIGHT;
    }
    
    return _contentTable;
}

-(UIButton *)toolBar{
    if (!_toolBar){
        _toolBar = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.height-TAB_BAR_HEIGHT, self.view.width, TAB_BAR_HEIGHT)];
        _toolBar.backgroundColor = GREEN_COLOR;
        
        UIButton* camera = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, TAB_BAR_HEIGHT, TAB_BAR_HEIGHT)];
        [camera setImage:[UIImage themeImageNamed:@"btn_camera"] forState:UIControlStateNormal];
        [_toolBar addSubview:camera];
        

        
        UIButton* upload = [[UIButton alloc]initWithFrame:CGRectMake(camera.left+5, 0, 150, TAB_BAR_HEIGHT)];
        [upload setTitle:@"上传作品" forState:UIControlStateNormal];
        [upload setTitleColor:WHITE_TEXT forState:UIControlStateNormal];
        [_toolBar addSubview:upload];
        
        UIControl* ctl = [[UIControl alloc]initWithFrame:_toolBar.bounds];
        [ctl addTarget:self action:@selector(cameraAction) forControlEvents:UIControlEventTouchUpInside];
        
        [_toolBar addSubview:ctl];
    }
    return _toolBar;
}

#pragma -mark getter end

#pragma -mark -action 
- (void)cameraAction{
//#warning 测试屏蔽登录
    if (![[[ZHAuthorizationVC shareInstance] authManager] isLogin])
    {
        [ZHAuthorizationVC showLoginVCWithCompletionBlock:^(BOOL isSuccess, id info) {
            if (isSuccess) {
                [CameraHelper takePhone:self];
            }
        }];
    }
    else{
        [CameraHelper takePhone:self];
    }
    
}

#pragma -mark CameraHelperDelegate
-(void)cameraTakePhotoSuccess:(UIImage *)image{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObject:@"ZHRecipePublishVC" forKey:@"controller"];
    if (image){
        NSMutableDictionary* userInfo = [[NSMutableDictionary alloc]initWithCapacity:2];
        [userInfo setObject:image forKey:@"image"];
        if (!isEmptyString(self.model.recipeId)){
            [userInfo setObject:self.model.recipeId forKey:@"recipeId"];
        }
        
        [dic setValue:userInfo forKey:@"userinfo"];
    }
    [[MessageCenter instance]performActionWithUserInfo:dic];
}

#pragma -mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* identify = [NSString stringWithFormat:@"recipeIdentify%d",indexPath.row];
    
    RecipeBaseCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell){
        switch (indexPath.row){
            case 0:
                cell = [[RecipeImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                break;
            case 1:
                cell = [[RecipeMaterialCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                break;
            case 2:
                cell = [[RecipeMadeStepCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                break;
            case 3:
                cell = [[RecipeTipsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                break;
            case 4:
                cell = [[RecipeExampleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                break;
            case 5:
                cell = [[RecipeCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                break;
            default:
                break;
        }
    }
    
    cell.model = self.detailData;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height = 0.0f;
    
    switch (indexPath.row) {
        case 0:
            height = [RecipeImageCell viewHeightWithContent:self.detailData.health];
            break;
        case 1:
            height = [RecipeMaterialCell viewHeightWithContent:self.detailData.material];
            break;
        case 2:
            height = [RecipeMadeStepCell viewHeightWithContent:self.detailData.practice];
            break;
        case 3:
            height = [RecipeTipsCell viewHeightWithContent:self.detailData.tips];
            break;
        case 4:
            height = [RecipeExampleCell viewHeightWithContent:self.detailData.example];
            break;
        case 5:
            height = [RecipeCommentCell viewHeightWithContent:self.detailData.commentList];
            break;
        default:
            break;
    }
    
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (5 == indexPath.row){
        if (!isEmptyString(self.model.recipeId)){
            [[MessageCenter instance]performActionWithUserInfo:@{@"controller":@"ZHCommentVC",@"userinfo":self.model.recipeId}];
        }
    }
}

#pragma -mark share action
-(void)shareAction{
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
//#warning TEST SHARE
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:self.model.title
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithUrl:self.model.backgroundImageUrl]
                                                title:self.model.title
                                                  url:@"http://www.baidu.com"
                                          description:self.model.title
                                            mediaType:SSPublishContentMediaTypeNews];
//    
//    + (id<ISSContent>)content:(NSString *)content
//defaultContent:(NSString *)defaultContent
//image:(id<ISSCAttachment>)image
//title:(NSString *)title
//url:(NSString *)url
//description:(NSString *)description
//mediaType:(SSPublishContentMediaType)mediaType
//locationCoordinate:(SSCLocationCoordinate2D *)locationCoordinate;
    
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
