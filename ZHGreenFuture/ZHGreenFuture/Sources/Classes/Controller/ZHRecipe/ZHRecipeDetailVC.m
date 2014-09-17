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
#import "ZHDetailRecipeListCell.h"
#import "ZHDetailModel.h"
#import "RecipeCommentCell.h"

#import <DBCamera/DBCameraContainerViewController.h>
#import <DBCamera/DBCameraViewController.h>

@interface ZHRecipeDetailVC ()<UITableViewDataSource,UITableViewDelegate,DBCameraViewControllerDelegate,DBCameraViewControllerDelegate>

@property (nonatomic,strong) UITableView*               contentTable;
@property (nonatomic,strong) RecipeItemDetailModel*     detailData;
@property (nonatomic,strong) UIView*                    toolBar;

@property (nonatomic,strong) ZHDetailRecipeListCell*    recipeListCell;
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
    
    [self.view addSubview:self.toolBar];
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
    
    NSMutableArray* material = [[NSMutableArray alloc]init];
    NSDictionary* val = @{@"椰浆粉":@"100克",@"糯米":@"200克",@"白砂糖":@"适量",@"盐":@"一撮"};
    for (NSString* key in val.allKeys){
        MaterialModel* item = [[MaterialModel alloc]init];
        item.title = key;
        item.weight = val[key];
        
        [material addObject:item];
    }
    self.detailData.material = material;
    
    NSMutableArray* madeStep = [[NSMutableArray alloc]init];
    NSDictionary* step = @{@"推荐一下这个椰浆粉罐头椰浆放久了容易分 层，这个椰浆浓度可以自己掌握，香味比罐 头的足，大家可以自行淘宝。":@"http://images.meishij.net/p/20140520/f67c1ff8a368acb2d61522a830b8319a_150x150.jpg",
                           @"糯米选用泰国的长糯米泡一夜，蒸的时候加 恰好没过糯米的水量，蒸透即可。":@"",
                           @"椰浆粉用温水化开，加入白砂糖和一撮盐， (这个很重要)放入蒸好的糯米饭里拌匀。":@"",
                           @"芒果切片铺在保鲜膜上用卷寿司相同的手法 卷起":@"http://images.meishij.net/p/20140728/aa387a9e1362494f4e612dd63aee093f.jpg"};
    for (NSString* key in step.allKeys){
        MadeStepModel* item = [[MadeStepModel alloc]init];
        item.title = key;
        item.imageUrl = step[key];
        
        [madeStep addObject:item];
    }
    self.detailData.practice = madeStep;

    self.detailData.tips = @"糯米选用泰国的长糯米，泡一夜蒸的时候加恰好 没过糯米的水量。";
    
    recommendRecipeItem * recipeItem = [[recommendRecipeItem alloc] init];
    recipeItem.title = @"豌豆糯米饭";
    recipeItem.imageURL = @"";
    recipeItem.placeholderImage = @"detailRecipe.png";
    self.detailData.example = @[recipeItem , recipeItem, recipeItem, recipeItem, recipeItem,recipeItem,recipeItem,recipeItem];

    self.detailData.commentCount = @"18";
    
    CommentModel* model = [[CommentModel alloc]init];
    model.userAvatarURL = @"http://www.smzdm.com/smzdm_user_manager/data/avatar/000/88/53/09_avatar_middle.jpg";
    model.userName = @"唉唉唉";
    model.contenet = @"请问椰果是没有甜度的么";
    model.comment_date = @"7月23日 17:30";
    
    self.detailData.commentList = @[model,model];
    
    
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
        
        _contentTable.height -= TAB_BAR_HEIGHT;
    }
    
    return _contentTable;
}

-(UIView *)toolBar{
    if (!_toolBar){
        _toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-TAB_BAR_HEIGHT, self.view.width, TAB_BAR_HEIGHT)];
        _toolBar.backgroundColor = GREEN_COLOR;
        
        UIButton* camera = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, TAB_BAR_HEIGHT, TAB_BAR_HEIGHT)];
        [camera setImage:[UIImage themeImageNamed:@"btn_camera"] forState:UIControlStateNormal];
        [_toolBar addSubview:camera];
        
        [camera addTarget:self action:@selector(cameraAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* upload = [[UIButton alloc]initWithFrame:CGRectMake(camera.left+5, 0, 150, TAB_BAR_HEIGHT)];
        [upload setTitle:@"上传作品" forState:UIControlStateNormal];
        [upload setTitleColor:WHITE_TEXT forState:UIControlStateNormal];
        [_toolBar addSubview:upload];
        
        [upload addTarget:self action:@selector(cameraAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toolBar;
}

#pragma -mark getter end

#pragma -mark -action
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
            case 4:{
                cell = self.recipeListCell = [ZHDetailRecipeListCell tableViewCell];
                UILabel* recipeLabel = self.recipeListCell.recipeLabel;
                recipeLabel.text = @"大家都在照着菜谱做";
                recipeLabel.textColor = GREEN_COLOR;
                recipeLabel.font = FONT(16);
                recipeLabel.frame = CGRectMake(5, 5, 100, 25);
                
                UILabel* count = self.recipeListCell.recipeCountLabel;
                count.textColor = GREEN_COLOR;
                count.font = FONT(16);
                count.frame = CGRectMake(100, 5, 100, 25);
            }
                
                break;
            case 5:
                cell = [[RecipeCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                break;
            default:
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                break;
        }
    }
    
    switch (indexPath.row) {
        case 0:
        {
            RecipeImageCell* imageCell = (RecipeImageCell*)cell;
            imageCell.height = [RecipeImageCell viewHeightWithContent:self.detailData.health];
            imageCell.model = self.detailData;
        }
            
            break;
        case 1:
        {
            RecipeMaterialCell* materialView = (RecipeMaterialCell*)cell;
            materialView.model = self.detailData;
        }
            break;
        case 2:
        {
            RecipeMadeStepCell* view = (RecipeMadeStepCell*)cell;
            view.model = self.detailData;
        }
            break;
        case 3:
        {
            RecipeTipsCell* view = (RecipeTipsCell*)cell;
            view.model = self.detailData;
        }
            break;
        case 4:
        {
            self.recipeListCell.recipeCountLabel.text = [NSString stringWithFormat:@" (%d)",[self.detailData.example count]];
            __weak typeof(self) weakSelf = self;
            [self.recipeListCell setMoreItemClickedBlock:^(id sender) {
                //TODO:more item
                NSLog(@">>>more Item clicked %@",weakSelf);
            }];
            
            [self.recipeListCell.recipeListView setImageItems:self.detailData.example selectedBlock:nil isAutoPlay:NO];
            [self.recipeListCell.recipeListView updateLayout];

        }
            break;
        case 5:
        {
            RecipeCommentCell* view = (RecipeCommentCell*)cell;
            view.model = self.detailData;
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
            height = [ZHDetailRecipeListCell height];
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
