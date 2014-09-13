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
    [self configureNaivBar];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = RGB(234, 234, 234);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter & Setter
- (HMSegmentedControl *)segmentedControl{
    if (_segmentedControl == nil) {
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"全部",@"待付款", @"待发货", @"待收货",@"待评价"]];
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
- (void)configureNaivBar{
    [self.navigationBar setTitle:@"我的订单"];
    //default back
    [self whithNavigationBarStyle];
}

- (UITableViewCell*)orderStatusTableViewCellWith:(NSString*)date status:(NSString*)status{
    static NSString *CellIdentifier = @"kOrderStatusTableViewCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //2014-08-07 09:10
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, cell.size.width, 160)];
        dateLabel.font = [UIFont systemFontOfSize:12.0];
        dateLabel.textColor = RGB(70, 70, 70);
        dateLabel.tag  =0x81;
        [cell.contentView addSubview:dateLabel];
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, cell.size.width, 160)];
        statusLabel.font = [UIFont systemFontOfSize:14.0];
        statusLabel.textColor = RGB(102, 160, 0);
        statusLabel.tag  =0x82;
        [cell.contentView addSubview:statusLabel];
    }
    UILabel *dateLabel = (UILabel*)[cell.contentView viewWithTag:0x81];
    dateLabel.text = date;
    UILabel *statusLabel = (UILabel*)[cell.contentView viewWithTag:0x82];
    statusLabel.text = status;
    return cell;
}



- (UITableViewCell*)orderSummaryTableViewCellWithProductCount:(NSString*)count totalValue:(NSString*)totalValue{
    static NSString *CellIdentifier = @"kOrderSummaryTableViewCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //共几件
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, cell.size.width, 160)];
        dateLabel.font = [UIFont systemFontOfSize:12.0];
        dateLabel.textColor = RGB(70, 70, 70);
        dateLabel.tag  =0x81;
        [cell.contentView addSubview:dateLabel];
        
    
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, cell.size.width, 160)];
        statusLabel.font = [UIFont systemFontOfSize:14.0];
        statusLabel.textColor = RGB(102, 160, 0);
        statusLabel.tag  =0x82;
        [cell.contentView addSubview:statusLabel];
    }
//    UILabel *dateLabel = (UILabel*)[cell.contentView viewWithTag:0x81];
//    dateLabel.text = date;
//    UILabel *statusLabel = (UILabel*)[cell.contentView viewWithTag:0x82];
//    statusLabel.text = status;
    return cell;
}


#pragma mark - Event Handler
- (void)segmentedControlChangedValue:(HMSegmentedControl*)segmentedControl{
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.orderModel orderLists] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [((ZHOrderInfo*)[self.orderModel orderLists]).productLists count] + 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    NSInteger rowCount =  [((ZHOrderInfo*)[self.orderModel orderLists]).productLists count] + 3;
    ZHOrderInfo *orderInfo = [self.orderModel.orderLists objectAtIndex:indexPath.section];
    if (indexPath.section ==0) {
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
                [productCell.productImageView setImageWithUrl:[NSURL URLWithString:product.imageURL] placeHodlerImage:[UIImage imageNamed:@"orderProduct"]];
                [productCell.titleLabel     setText:product.title];
                [productCell.subTitleLabel  setText:product.skuInfo];
                [productCell.priceLabel     setText:product.promotionPrice];
                [productCell.countLabel     setText:product.buyCount];
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
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil){
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
        }
    }
    return cell;
}


#pragma mark -  UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //TBHomePageOneSectionData* sectionItem;
    if (indexPath.section ==0) {
        NSInteger rowCount =  [((ZHOrderInfo*)[self.orderModel orderLists]).productLists count] + 3;
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
