//
//  ZHHomePageVC.m
//  ZHGreenFuture
//
//  Created by admin on 14-8-30.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHHomePageVC.h"
#import "ZHHomePageModel.h"
#import "ZHBannerTableViewCell.h"
#import "ZHCategoryTableViewCell.h"
#import "ZHRecommendTableViewCell.h"
#import "ZHProductTableViewCell.h"
#import "ZHDetailVC.h"

@interface ZHHomePageVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView     *tableView;
@property(nonatomic, strong)ZHHomePageModel       *homePageModel;
@property(nonatomic, strong)ZHBannerTableViewCell   *bannerTableviewCell;
@property(nonatomic, strong)ZHCategoryTableViewCell *categoryTableviewCell;
@property(nonatomic, strong)ZHRecommendTableViewCell*recommendTableViewCell;


@end

@implementation ZHHomePageVC

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
    // Do any additional setup after loading the view.
    [self loadConent];
    [self configureNaivBar];
    [self.view addSubview:self.tableView];
    //[self.view insertSubview:self.tableView belowSubview:self.navigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter & Setter
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.contentBounds];
        //_tableView.clipsToBounds = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor lightGrayColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        //[_tableView registerClass:[ZHProductTableViewCell class] forCellReuseIdentifier:@"kProductTableViewCell"];
    }
    return _tableView;
}

- (ZHHomePageModel *)homePageModel {
    if (_homePageModel == nil) {
        _homePageModel = [[ZHHomePageModel alloc] init];
    }
    return _homePageModel;
}

#pragma mark - Privte Method
- (void)loadConent{

}

- (void)configureNaivBar{
    [self.navigationBar setTitle:@"首页"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 60 , 44)];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"qr_code"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftBarItem = button;
    
    button = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 20, 60 , 44)];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"cart"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarItem = button;
}

- (ZHBannerTableViewCell *)bannerTableviewCell{
    if (_bannerTableviewCell == nil) {
      _bannerTableviewCell = [ZHBannerTableViewCell tableViewCell];
    }
    return _bannerTableviewCell;
}

- (ZHCategoryTableViewCell *)categoryTableviewCell{
    if (_categoryTableviewCell == nil) {
        _categoryTableviewCell = [ZHCategoryTableViewCell tableViewCell];

    }
    return _categoryTableviewCell;
}

- (ZHRecommendTableViewCell *)recommendTableViewCell{
    if (_recommendTableViewCell == nil) {
        _recommendTableViewCell = [ZHRecommendTableViewCell tableViewCell];
    }
    return _recommendTableViewCell;
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

- (void)bannerItemPressed:(NSInteger)index{
    //TODO: banner
    NSLog(@">>>>%@ %d",NSStringFromSelector(_cmd),index);
}

- (void)categoryItemPressed:(NSInteger)index{
//TODO: category
    NSLog(@">>>>%@ %d",NSStringFromSelector(_cmd),index);
}

- (void)surpriseItemPressed{
    //TODO: surprise
    NSLog(@">>>>%@",NSStringFromSelector(_cmd));
}


- (void)creditsItemPressed{
    //TODO: credits
    NSLog(@">>>>%@",NSStringFromSelector(_cmd));
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 3 : [self.homePageModel.productItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==0) {
        switch (indexPath.row) {
            case 0:
            {
                ZHBannerTableViewCell*cell = self.bannerTableviewCell;
                __weak __typeof(self) weakSelf = self;
                [cell.bannerScrollView setImageItems:self.homePageModel.bannerItems selectedBlock:^(FEImageItem *sender) {
                    //do nothing here now
                    [weakSelf bannerItemPressed:sender.tag];
                } isAutoPlay:YES];
                return cell;
            }
                break;
            case 1:
            {
                ZHCategoryTableViewCell*cell = self.categoryTableviewCell;
                __weak __typeof(self) weakSelf = self;
                [cell layoutWithCategoryItem:self.homePageModel.categoryItems clickedBlock:^(NSInteger index) {
                    [weakSelf categoryItemPressed:index];
                }];
                return cell;
            }
                break;
            case 2:
            {
                ZHRecommendTableViewCell*cell = self.recommendTableViewCell;
                cell.dateLabel.text = self.homePageModel.calenderItem.date;
                cell.titleLabel.text = self.homePageModel.calenderItem.title;
                cell.subTitleLabel.text = self.homePageModel.calenderItem.subTitle;
                [cell.surpriseImageView setImageWithURL:[NSURL URLWithString:self.homePageModel.surpriseItem.imageURL] placeholderImage:[UIImage imageNamed:@"surprise"]];
                [cell.creditsImageView setImageWithURL:[NSURL URLWithString:self.homePageModel.creditsItem.imageURL] placeholderImage:[UIImage imageNamed:@"credits"]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

                __weak __typeof(self) weakSelf = self;
                [cell.surpriseImageView touchEndedBlock:^(NSSet *touches, UIEvent *event) {
                    [weakSelf surpriseItemPressed];
                }];
                [cell.creditsImageView touchEndedBlock:^(NSSet *touches, UIEvent *event) {
                   [weakSelf creditsItemPressed];
                }];
//                [cell.surpriseImageView tapGestureBlock:^{
//                    [weakSelf surpriseItemPressed];
//                                                }
//                                              tapNumber:1 toucheNumber:1];
//                [cell.creditsImageView tapGestureBlock:^{
//                    [weakSelf creditsItemPressed];
//                                                }
//                                              tapNumber:1 toucheNumber:1];
                
                return cell;
            }
                break;
            default:
                break;
        }
    }
    else {
        static NSString *CellIdentifier = @"kProductTableViewCell";
        ZHProductTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [ZHProductTableViewCell tableViewCell];
        }
        
        ZHProductItem *item = [self.homePageModel.productItems objectAtIndex:indexPath.row];
        [cell.imageURL setImageWithURL:[NSURL URLWithString:item.imageURL] placeholderImage:[UIImage imageNamed:@"productPlaceholder"]];
        cell.title.text = item.title;
        cell.subTitle.text = item.subTitle;
        ///435人已买
        cell.priceTitle.text = item.price;
        cell.buyCount.text = [item.buyCount length] >0 ? [NSString stringWithFormat:@"/%@人已买",item.buyCount] :@"1人已买";
        [cell updateBuyCountLabelPositon];
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
                return [ZHBannerTableViewCell height];
                break;
            case 1:
                return [ZHCategoryTableViewCell height];
                break;
            case 2:
                return [ZHRecommendTableViewCell height];
                break;
            default:
                break;
        }
    }
    else {
        return [ZHProductTableViewCell height];
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 0.0 : 28.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 28)];
        label.text = @"   今日最新鲜TOP50";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor whiteColor];
        return label;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        ZHProductItem *item = [self.homePageModel.productItems objectAtIndex:indexPath.row];
        NSString *productId = [item.productId length] >0 ? item.productId : @"";
        //[[ZHDetailVC alloc] initWithProductId:item.productId];
        [[MessageCenter instance]performActionWithUserInfo:@{@"controller": @"ZHDetailVC",@"userinfo" : productId}];
    }
    NSLog(@">>>>>didSelectRowAtIndexPath %@",indexPath);
}


@end
