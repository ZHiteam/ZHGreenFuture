//
//  ZHDetailVC.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-6.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHDetailVC.h"
#import "ZHDetailModel.h"
#import "ZHDetailBannerCell.h"
#import "ZHDetailPriceCell.h"
#import "ZHDetailLogisticsInfoCell.h"
#import "ZHDetailProductGuaranteeCell.h"
#import "ZHDetailSKUInfoCell.h"
#import "ZHDetailRecipeListCell.h"
#import "ZHDetailProductCell.h"
#import "ZHDetailProductHeadView.h"
#import "ZHRootViewController.h"
#import "RecipeItemModel.h"
#import "UIImageView+WebCache.h"
#import "ZHDetailCommentViewController.h"


@interface ZHDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UIColor             *backColor;
@property(nonatomic, strong)UITableView         *tableView;
@property(strong, nonatomic)FEScrollPageView    *imagesView;
@property(nonatomic, strong)ZHDetailModel       *detailModel;
@property(nonatomic, strong)ZHDetailBannerCell  *bannerTableviewCell;
@property(nonatomic, strong)ZHDetailPriceCell           *priceTableviewCell;
@property(nonatomic, strong)ZHDetailLogisticsInfoCell   *logisticsTableviewCell;
@property(nonatomic, strong)ZHDetailProductGuaranteeCell*productGuaranteeTableviewCell;
@property(nonatomic, strong)ZHDetailSKUInfoCell         *skuInfoTableviewCell;
@property(nonatomic, strong)ZHDetailRecipeListCell      *recipeTableviewCell;
@property(nonatomic, strong)UIButton                    *addCartButton;
@property(nonatomic, strong)NSString                    *productId;

@end

@implementation ZHDetailVC

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
    self.backColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    self.view.backgroundColor = self.backColor ;
    self.tableView.backgroundColor = self.backColor;
    [self configureNaivBar];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addCartButton];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadConent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter & Setter
- (void)setUserInfo:(id)userInfo{
    [super setUserInfo:userInfo];
    if (userInfo && [userInfo isKindOfClass:[NSString class]]) {
        self.productId = userInfo;
    }
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectOffset(self.contentBounds, 0, 0)];
        //_tableView.clipsToBounds = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor lightGrayColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

- (ZHDetailModel *)detailModel {
    if (_detailModel == nil) {
        _detailModel = [[ZHDetailModel alloc] init];
    }
    return _detailModel;
}

- (ZHDetailBannerCell *)bannerTableviewCell{
    if (_bannerTableviewCell == nil) {
        _bannerTableviewCell = [ZHDetailBannerCell tableViewCell];
    }
    return _bannerTableviewCell;
}

- (ZHDetailPriceCell *)priceTableviewCell{
    if (_priceTableviewCell == nil) {
        _priceTableviewCell = [ZHDetailPriceCell tableViewCell];
    }
    return _priceTableviewCell;
}

-(ZHDetailLogisticsInfoCell *)logisticsTableviewCell{
    if (_logisticsTableviewCell == nil) {
        _logisticsTableviewCell = [ZHDetailLogisticsInfoCell tableViewCell];
    }
    return _logisticsTableviewCell;
}

- (ZHDetailProductGuaranteeCell *)productGuaranteeTableviewCell{
    if (_productGuaranteeTableviewCell == nil) {
        _productGuaranteeTableviewCell = [ZHDetailProductGuaranteeCell tableViewCell];
    }
    return _productGuaranteeTableviewCell;
}

- (ZHDetailSKUInfoCell *)skuInfoTableviewCell{
    if (_skuInfoTableviewCell == nil) {
        _skuInfoTableviewCell = [ZHDetailSKUInfoCell tableViewCell];
    }
    return _skuInfoTableviewCell;
}

- (ZHDetailRecipeListCell *)recipeTableviewCell{
    if (_recipeTableviewCell == nil) {
        _recipeTableviewCell = [ZHDetailRecipeListCell tableViewCell];
    }
    return _recipeTableviewCell;
}

- (UIButton *)addCartButton{
    if (_addCartButton == nil) {
        _addCartButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addCartButton setFrame:CGRectMake(0, self.view.frame.size.height - 48, 320, 48)];
        [_addCartButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_addCartButton setBackgroundColor:[UIColor colorWithRed:85/255.0 green:153/255.0 blue:0/255.0 alpha:1.0]];
        [_addCartButton addTarget:self action:@selector(addCartButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addCartButton;
}

#pragma mark - Privte Method
- (void)loadConent{
    __weak typeof(self) weakSelf = self;
    //[FEToastView showWithTitle:@"正在加载数据..." animation:YES];
    [self.detailModel loadDataWithProductId:self.productId completionBlock:^(BOOL isSuccess) {
        //[FEToastView dismissWithAnimation:YES];
        if (isSuccess) {
            [weakSelf.tableView reloadData];
        } else {
            [FEToastView showWithTitle:@"加载数据失败，请稍候再试。" animation:YES interval:2.0];
        }
    }];
}

- (void)configureNaivBar{
    [self.navigationBar setTitle:@"商品详情"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60 , 44)];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(100, 20, 60 , 44)];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarItem = button;
    
    //default back
    [self whithNavigationBarStyle];
}

- (void)gotoDetailWithProductId:(NSString*)productId{
    productId = [productId length] > 0 ? productId : @" ";
    [[MessageCenter instance]performActionWithUserInfo:@{@"controller": @"ZHDetailVC",@"userinfo" : productId}];
    
}

#pragma mark - Event Handler
- (void)leftItemPressed:(id)sender{
    //TODO: qr
    NSLog(@">>>>%@",NSStringFromSelector(_cmd));
}

- (void)rightItemPressed:(id)sender{
    //TODO: cart
    NSLog(@">>>>%@",NSStringFromSelector(_cmd));
}

- (void)addCartButtonPressed:(id)sender{
    /// modify by kongkong
    if (![[ZHAuthorizationManager shareInstance]isLogin]){
        [ZHAuthorizationVC showLoginVCWithCompletionBlock:^(BOOL isSuccess, id info) {
            if (isSuccess){
                [self doAddChart];
            }
        }];
    }
    else{
        [self doAddChart];
    }
//    NSString *productId = [self.detailModel.productId length] > 0 ? self.detailModel.productId : @" ";
//    [[MessageCenter instance]performActionWithUserInfo:@{@"controller": @"ZHShoppingChartVC",@"userinfo" : productId}];
}

-(void)doAddChart{
//    NSString *productId = [self.detailModel.productId length] > 0 ? self.detailModel.productId : @"";
    if (isEmptyString(self.detailModel.productId)){
        SHOW_MESSAGE(@"加入购物车失败",2);
    }
    NSDictionary* dic = @{@"productId":self.detailModel.productId,@"userId":[ZHAuthorizationManager shareInstance].userId,@"quantity":@"1",@"scene":@"32"};
    
    [HttpClient postDataWithParamers:dic success:^(id responseObject) {
        BaseModel* model = [BaseModel praserModelWithInfo:responseObject];
    
        if ([model.state boolValue]){
            SHOW_MESSAGE(@"加入购车成功", 2);
        }
        else{
            SHOW_MESSAGE(@"加入购物车失败", 2);
        }
    } failure:^(NSError *error) {
        SHOW_MESSAGE(@"加入购物车失败", 2);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([self.detailModel.recommendRecipeList count] >0) {
        if ([self.detailModel.otherBuyList count] >0) {
            return 4;
        }
        return 3;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 4;
        case 1:
            return 1;
        case 2:
            return 1;
        case 3:
            return 1;
        case 4:
            return  [self.detailModel.otherBuyList count] / 2.0 + ([self.detailModel.otherBuyList count] % 2);
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==0) {
        switch (indexPath.row) {
            case 0:
            {
                ZHDetailBannerCell *cell =  self.bannerTableviewCell;
                [cell.bannerImageView setImageItems:self.detailModel.bannerImages selectedBlock:nil isAutoPlay:YES];
                cell.bannerImageView.pageControl.pageIndicatorTintColor        = [UIColor whiteColor];
                cell.bannerImageView.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:68/255.0 green:136/255.0 blue:0.0 alpha:1.0];
                cell.bannerImageView.pageControl.frame = CGRectMake(0, 252, 320, 10);
                [cell.bannerImageView bringSubviewToFront:cell.bannerBlurBackView];
                cell.bannerTitleLabel.text = self.detailModel.title;
                
                return cell;
            }
                break;
            case 1:
            {
                ZHDetailPriceCell *cell = self.priceTableviewCell;
                cell.promotionPriceLabel.text = self.detailModel.promotionPrice;
                cell.marketPirceLabel.text    = self.detailModel.marketPirce;
                //cell.priceTagLabel.text       = self.detailModel.
                return cell;
            }
                break;
            case 2:
            {
                ZHDetailLogisticsInfoCell *cell = self.logisticsTableviewCell;
                //cell.logisticsFreeLabel.text = self.detailModel.
                NSString *count = [self.detailModel.salesCount length] > 0 ? self.detailModel.salesCount : @"1";
                cell.salesCountLabel.text    = [NSString stringWithFormat:@"月销 %@ 件",count];
                cell.producingAreaLabel.text = self.detailModel.fromPlace;
                return cell;
            }
                break;
            case 3:
            {
                ZHDetailProductGuaranteeCell *cell = self.productGuaranteeTableviewCell;
                return cell;
            }
                break;
            default:
                break;
        }
        }
    else if (indexPath.section ==1){
        static NSString *CellIdentifier = @"kCommentProductTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"评价详情";
        return cell;
    }
    else if (indexPath.section ==2){
        ZHDetailSKUInfoCell *cell = self.skuInfoTableviewCell;
        __weak typeof(self) weakSelf = self;
        __weak typeof(cell) weakCell = cell;
        [cell setSegmentControlClickedBlock:^(NSInteger index) {
            NSString *imageURL = [weakSelf.detailModel.introduceImageList objectAtIndex:index];
            [weakCell.infoImageView  setImageWithURL:[NSURL URLWithString:imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                if (image.size.height > [ZHDetailSKUInfoCell height]) {
                    //weakCell.infoImageView.contentMode = UIViewContentModeScaleToFill;
                } else {
                    //weakCell.infoImageView.contentMode = UIViewContentModeScaleAspectFit;
                }
                [weakSelf.tableView reloadData];
                CGRect rect = weakCell.infoImageView.frame ;
                rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, image.size.height/2.0);
                weakCell.infoImageView.frame = rect;
            }];
        }];
        if (cell.segmentControl.selectedIndex < [self.detailModel.introduceImageList count]) {
            NSString *imageURL = [self.detailModel.introduceImageList objectAtIndex:cell.segmentControl.selectedIndex];
            [cell.infoImageView setImageWithURL:[NSURL URLWithString:imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    [weakSelf.tableView reloadData];
                    CGRect rect = weakCell.infoImageView.frame ;
                    rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, image.size.height/2.0);
                    weakCell.infoImageView.frame = rect;
                });
            }];
        }
        return cell;
    }
    else if (indexPath.section ==3){
        ZHDetailRecipeListCell *cell = self.recipeTableviewCell;
        cell.recipeCountLabel.text = [NSString stringWithFormat:@" (%d)",[self.detailModel.recommendRecipeList count]];
        //__weak typeof(self) weakSelf = self;
        [cell setMoreItemClickedBlock:^(id sender) {
            NavigationViewController*   navi = [MemoryStorage valueForKey:k_NAVIGATIONCTL];
            [navi popToRoot];
            ZHRootViewController *rootVC = [[[UIApplication sharedApplication] delegate] performSelector:@selector(rootViewController)];
            TabbarViewController *tabbarVC = [rootVC performSelector:@selector(tabCtl)];
            [tabbarVC selectAtIndex:2 animation:YES];
        }];
        
        [cell.recipeListView setImageItems:self.detailModel.recommendRecipeList selectedBlock:^(FEImageItem *sender) {
            if (sender && [sender isKindOfClass:[ZHRecommendRecipeItem class]]) {
                ZHRecommendRecipeItem *item = (ZHRecommendRecipeItem*)sender;
                if (item.recipeId) {
                    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
                    [dic setObject:@"ZHRecipeDetailVC" forKey:@"controller"];
                    RecipeItemModel* model = [[RecipeItemModel alloc] init];
                    model.recipeId = item.recipeId;
                    [dic setObject:model forKey:@"userinfo"];   
                    [[MessageCenter instance]performActionWithUserInfo:dic];
                }
            }
        } isAutoPlay:NO];
        [cell.recipeListView updateLayout];
        
        return cell;
    }
    
    else {
        static NSString *CellIdentifier = @"kDetailProductTableViewCell";
        ZHDetailProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [ZHDetailProductCell tableViewCell];
        }
        
        NSArray * buyLists = self.detailModel.otherBuyList;
        
        //left item
        ZHOtherBuyItem *leftItem  = [buyLists objectAtIndex:indexPath.row*2];
        [cell.leftImageView setImageWithUrlString:leftItem.imageURL];
        [cell.leftPriceLabel setText:leftItem.price];
        [cell.leftTitleLabel setText:leftItem.title];
        
        __weak typeof(self) weakSelf = self;
        __weak typeof(cell) weakCell = cell;
        [cell.leftOverLayerView touchEndedBlock:^(NSSet *touches, UIEvent *event) {
            weakCell.leftOverLayerView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakCell.leftOverLayerView.backgroundColor = [UIColor clearColor];
            });
            NSLog(@">>>left productId = %@ %p", leftItem.productId,leftItem);
            if (leftItem.productId) {
                [weakSelf gotoDetailWithProductId:leftItem.productId];
            }
        }];
        
        //right item
        if ((indexPath.row * 2 +1) < [buyLists count] ) {
            cell.rightOverLayerView.backgroundColor = [UIColor clearColor];
            cell.rightOverLayerView.userInteractionEnabled = YES;
            ZHOtherBuyItem *rightItem = [buyLists objectAtIndex:indexPath.row*2 + 1];
            [cell.rightImageView setImageWithUrlString:leftItem.imageURL];
            [cell.rightPriceLabel setText:rightItem.price];
            [cell.rightTitleLabel setText:rightItem.title];
            
            [cell.rightOverLayerView touchEndedBlock:^(NSSet *touches, UIEvent *event) {
                weakCell.rightOverLayerView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    weakCell.rightOverLayerView.backgroundColor = [UIColor clearColor];
                });
                NSLog(@">>>right productId = %@ %p", rightItem.productId,rightItem);
                if (rightItem.productId) {
                    [weakSelf gotoDetailWithProductId:rightItem.productId];
                }
            }];
        } else {
            cell.rightOverLayerView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
            cell.rightOverLayerView.userInteractionEnabled = NO;
        }
        return cell;
    }
    return nil;
}


#pragma mark -  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //TBHomePageOneSectionData* sectionItem;
    if (indexPath.section ==0) {
        switch (indexPath.row) {
            case 0:
                return [ZHDetailBannerCell height];
            case 1:
                return [ZHDetailPriceCell height];
            case 2:
                return [ZHDetailLogisticsInfoCell height];
            case 3:
                return [ZHDetailProductGuaranteeCell height];
            default:
                break;
        }
    }
    else if (indexPath.section ==1){
        return 44.0;
    }
    else if (indexPath.section ==2){
        CGFloat height = 40.0 + roundf(self.skuInfoTableviewCell.infoImageView.image.size.height/2.0);
        height = (height!=40) ? height : [ZHDetailSKUInfoCell height];
        return height;
    }
    else if (indexPath.section ==3){
        return [ZHDetailRecipeListCell height];
    }
    else if (indexPath.section ==4){
        return [ZHDetailProductCell height];
    }
    return 0.0;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0;
    } else if (section == 1 || section == 2){
        return 12.0;
    } else if (section == 3){
        return [ZHDetailProductHeadView height];
    }
    
    if (section == 3){
        return [ZHDetailProductHeadView height];
    }
     
    return  0.0;
}
*/

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
     if (section == 1 || section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = self.backColor;
        return view;
    }
    
    if (section == 3) {
        return [ZHDetailProductHeadView headView];
    }
    return nil;
}
 */

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 1 || section == 2){
        return 12.0;
    }
    if (section == 3){
        return [ZHDetailProductHeadView height];
    }
    if (section == 4) {
        return 48.0;//placeHolder
    }
    
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 1 || section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = self.backColor;
        return view;
    }
    if (section == 3) {
        return [ZHDetailProductHeadView headView];
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        [[MessageCenter instance]performActionWithUserInfo:@{@"controller": @"ZHDetailCommentViewController",@"userinfo" : self.productId}];
    }
    NSLog(@">>>>>didSelectRowAtIndexPath %@",indexPath);
}


@end
