//
//  ZHConfirmOrderVC.m
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHConfirmOrderVC.h"
#import "ZHShoppingChartCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "ZHInsetTextField.h"
#import "AddressModel.h"
#import "ZHAddressManagerVC.h"

@interface ZHConfirmOrderVC ()<UITableViewDataSource,UITableViewDelegate,ZHAddressManagerDelegate>

@property (nonatomic,strong) TPKeyboardAvoidingTableView*   confiemOrderTable;
@property (nonatomic,strong) UITableViewCell*               addressView;

@property (nonatomic,strong) AddressModel*                  addressModel;
@property (nonatomic,strong) UIView*                        noAddressStyleView;
@property (nonatomic,strong) UIView*                        addressStyleView;

@property (nonatomic,strong) UIView*                        toolBar;
@property (nonatomic,strong) UIButton*                      checkOut;
@property (nonatomic,strong) UILabel*                       total;
@property (nonatomic,strong) ZHInsetTextField*              note;
@property (nonatomic,strong) NSString*                      orderId;
@end

@implementation ZHConfirmOrderVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyAction:) name:NOTIFY_TRADE_SUCCESS object:nil];
    [self loadContent];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    /// 重新加载地址数据
    [self.confiemOrderTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadContent{
    self.view.backgroundColor = WHITE_BACKGROUND;
    
    if ([self.userInfo isKindOfClass:[ConfirmOrderModel class]]){
        self.orderModel = self.userInfo;
    }
    
    if (self.orderModel.receiveInfo){
        self.addressModel = self.orderModel.receiveInfo;
    }
    else{
        self.addressModel = [[ZHAddressManager instance]defaultAddress];
    }

    self.navigationBar.title = @"确认订单";
    [self whithNavigationBarStyle];
    
    [self.view addSubview:self.confiemOrderTable];
    [self.view addSubview:self.toolBar];
}

-(TPKeyboardAvoidingTableView *)confiemOrderTable{
    
    if (!_confiemOrderTable){
        _confiemOrderTable = [[TPKeyboardAvoidingTableView alloc]initWithFrame:self.contentBounds];
        _confiemOrderTable.showsVerticalScrollIndicator = NO;
        _confiemOrderTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _confiemOrderTable.delegate = self;
        _confiemOrderTable.dataSource = self;
        _confiemOrderTable.height -= TAB_BAR_HEIGHT;
    }
    
    return _confiemOrderTable;
}

-(UIView *)toolBar{
    
    if (!_toolBar){
        _toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-TAB_BAR_HEIGHT, self.view.width, TAB_BAR_HEIGHT)];
        _toolBar.backgroundColor = GRAY_LINE;
        
        [_toolBar addSubview:self.checkOut];
        [_toolBar addSubview:self.total];
    }
    
    return _toolBar;
}

-(UILabel *)total{
    if (!_total){
        _total  =[UILabel labelWithText:@"" font:FONT(16) color:GREEN_COLOR textAlignment:NSTextAlignmentLeft];
        _total.frame = CGRectMake(10, 0, 200, TAB_BAR_HEIGHT);
        
//        CGFloat totalMoney = 0.0f;
//        for (ShoppingChartModel* model  in self.model.shoppingList) {
//            totalMoney += [model.promotionPrice floatValue]*[model.buyCout intValue];
//        }
//        
//        _total.text = [NSString stringWithFormat:@"合计：￥%.2f",totalMoney];
    }
    _total.text = [NSString stringWithFormat:@"合计：￥%@",self.orderModel.totalPrice];
    return _total;
}


-(UIButton *)checkOut{
    
    if (!_checkOut){
        _checkOut = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-90, 0, 90, TAB_BAR_HEIGHT)];
        [_checkOut setTitleColor:WHITE_TEXT forState:UIControlStateNormal];
        _checkOut.titleLabel.font = FONT(16);

        [self.checkOut setTitle:@"去结算" forState:UIControlStateNormal];
        self.checkOut.backgroundColor = GREEN_COLOR;
        
        [_checkOut addTarget:self action:@selector(checkOutAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _checkOut;
}


-(UIView *)noAddressStyleView{
    
    if (!_noAddressStyleView){
        _noAddressStyleView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
        
        UIButton* location = [[UIButton alloc]initWithFrame:CGRectMake(10, 16, 14, 18)];
        [location setImage:[UIImage themeImageNamed:@"btn_location"] forState:UIControlStateNormal];
        [_noAddressStyleView addSubview:location];
        
        UIButton* makSure = [[UIButton alloc]initWithFrame:CGRectMake(location.right+10, location.top, 120, location.height)];
        [makSure setTitle:@"请填写收货地址" forState:UIControlStateNormal];
        [makSure setTitleColor:BLACK_TEXT forState:UIControlStateNormal];
        makSure.titleLabel.font = FONT(16);
        makSure.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_noAddressStyleView addSubview:makSure];
        
        UIButton* more = [[UIButton alloc]initWithFrame:CGRectMake(_noAddressStyleView.width-28, 16, 18, 18)];
        [more setImage:[UIImage themeImageNamed:@"detailMore"] forState:UIControlStateNormal];
        [_noAddressStyleView addSubview:more];
        
        UIControl* _mask = [[UIControl alloc]initWithFrame:_noAddressStyleView.bounds];
        [_mask addTarget:self action:@selector(addressManagerPage) forControlEvents:UIControlEventTouchUpInside];
        [_noAddressStyleView addSubview:_mask];
    }
    
    return _noAddressStyleView;
}

-(UIView *)addressStyleView{
    
    if (!_addressStyleView){
        _addressStyleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
        
        UILabel* label = [UILabel labelWithText:@"收件人：" font:FONT(14) color:BLACK_TEXT textAlignment:NSTextAlignmentLeft];
        label.frame = CGRectMake(10, 10, 60, 20);
        [_addressStyleView addSubview:label];
        
        UILabel* name = [UILabel labelWithText:@"" font:FONT(14) color:BLACK_TEXT textAlignment:NSTextAlignmentLeft];
        name.frame = CGRectMake(label.right, label.top, 200, 20);
        [_addressStyleView addSubview:name];
        name.tag = -100;
        
        label = [UILabel labelWithText:@"手机号：" font:FONT(14) color:BLACK_TEXT textAlignment:NSTextAlignmentLeft];
        label.frame = CGRectMake(10, 30, 60, 20);
        [_addressStyleView addSubview:label];
        
        UILabel* phone = [UILabel labelWithText:@"" font:FONT(14) color:BLACK_TEXT textAlignment:NSTextAlignmentLeft];
        phone.frame = CGRectMake(label.right, label.top, 200, 20);
        [_addressStyleView addSubview:phone];
        phone.tag = -101;
        
        label = [UILabel labelWithText:@"收货地址：" font:FONT(14) color:BLACK_TEXT textAlignment:NSTextAlignmentLeft];
        label.frame = CGRectMake(10, 50, 60, 20);
        [_addressStyleView addSubview:label];
        
        UILabel* address = [UILabel labelWithText:@"" font:FONT(14) color:BLACK_TEXT textAlignment:NSTextAlignmentLeft];
        address.frame = CGRectMake(label.right, label.top, self.view.width-label.width-20, 20);
        [_addressStyleView addSubview:address];
        address.tag = -102;
        
        UIButton* more = [[UIButton alloc]initWithFrame:CGRectMake(_addressStyleView.width-28, (_addressStyleView.height-18)/2, 18, 18)];
        [more setImage:[UIImage themeImageNamed:@"detailMore"] forState:UIControlStateNormal];
        [_addressStyleView addSubview:more];
        
        UIControl* _mask = [[UIControl alloc]initWithFrame:_addressStyleView.bounds];
        [_mask addTarget:self action:@selector(addressManagerPage) forControlEvents:UIControlEventTouchUpInside];
        [_addressStyleView addSubview:_mask];
    }
    
    if (self.addressModel){
        UILabel* name = (UILabel*)[_addressStyleView viewWithTag:-100];
        name.text = self.addressModel.name;
        
        UILabel* phone = (UILabel*)[_addressStyleView viewWithTag:-101];
        phone.text = self.addressModel.phone;
        
        UILabel* address = (UILabel*)[_addressStyleView viewWithTag:-102];
        address.text = self.addressModel.address;
    }
    
    return _addressStyleView;
}


-(UITableViewCell *)addressView{
    
    if (!_addressView){
        _addressView = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCell"];
    }

    [_addressView.contentView removeAllSubviews];
    
    if (!self.addressModel){
        _addressView.height = self.noAddressStyleView.height;
        [_addressView.contentView addSubview:self.noAddressStyleView];
    }
    else{
        _addressView.height = self.addressStyleView.height;
        [_addressView.contentView addSubview:self.addressStyleView];
    }
    
    return _addressView;
}

#pragma -mark
#pragma -mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (0 != section){
        return self.orderModel.shoppingList.count+4;
    }
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = nil;
    
    if (0 == indexPath.section){
        cell = self.addressView;
    }
    else if(indexPath.row < self.orderModel.shoppingList.count){
        cell = [self charCellAtIndex:indexPath];
    }
    else if (indexPath.row < self.orderModel.shoppingList.count+3){
        cell = [self otherCellAtIndex:[NSIndexPath indexPathForRow:indexPath.row-self.orderModel.shoppingList.count inSection:indexPath.section]];
    }
    else{
        cell = [self noteCellAtIndex:indexPath];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.section){
        return self.addressView.height;
    }
    
    if(indexPath.row < self.orderModel.shoppingList.count){
        return [ZHShoppingChartCell cellHeight];
    }
    else if (indexPath.row < self.orderModel.shoppingList.count+3){
        return 40;
    }
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,tableView.width, 10)];
    view.backgroundColor = GRAY_LINE;
    return view;
//    return [UIView]
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma -mark load cell
-(ZHShoppingChartCell*)charCellAtIndex:(NSIndexPath*)index {
    static NSString* identify = @"chartCell";
    
    ZHShoppingChartCell* cell = [self.confiemOrderTable dequeueReusableCellWithIdentifier:identify];
    if (!cell){
        cell = [[ZHShoppingChartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.showCheckBox = NO;
    }
    
    if (index.row < self.orderModel.shoppingList.count){
        cell.model = self.orderModel.shoppingList[index.row];
    }
    
    return cell;
}

-(UITableViewCell*)otherCellAtIndex:(NSIndexPath*)index{
    UITableViewCell* cell = [self.confiemOrderTable dequeueReusableCellWithIdentifier:@"otherCell"];
    
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherCell"];
        UILabel* label = [UILabel labelWithText:@"" font:FONT(14) color:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft];
        label.frame = CGRectMake(10, 0, 100, 40);
        label.tag = -101;
        
        [cell addSubview:label];
        
        UILabel*    desc = [UILabel labelWithText:@"" font:FONT(14) color:GREEN_COLOR textAlignment:NSTextAlignmentRight];
        desc.frame = CGRectMake(0, 0, self.confiemOrderTable.width-10, 40);
        desc.tag = -102;
        
        [cell addSubview:desc];
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(10, 39, cell.width-20, 1)];
        line.backgroundColor = GRAY_LINE;
        [cell addSubview:line];
        
    }
    
    UILabel* label = (UILabel*)[cell viewWithTag:-101];
    UILabel* desc = (UILabel*)[cell viewWithTag:-102];
    
    if (0 ==index.row){
        label.text = @"商品总价：";
        desc.text = [NSString stringWithFormat:@"￥%@",self.orderModel.productTotalPrice];
//        desc.text = @"￥19.89";
    }
    else if (1 == index.row){
        label.text = @"运费：";
        desc.text = self.orderModel.express;
//        desc.text = @"全国包邮";
    }
    else{
        label.text = @"优惠：";
        desc.text = [NSString stringWithFormat:@"￥%@",self.orderModel.reducePrice];
//        desc.text = @"-￥7.89";
    }
    
    return cell;
}

-(UITableViewCell*)noteCellAtIndex:(NSIndexPath*)index{
    UITableViewCell* cell = [self.confiemOrderTable dequeueReusableCellWithIdentifier:@"noteCell"];
    
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noteCell"];
        
        ZHInsetTextField* note = [[ZHInsetTextField alloc]initWithFrame:CGRectMake(10, 10, self.confiemOrderTable.width-20, 40)];
        note.layer.borderColor = GRAY_LINE.CGColor;
        note.layer.borderWidth = 1;
        note.layer.cornerRadius = 3;
        note.layer.masksToBounds = YES;
        note.font = FONT(14);
        note.placeholder = @"给卖家留言...";
        note.backgroundColor = RGB(238, 238, 238);
        self.note = note;
//        note.tag = -103;
        
        [cell addSubview:note];
    }
    
    return cell;
}

#pragma -mark Adress Manager
-(void)addressManagerPage{
    [[MessageCenter instance]performActionWithUserInfo:@{@"controller":@"ZHAddressManagerVC",@"userinfo":self}];
}

#pragma -mark checkOutAction
-(void)checkOutAction{
    if (!self.addressModel){
        ALERT_MESSAGE(@"请填写收货地址");
        return;
    }
    

    
    DoAlertView* alert = [[DoAlertView alloc]init];
    NSString* msg = [NSString stringWithFormat:@"确认支付金额\n%@",self.total.text];
    [alert doYesNo:msg yes:^(DoAlertView *alertView) {
        [self requestOrderId];
    } no:^(DoAlertView *alertView) {
        
    }];
}

-(void)requestOrderId{
    /// 留言
    NSString* comment = @"";
    if (!isEmptyString(self.note.text)){
        comment = self.note.text;
    }
    
    /// 购物车id列表异常
    NSMutableString* list = [[NSMutableString alloc]initWithString:@""];
    if (isEmptyString( self.orderModel.shoppingCartIdList)){
        for (ShoppingChartModel* model  in self.orderModel.shoppingList) {
            if (!isEmptyString(list)){
                [list appendString:@","];
            }
            
            [list appendString:model.shoppingChartId];
        }
    }
    else{
        [list appendString:self.orderModel.shoppingCartIdList];
    }
    
    NSDictionary* info = @{@"shoppingCartIdList":list,@"userId":[ZHAuthorizationManager shareInstance].userId,@"receiveId":self.addressModel.receiveId,@"scene":@"33",@"comment":comment};
    
    [HttpClient postDataWithParamers:info success:^(id responseObject) {
//#warning 服务端没有传 result字段，异常处理
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            if (responseObject[@"orderId"]){
                NSString* orderId = [NSString stringWithFormat:@"%d",[responseObject[@"orderId"]intValue]];
                FELOG(@"order id :%@",responseObject[@"orderId"]);
                self.orderId = orderId;
//                
//#warning 测试支付0.01元
//                    [PayHelper aliPayWithTitle:@"放心粮支付"
//                                   productInfo:@"放心粮订单"
//                                    totalPrice:@"0.01"
//                                       orderId:orderId];

                if ([self.orderModel.totalPrice floatValue] > 0.01 ){
                    [PayHelper aliPayWithTitle:@"放心粮支付"
                                   productInfo:@"放心粮订单"
                                    totalPrice:self.orderModel.totalPrice
                                       orderId:orderId];
                    
                }
            }
            else{
                SHOW_MESSAGE(@"订单生成失败", 2);
            }
        }
//        BaseModel* model = [BaseModel praserModelWithInfo:responseObject];
//        if ([model.state boolValue]){
//            NSString* orderId = [NSString stringWithFormat:@"%d",[responseObject[@"orderId"]intValue]];
//            
//            FELOG(@"order id :%@",orderId);
//            
//        }
//        else{
//            SHOW_MESSAGE(@"订单生成失败", 2);
//        }
    } failure:^(NSError *error) {
        SHOW_MESSAGE(@"订单生成失败", 2);
    }];
}

#pragma -mark selected address
-(void)selectedAtAddress:(AddressModel *)address{
    self.addressModel = address;
    
    [self.confiemOrderTable reloadData];
}

-(void)deleteAddress:(AddressModel *)address{
    if ([address.receiveId isEqualToString:self.addressModel.receiveId]){
        self.addressModel = [ZHAddressManager instance].defaultAddress;
    }
}

-(void)notifyAction:(NSNotification*)notify{
    /// 交易成功
    if (isEmptyString(self.orderId)){
        return;
    }
    NSDictionary* info = @{@"userId":[ZHAuthorizationManager shareInstance].userId,
                           @"orderId":self.orderId,
                           @"operation":@"2",
                           @"scene":@"22"};
    [HttpClient postDataWithParamers:info success:^(id responseObject) {
        BaseModel* model = [BaseModel praserModelWithInfo:responseObject];
        if ([model.state boolValue]){
            SHOW_MESSAGE(@"支付成功", 2);
        }
    } failure:^(NSError *error) {
        
    }];
}
@end
