//
//  ZHOrderListVC.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-13.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHOrderListVC.h"
#import "HMSegmentedControl.h"
#import "ZHOrderModel.h"
#import "ZHOrderStatusCell.h"
#import "ZHOrderProductCell.h"
#import "ZHOrderSummaryCell.h"
#import "PayHelper.h"

@interface ZHOrderListVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)HMSegmentedControl *segmentedControl;
@property(nonatomic, strong)UITableView          *tableView;
@property(nonatomic, strong)ZHOrderModel         *orderModel;
@property(nonatomic, assign)ZHOrderType           currentOrderType;

@end

@implementation ZHOrderListVC

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
    self.currentOrderType = ZHOrderTypeAll;
    [self configureNaivBar];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = RGB(234, 234, 234);
    [self loadAllContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter & Setter
- (HMSegmentedControl *)segmentedControl{
    if (_segmentedControl == nil) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部",@"待付款", @"待发货", @"待收货"]];
        _segmentedControl.frame = CGRectMake(0, 64,[UIScreen mainScreen].bounds.size.width, 44);
        _segmentedControl.font = [UIFont systemFontOfSize:14.0];
        _segmentedControl.selectedTextColor = RGB(102, 170, 0);
        _segmentedControl.selectionIndicatorColor = RGB(102, 170, 0);
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        [_segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.contentBounds.origin.y + 44, self.contentBounds.size.width, self.contentBounds.size.height-44)];
        //_tableView.clipsToBounds = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(234, 234, 234);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

- (ZHOrderModel *)orderModel{
    if (_orderModel == nil) {
        _orderModel = [[ZHOrderModel alloc] init];
    }
    return _orderModel;
}


#pragma mark - Private Method

- (void)loadAllContent{
    __weak typeof(self) weakSelf = self;
    [self.orderModel loadDataWithType:self.currentOrderType completionBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.tableView reloadData];
        }
    }];
}

- (void)configureNaivBar{
    [self.navigationBar setTitle:@"我的订单"];
    //default back
    [self whithNavigationBarStyle];
}

- (void)addActionButtonWithCell:(UITableViewCell*)cell orderInfo:(ZHOrderInfo*)orderInfo{
    
    [cell.contentView removeAllSubviews];
    switch (self.currentOrderType) {
        case ZHOrderTypeAll:
        {
            __weak __typeof(self) weakSelf = self;
            ZHButton *button = [ZHButton buttonWithType:ZHButtonTypeDefault text:@"删除订单"  clickedBlock:^(ZHButton *button) {
                [weakSelf.orderModel modifyOrderStatusWithOrderId:orderInfo.orderId operation:@"4" completionBlock:^(BOOL isSuccess) {
                    if (isSuccess) {
                        ZHALERTVIEW(nil,@"删除订单成功。",nil, @"确定" ,nil,nil);
                        [weakSelf loadAllContent];
                    } else {
                        ZHALERTVIEW(nil,@"删除订单失败，请稍后再试。",nil, @"确定" ,nil,nil);
                    }
                }];
            }];
            [button setFrame:CGRectMake(cell.size.width - 80 -12, 8, 80, 28)];
            [cell.contentView addSubview:button];
        }
            break;
        case ZHOrderTypeWaitPay:
        {
            ZHButton *button = [ZHButton buttonWithType:ZHButtonTypeStyle1 text:@"付款"  clickedBlock:^(ZHButton *button) {
                if ([orderInfo.totalPrice length] >0 && [orderInfo.orderId length] >0) {
                    [PayHelper aliPayWithTitle:@"放心粮支付"
                                   productInfo:@"放心粮订单"
                                    totalPrice:orderInfo.totalPrice
                                       orderId:orderInfo.orderId];
                } else {
                    [FEToastView showWithTitle:@"支付出错" animation:YES interval:2.0];
                }
            }];
            [button setFrame:CGRectMake(cell.size.width - 60 -12, 8, 60, 28)];
            [cell.contentView addSubview:button];
            
            __weak __typeof(self) weakSelf = self;
            button = [ZHButton buttonWithType:ZHButtonTypeDefault text:@"删除订单"  clickedBlock:^(ZHButton *button) {
            [weakSelf.orderModel modifyOrderStatusWithOrderId:orderInfo.orderId operation:@"4" completionBlock:^(BOOL isSuccess) {
                    if (isSuccess) {
                        ZHALERTVIEW(nil,@"删除订单成功。",nil, @"确定" ,nil,nil);
                        [weakSelf loadAllContent];
                    } else {
                        ZHALERTVIEW(nil,@"删除订单失败，请稍后再试。",nil, @"确定" ,nil,nil);
                    }
                }];
            }];
            [button setFrame:CGRectMake(cell.size.width - 60 - 80 -24, 8, 80, 28)];
            [cell.contentView addSubview:button];
            
        }
            break;
        case ZHOrderTypeWaitDeliver:
        {
            __weak __typeof(self) weakSelf = self;
            ZHButton *button = [ZHButton buttonWithType:ZHButtonTypeDefault text:@"提醒发货"  clickedBlock:^(ZHButton *button) {
                [weakSelf.orderModel modifyOrderStatusWithOrderId:orderInfo.orderId operation:@"2" completionBlock:^(BOOL isSuccess) {
                    if (isSuccess) {
                        ZHALERTVIEW(nil,@"提醒发货成功。",nil, @"确定" ,nil,nil);
                        [weakSelf loadAllContent];
                    } else {
                        ZHALERTVIEW(nil,@"提醒发货失败，请稍后再试。",nil, @"确定" ,nil,nil);
                    }
                } ];
            }];
            [button setFrame:CGRectMake(cell.size.width - 80 -12, 8, 80, 28)];
            [cell.contentView addSubview:button];
        }
            break;
        case ZHOrderTypeWaitReceive:
        {
            __weak __typeof(self) weakSelf = self;
            ZHButton *button = [ZHButton buttonWithType:ZHButtonTypeStyle1 text:@"确认收货"  clickedBlock:^(ZHButton *button) {
                [weakSelf.orderModel modifyOrderStatusWithOrderId:orderInfo.orderId operation:@"6" completionBlock:^(BOOL isSuccess) {
                    if (isSuccess) {
                        ZHALERTVIEW(nil,@"确认收货成功。",nil, @"确定" ,nil,nil);
                        [weakSelf loadAllContent];
                    } else {
                        ZHALERTVIEW(nil,@"确认收货失败，请稍后再试。",nil, @"确定" ,nil,nil);
                    }
                } ];
            }];
            [button setFrame:CGRectMake(cell.size.width - 80 -12, 8, 80, 28)];
            [cell.contentView addSubview:button];
            
            /*
            button = [ZHButton buttonWithType:ZHButtonTypeDefault text:@"查看物流"  clickedBlock:^(ZHButton *button) {
                NSLog(@">>>>>xxxAction %@",button);
            }];
            [button setFrame:CGRectMake(cell.size.width - 80 - 80 -24, 8, 80, 28)];
            [cell.contentView addSubview:button];
            
            
            button = [ZHButton buttonWithType:ZHButtonTypeDefault text:@"延迟收货"  clickedBlock:^(ZHButton *button) {
                NSLog(@">>>>>xxxAction %@",button);
            }];
            [button setFrame:CGRectMake(cell.size.width -80 - 80 - 80 -36, 8, 80, 28)];
            [cell.contentView addSubview:button];
            */
        }
            break;
        case ZHOrderTypeWaitComment:
        {
            ZHButton *button = [ZHButton buttonWithType:ZHButtonTypeStyle1 text:@"评价订单"  clickedBlock:^(ZHButton *button) {
                NSLog(@">>>>>xxxAction %@",button);
            }];
            [button setFrame:CGRectMake(cell.size.width - 80 -12, 8, 80, 28)];
            [cell.contentView addSubview:button];
            
            button = [ZHButton buttonWithType:ZHButtonTypeDefault text:@"删除订单"  clickedBlock:^(ZHButton *button) {
                NSLog(@">>>>>xxxAction %@",button);
            }];
            [button setFrame:CGRectMake(cell.size.width - 80 - 80 -24, 8, 80, 28)];
            [cell.contentView addSubview:button];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Event Handler
- (void)segmentedControlChangedValue:(HMSegmentedControl*)segmentedControl{
    self.currentOrderType = segmentedControl.selectedSegmentIndex;
    [self.orderModel loadDataWithType:self.currentOrderType completionBlock:^(BOOL isSuccess) {
        [self.tableView reloadData];
    }];
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.orderModel orderLists] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger items = self.currentOrderType == ZHOrderTypeWaitPay || self.currentOrderType == ZHOrderTypeWaitReceive;
    return [[[[self.orderModel orderLists] objectAtIndex:section] productLists] count] + 2 + items;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    NSInteger rowCount = [[[[self.orderModel orderLists] objectAtIndex:indexPath.section] productLists] count] + 3;
    ZHOrderInfo *orderInfo = [self.orderModel.orderLists objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"kOrderStatusTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil){
                cell = [ZHOrderStatusCell tableViewCell];
            }
            ZHOrderStatusCell *statusCell = (ZHOrderStatusCell*)cell;
            statusCell.statusLabel.text = orderInfo.orderStatus;
            statusCell.dateLabel.text   = orderInfo.orderTime;
        }
    else if (indexPath.row < (rowCount -2 )){
            static NSString *CellIdentifier = @"kOrderProductsTableViewCell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil){
                cell = [ZHOrderProductCell tableViewCell];
            }
            ZHOrderProduct *product = [orderInfo.productLists objectAtIndex:indexPath.row - 1];
            ZHOrderProductCell *productCell = (ZHOrderProductCell*)cell;
            [productCell.productImageView setImageWithUrlString:product.imageURL];
            [productCell.titleLabel     setText:product.title];
            [productCell.subTitleLabel  setText:product.skuInfo];
            [productCell.priceLabel     setText:product.promotionPrice];
            productCell.countLabel.text = [NSString stringWithFormat:@"× %@",product.buyCount];
        }
    else if (indexPath.row == (rowCount -2)){
        static NSString *CellIdentifier = @"kOrderSummaryTableViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [ZHOrderSummaryCell tableViewCell];
        }
        ZHOrderSummaryCell *statusCell = (ZHOrderSummaryCell*)cell;
        statusCell.orderCountLabel.text = [NSString stringWithFormat:@"共%@件商品" ,orderInfo.productCount];
        statusCell.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %@",orderInfo.totalPrice];
    }
    else {
        static NSString *CellIdentifier = @"kActionTableViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [self addActionButtonWithCell:cell orderInfo:orderInfo];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark -  UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger rowCount = [[[[self.orderModel orderLists] objectAtIndex:indexPath.section] productLists] count] + 3;
    if (indexPath.row == 0) {
        return [ZHOrderStatusCell height];
    }//summary
    else if (indexPath.row == (rowCount - 2)){
        return [ZHOrderSummaryCell height];
    }//last
    else if (indexPath.row == (rowCount - 1)){
        return 44.0;
    } else {
        return [ZHOrderProductCell height];
    }
    return 0.0;
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 1){
        return 12.0;
    }
    if (section == 2){
        return [ZHDetailProductHeadView height];
    }
    if (section == 3) {
        return 48.0;//placeHolder
    }
    
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = self.backColor;
        return view;
    }
    if (section == 2) {
        return [ZHDetailProductHeadView headView];
    }
    return nil;
}
*/

 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@">>>>>didSelectRowAtIndexPath %@",indexPath);
}
@end
