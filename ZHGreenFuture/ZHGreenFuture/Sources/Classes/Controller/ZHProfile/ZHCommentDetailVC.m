//
//  ZHCommentDetailVC.m
//  ZHGreenFuture
//
//  Created by admin on 14-12-16.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHCommentDetailVC.h"
#import "ZHOrderProductCell.h"
#import "ZHCommentDetailCell.h"
#import "UITableView+FEAutoResizeKeyboard.h"
#import "UIView+FEAutoResizeKeyboard.h"


@interface ZHCommentDetailVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView          *tableView;
@property(nonatomic, assign)BOOL isAnonymous;
@property(nonatomic, strong)ZHCommentDetailCell *commentCell;
@end

@implementation ZHCommentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNaivBar];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = RGB(234, 234, 234);
    [self.tableView setAutoResizeKeyboard:YES willShow:nil willHide:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Privte Method
- (void)configureNaivBar{
    [self.navigationBar setTitle:@"评价订单"];
    //default back
    [self whithNavigationBarStyle];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 40, 20, 40 , 44)];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor colorWithRed:90/255.0 green:179/255.0 blue:25/255.0 alpha:1.0] forState:UIControlStateNormal];
    [button setTitle:@"发布" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarItem = button;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contentBounds.origin.y , self.contentBounds.size.width, self.contentBounds.size.height)];
        //_tableView.clipsToBounds = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(234, 234, 234);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

- (void)switchPressed:(UISwitch*)sw{
    self.isAnonymous = sw.on;
    
}

- (void)rightItemPressed:(UIButton*)button{

    NSString *content = self.commentCell.inputTextView.text;
    if ([content length] >0) {
        [self.commentCell.inputTextView resignFirstResponder];
        NSString* userId= [ZHAuthorizationManager shareInstance].userId;
        ZHOrderProduct *product  = [self.orderInfo.productLists objectAtIndex:0];
        [self.orderInfo commentWithUserID:userId orderID:self.orderInfo.orderId productID:product.productId evaluateStatus:self.commentCell.commentType conent:content    anonymous:self.isAnonymous completionBlock:^(BOOL isSuccess) {
            if (isSuccess) {
                [FEToastView showWithTitle:@"评价成功。" animation:YES interval:1.0];
                NavigationViewController*   navi = [MemoryStorage valueForKey:k_NAVIGATIONCTL];
                [navi popWithAnimation:YES];
            } else {
                [FEToastView showWithTitle:@"评价失败。" animation:YES interval:1.0];
            }
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [[self.orderInfo productLists] count] + 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    ZHOrderInfo *orderInfo = self.orderInfo;
    if (indexPath.section == 0 ) {
        if (indexPath.row < [[self.orderInfo productLists] count]) {
            static NSString *CellIdentifier = @"kOrderProductsTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil){
                cell = [ZHOrderProductCell tableViewCell];
            }
            ZHOrderProduct *product = [orderInfo.productLists objectAtIndex:indexPath.row ];
            ZHOrderProductCell *productCell = (ZHOrderProductCell*)cell;
            [productCell.productImageView setImageWithUrlString:product.imageURL];
            [productCell.titleLabel     setText:product.title];
            [productCell.subTitleLabel  setText:product.skuInfo];
            [productCell.priceLabel     setText:product.promotionPrice];
            productCell.countLabel.text = [NSString stringWithFormat:@"× %@",product.buyCount];
        } else {
            static NSString *CellIdentifier = @"kOrderCommentTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil){
                cell = [ZHCommentDetailCell tableViewCell];
            }
            self.commentCell = (ZHCommentDetailCell*)cell;
            self.commentCell.inputTextView.text = @"";
        }
        
    }
    else if (indexPath.section == 1){
        static NSString *CellIdentifier = @"kTableViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 160, 44)];
            label.text = @"匿名评价";
            label.font = [UIFont systemFontOfSize:14.0];
            [cell.contentView addSubview:label];
            
            UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(cell.frame.size.width -80, 10, 60, 30)];
            sw.on = YES;
            self.isAnonymous = YES;
            [sw addTarget:self action:@selector(switchPressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:sw];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -  UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row < [[self.orderInfo productLists] count]) {
            return [ZHOrderProductCell height];
        } else {
            return [ZHCommentDetailCell height];
        }
    }//summary
    else {
        return 44.0;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 ){
        return 12.0;
    }
    if (section == 2){
        return 12.0;
    }
    
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
