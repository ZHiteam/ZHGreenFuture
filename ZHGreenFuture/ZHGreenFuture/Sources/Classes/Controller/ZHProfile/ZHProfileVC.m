//
//  ZHProfileVC.m
//  ZHGreenFuture
//
//  Created by admin on 14-8-30.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHProfileVC.h"
#import "ZHProfileModel.h"
#import "ZHOrderTableViewCell.h"
#import "ZHNormalTableViewCell.h"
#import "ZHOrderBadgeView.h"
#import "ZHPersonInfoVC.h"
#import "ZHOrderListVC.h"
#import "ZHProductsVC.h"
#import "ZHAuthorizationVC.h"
#import "ZHRootViewController.h"
#import "TabbarViewController.h"
#import "DRImagePlaceholderHelper.h"

@interface ZHProfileVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView          *tableView;
@property(nonatomic, strong)ZHOrderTableViewCell *orderTableViewCell;
@property(nonatomic, strong)ZHProfileModel       *profileModel;
@property(nonatomic, strong)UIImageView          *avatarImageView;
@property(nonatomic, strong)UILabel              *userNameLabel;
@property(nonatomic, strong)UIView               *containerView;

@end

@implementation ZHProfileVC

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
    
    [self configureNaivBar];
    [self.view addSubview:self.tableView];
    [self.tableView addCoverWithImage:[UIImage imageNamed:@"myBG.png"] withTopView:nil aboveView:self.containerView enableBlur:NO];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, FECoverViewHeight + 0)];
    self.tableView.tableHeaderView.userInteractionEnabled = NO;
    [self.avatarImageView setImageWithUrlString:self.profileModel.userAvatar];
    __weak typeof(self) weakSelf = self;
    [self.avatarImageView touchEndedBlock:^(NSSet *touches, UIEvent *event) {
        ZHPersonInfoVC *personInfoVC = [[ZHPersonInfoVC alloc] init];
        personInfoVC.profileModel = weakSelf.profileModel;
        NavigationViewController*   navi = [MemoryStorage valueForKey:k_NAVIGATIONCTL];
        [navi pushViewController:personInfoVC animation:ANIMATE_TYPE_DEFAULT];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![[[ZHAuthorizationVC shareInstance] authManager] isLogin]){
        [ZHAuthorizationVC showLoginVCWithCompletionBlock:^(BOOL isSuccess, id info) {
            if (!isSuccess) {
                ZHRootViewController *rootVC = [[[UIApplication sharedApplication] delegate] performSelector:@selector(rootViewController)];
                TabbarViewController *tabbarVC = [rootVC performSelector:@selector(tabCtl)];
                [tabbarVC selectAtIndex:0 animation:YES];
            }
        }];
    } else {
        [self loadConent];
    }
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
        _tableView.backgroundColor = RGB(234, 234, 234);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

- (ZHOrderTableViewCell *)orderTableViewCell{
    if (_orderTableViewCell == nil) {
        _orderTableViewCell = [ZHOrderTableViewCell tableViewCell];
        _orderTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return _orderTableViewCell;
}

- (ZHProfileModel *)profileModel{
    if (_profileModel == nil) {
        _profileModel = [[ZHProfileModel alloc] init];
    }
    return _profileModel;
}

- (UIImageView *)avatarImageView{
    if (_avatarImageView == nil) {
        CGRect  rect = CGRectMake(([UIScreen mainScreen].bounds.size.width - 68)/2.0, 0, 68, 68);
        _avatarImageView = [[UIImageView alloc] initWithFrame:rect];
        _avatarImageView.layer.cornerRadius  = rect.size.height/2.0;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.backgroundColor = [UIColor clearColor];
    }
    return _avatarImageView;
}

- (UILabel *)userNameLabel{
    if (_userNameLabel == nil) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, 40)];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.textColor = [UIColor whiteColor];
        _userNameLabel.textAlignment = NSTextAlignmentCenter;
        _userNameLabel.font = [UIFont systemFontOfSize:18];
    }
    return _userNameLabel;
}

- (UIView *)containerView{
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 128)];
        [_containerView addSubview:self.avatarImageView];
        [_containerView addSubview:self.userNameLabel];
    }
    return _containerView;
}

#pragma mark - Privte Method
- (void)configureNaivBar{
    [self.navigationBar setTitle:@"个人中心"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40 , 44)];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"profile_setting"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftBarItem = button;
    
    button = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40, 20, 40 , 44)];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"profile_cart"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarItem = button;
}

- (void)loadConent{
    __weak typeof(self) weakSelf = self;
    NSString *userId = [[[ZHAuthorizationVC shareInstance] authManager] userId];
    [self.profileModel loadDataWithUserId:userId completionBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.tableView reloadData];
            [weakSelf.avatarImageView setImageWithUrlString:weakSelf.profileModel.userAvatar placeholderImage:[[DRImagePlaceholderHelper sharedInstance]placerholderAvatarWithSize:weakSelf.avatarImageView.size] ];
            [weakSelf.userNameLabel setText:weakSelf.profileModel.userName];
        }
    }];
}

#pragma mark - Event Handler
- (void)leftItemPressed:(id)sender{
    [[MessageCenter instance]performActionWithUserInfo:@{@"controller": @"ZHSettingVC"}];
}

- (void)rightItemPressed:(id)sender{
    //TODO: cart
//    NSLog(@">>>>%@",NSStringFromSelector(_cmd));
    [[MessageCenter instance]performActionWithUserInfo:@{@"controller": @"ZHShoppingChartVC"}];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==0) {
        switch (indexPath.row) {
            case 0:
            {
                static NSString *CellIdentifier = @"kTableViewCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil){
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height-0.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
                    view.backgroundColor = RGB(204, 204, 204);
                    [cell.contentView addSubview:view];
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"全部订单";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
                break;
            case 1:
                
                [self.orderTableViewCell.waitPayLabel setBadegeCount:self.profileModel.waitPayCount];
                [self.orderTableViewCell.waitDeliverLabel setBadegeCount:self.profileModel.deliverCount];
                [self.orderTableViewCell.waitReceiveLabel setBadegeCount:self.profileModel.comfirmShoppingCount];
                [self.orderTableViewCell.waitCommentLabel setBadegeCount:self.profileModel.waitCommentCount];
                [self.orderTableViewCell.orderServiceLabel setBadegeCount:@"51"];
                return self.orderTableViewCell;
                break;
            default:
                break;
        }
    }
    else {
        static NSString *CellIdentifier = @"kImageTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12, cell.bounds.size.height-0.5, [UIScreen mainScreen].bounds.size.width -24, 0.5)];
            view.backgroundColor = RGB(204, 204, 204);
            [cell.contentView addSubview:view];
        }
        cell.textLabel.text = @"我的作品";
        cell.imageView.image = [UIImage imageNamed:@"profile_favorites"];
        return cell;
    }
    return nil;
}


#pragma mark -  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //TBHomePageOneSectionData* sectionItem;
    if (indexPath.section ==0 && indexPath.row == 1) {
        return 60.0;
    }
    else {
        return 44.0;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = RGB(234, 234, 234);
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@">>>>>didSelectRowAtIndexPath %@",indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section ==0 && (indexPath.row >=0 && indexPath.row <= 1)) {
        ZHOrderListVC *orderListVC = [[ZHOrderListVC alloc] init];
        NavigationViewController*   navi = [MemoryStorage valueForKey:k_NAVIGATIONCTL];
        [navi pushViewController:orderListVC animation:ANIMATE_TYPE_DEFAULT];
    } else if (indexPath.section ==1 && indexPath.row ==0){
        ZHProductsVC *productsVC = [[ZHProductsVC alloc] init];
        NavigationViewController*   navi = [MemoryStorage valueForKey:k_NAVIGATIONCTL];
        [navi pushViewController:productsVC animation:ANIMATE_TYPE_DEFAULT];
    }
}


@end
