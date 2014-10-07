//
//  ZHShoppingChartVC.m
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHShoppingChartVC.h"
#import "ShoppingChartModel.h"
#import "ZHShoppingChartCell.h"
#import "ZHCheckbox.h"
#import "JSON.h"
#import "ConfirmOrderModel.h"

@interface ZHShoppingChartVC ()<UITableViewDataSource,UITableViewDelegate,ZHShoppingChartDelegate>

@property (nonatomic,strong) UITableView*   chartTable;
@property (nonatomic,assign) BOOL           chartEditing;

@property (nonatomic,strong) UIView*        toolBar;
@property (nonatomic,strong) UIButton*      checkOut;
@property (nonatomic,strong) ZHCheckbox*    allSelect;

@property (nonatomic,strong) UILabel*       totalLabel;
@property (nonatomic,strong) UILabel*       totalSaveLabel;
//@property (nonatomic,assign) CGFloat        total;
//@property (nonatomic,assign) CGFloat        totalSave;

@property (nonatomic,strong) UILabel*       allSelectedLabel;
@property (nonatomic,strong) NSMutableArray*       shoppingChartLists;
@end

@implementation ZHShoppingChartVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadContent];
}

-(void)viewWillAppear:(BOOL)animated{
    [self resetMoney];
    
    [self loadRequest];
    /// 请求收货地址
    [ZHAddressManager instance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadRequest{
//#warning 用户ID
    if (isEmptyString([ZHAuthorizationManager shareInstance].userId)){
        return;
    }
    NSDictionary* param = @{@"scene":@"11",@"userId":[ZHAuthorizationManager shareInstance].userId};
    
    [HttpClient requestDataWithParamers:param success:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            if ([responseObject[@"shoppingCartList"] isKindOfClass:[NSArray class]]){
                NSArray *shoppingCartList = responseObject[@"shoppingCartList"];
                
                self.shoppingChartLists = [[NSMutableArray alloc]initWithCapacity:shoppingCartList.count];
                for (id val in shoppingCartList){
                    ShoppingChartModel* model = [ShoppingChartModel praserModelWithInfo:val];
                    if (model){
                        [self.shoppingChartLists addObject:model];
                    }
                }
                
                [self.chartTable reloadData];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)loadContent{
    
    self.navigationBar.title = @"购物车";
    
    UIButton* btn = [UIButton barItemWithTitle:@"编辑" action:self selector:@selector(editAction)];
    [btn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    [btn setTitleColor:GRAY_LINE forState:UIControlStateHighlighted];
    btn.width += 20;
    self.navigationBar.rightBarItem = btn;
    
    [self whithNavigationBarStyle];
    
    
    [self.view addSubview:self.chartTable];
    [self.view addSubview:self.toolBar];
    
    self.chartEditing = NO;
}

-(UITableView *)chartTable{
    if (!_chartTable){
        _chartTable = [[UITableView alloc]initWithFrame:self.contentBounds];
        _chartTable.backgroundColor = WHITE_BACKGROUND;
        _chartTable.showsVerticalScrollIndicator = NO;
        _chartTable.height -= TAB_BAR_HEIGHT;
        _chartTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _chartTable.delegate = self;
        _chartTable.dataSource = self;
    }
    return _chartTable;
}

-(UIView *)toolBar{
    
    if (!_toolBar){
        _toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-TAB_BAR_HEIGHT, self.view.width, TAB_BAR_HEIGHT)];
        _toolBar.backgroundColor = GRAY_LINE;
        
        [_toolBar addSubview:self.checkOut];
        [_toolBar addSubview:self.allSelect];
        
        [_toolBar addSubview:self.allSelectedLabel];
        [_toolBar addSubview:self.totalLabel];
        [_toolBar addSubview:self.totalSaveLabel];
    }
    
    return _toolBar;
}

-(UIButton *)checkOut{
    
    if (!_checkOut){
        _checkOut = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-90, 0, 90, TAB_BAR_HEIGHT)];
        [_checkOut setTitleColor:WHITE_TEXT forState:UIControlStateNormal];
        _checkOut.titleLabel.font = FONT(16);
        
        [_checkOut addTarget:self action:@selector(checkOutAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return _checkOut;
}

-(ZHCheckbox *)allSelect{
    
    if (!_allSelect){
        
        __block ZHShoppingChartVC* chart = self;
        
        _allSelect = [[ZHCheckbox alloc]initWithFrame:CGRectMake(10, (TAB_BAR_HEIGHT-20)/2, 20, 20)];
        [_allSelect setCheckBlock:^(BOOL checked) {
            FELOG(@"selected %d",checked);

            for (ShoppingChartModel* model in chart.shoppingChartLists){
                model.checked = checked;
            }
            
            [chart.chartTable reloadData];
            
        }];
    }
    
    return _allSelect;
}

-(UILabel *)totalLabel{
    
    if (!_totalLabel){
        _totalLabel = [UILabel labelWithText:@"合计：￥0.00" font:BOLD_FONT(14) color:GREEN_COLOR textAlignment:NSTextAlignmentLeft];
        _totalLabel.frame = CGRectMake(self.allSelect.right+10, 3, 150, TAB_BAR_HEIGHT/2);
        _totalLabel.hidden = YES;
    }
    
    return _totalLabel;
}

-(UILabel *)totalSaveLabel{
    
    if (!_totalSaveLabel){
        _totalSaveLabel = [UILabel labelWithText:@"为您节省￥0.00" font:FONT(11) color:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft];
        _totalSaveLabel.frame = CGRectMake(self.allSelect.right+10, TAB_BAR_HEIGHT/2-3, 150, TAB_BAR_HEIGHT/2);
        _totalSaveLabel.hidden = YES;
    }
    
    return _totalSaveLabel;
}

-(UILabel *)allSelectedLabel{
    
    if (!_allSelectedLabel){
        _allSelectedLabel = [UILabel labelWithText:@"全选" font:FONT(16) color:BLACK_TEXT textAlignment:NSTextAlignmentLeft];
        _allSelectedLabel.frame = CGRectMake(self.allSelect.right+10, 0, 150, TAB_BAR_HEIGHT);
        _allSelectedLabel.hidden = YES;
    }
    
    return _allSelectedLabel;
}

-(void)reloadToolBar{
    if (self.chartEditing){
        [self.checkOut setTitle:@"删除" forState:UIControlStateNormal];
        self.checkOut.backgroundColor = [UIColor redColor];
        
        self.allSelectedLabel.hidden = NO;
        self.totalSaveLabel.hidden = YES;
        self.totalLabel.hidden = YES;
    }
    else{
        [self.checkOut setTitle:@"去结算" forState:UIControlStateNormal];
        self.checkOut.backgroundColor = GREEN_COLOR;

        self.allSelectedLabel.hidden = YES;
        self.totalSaveLabel.hidden = NO;
        self.totalLabel.hidden = NO;
    }
}

-(void)setChartEditing:(BOOL)chartEditing{

    _chartEditing = chartEditing;
    
    if (chartEditing){
        [((UIButton*)self.navigationBar.rightBarItem)setTitle:@"完成" forState:UIControlStateNormal];
        
        self.chartTable.allowsSelectionDuringEditing = YES;
    }
    else{
        [((UIButton*)self.navigationBar.rightBarItem)setTitle:@"编辑" forState:UIControlStateNormal];
        self.chartTable.allowsSelectionDuringEditing = NO;
        
        [self submitUpdateAction];
    }
    
    [self resetMoney];
    
    [self reloadToolBar];
}

-(void)resetMoney{
    self.allSelect.checked = NO;
}

-(void)submitUpdateAction{
    NSMutableArray* arrayData = [[NSMutableArray alloc]initWithCapacity:self.shoppingChartLists.count];
    for (ShoppingChartModel* model in self.shoppingChartLists){
        if ([model.oldCount floatValue] > 0){
            if (isEmptyString(model.shoppingChartId) || isEmptyString(model.buyCout)){
                continue;
            }
            [arrayData addObject:@{@"shoppingCartId":model.shoppingChartId,@"number":model.buyCout}];
        }
    }
    
    if (arrayData.count <=0){
        return;
    }
    
//#warning 用户ID
    NSDictionary* dic = @{@"userId":[ZHAuthorizationManager shareInstance].userId,@"updateShoppingList":arrayData};
    
    NSString* jsonStr = [dic JSONFragment];
    dic = @{@"json":jsonStr,@"scene":@"12"};
    
    [HttpClient requestDataWithParamers:dic success:^(id responseObject) {
        BaseModel* model = [BaseModel praserModelWithInfo:responseObject];
        if ([model.state boolValue]){
            /// 更新成功
            for (ShoppingChartModel* data in self.shoppingChartLists){
                data.oldCount = @"-1";
            }
        }
        else{
            for (ShoppingChartModel* data in self.shoppingChartLists){
                data.buyCout = data.oldCount;
                data.oldCount = @"-1";
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma -mark edit action
-(void)editAction{
    self.chartEditing = !self.chartEditing;
}

#pragma -mark checkout action
-(void)checkOutAction{
    
    /// 删除
    if (self.chartEditing){
        NSMutableArray* selectedList = [[NSMutableArray alloc]initWithCapacity:self.shoppingChartLists.count];
        for (ShoppingChartModel* model in self.shoppingChartLists){
            if (model.checked){
                if (!isEmptyString(model.shoppingChartId)){
                    [selectedList addObject:model.shoppingChartId];
                }
            }
        }
        [self deleteWithIdList:selectedList];
    }
    /// 结算
    else{
        if (self.shoppingChartLists.count > 0){
            [self confirmOrderAction];
        }
    }
}

#pragma -mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shoppingChartLists.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZHShoppingChartCell cellHeight];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZHShoppingChartCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell){
        cell = [[ZHShoppingChartCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.delegate = self;
    }
    
    ShoppingChartModel* model = nil;
    if (indexPath.row < self.shoppingChartLists.count){
        model = self.shoppingChartLists[indexPath.row];
    }
    
    if (model){
        cell.model = model;
        cell.index = indexPath.row;
    }
    
    cell.chartEditing = self.chartEditing;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZHShoppingChartCell* cell = (ZHShoppingChartCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell){
        cell.checked = !cell.checked;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.chartEditing;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    
    if (indexPath.row >= self.shoppingChartLists.count){
        return;
    }
    
    ShoppingChartModel* model = self.shoppingChartLists[indexPath.row];
    [self deleteWithIdList:@[model.shoppingChartId]];
}

-(void)deleteWithIdList:(NSArray*)list{
    if (list.count <= 0){
        return;
    }
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]initWithCapacity:3];
//#warning 用户ID
//    [dic setObject:@"1" forKey:@"userId"];
    if (!isEmptyString([ZHAuthorizationManager shareInstance].userId)){
        [dic setObject:[ZHAuthorizationManager shareInstance].userId forKey:@"userId"];
    }
    
    [dic setObject:list forKey:@"deleteShoppingList"];
    NSString* str = [dic JSONFragment];
    
    [dic removeAllObjects];
    
    [dic setObject:str forKey:@"json"];
    [dic setObject:@"13" forKey:@"scene"];
    
    [HttpClient requestDataWithParamers:dic success:^(id responseObject) {
        BaseModel* model = [BaseModel praserModelWithInfo:responseObject];
        
        if ([model.state boolValue]){
            //            [self loadRequest];
            ALERT_MESSAGE(@"删除成功");
            [self performSelector:@selector(loadRequest) withObject:nil afterDelay:0.1];
        }
        else{
            ALERT_MESSAGE(@"删除购物车商品失败");
        }
        
    } failure:^(NSError *error) {
        ALERT_MESSAGE(@"删除购物车商品失败");
    }];
}

#pragma -mark ZHShoppingChartDelegate
-(void)selectChartWithModel:(ShoppingChartModel *)model{
    if (!model || self.chartEditing){
        return;
    }
    [self checkPrice];
//    [self totalWithPrice:[model.marketPrice floatValue] promotionPrice:[model.promotionPrice floatValue] count:[model.buyCout intValue]];
}

-(void)deSelectChartWithModel:(ShoppingChartModel *)model{
    if (!model || self.chartEditing){
        return;
    }
    [self checkPrice];
//    [self totalWithPrice:-[model.marketPrice floatValue] promotionPrice:-[model.promotionPrice floatValue] count:[model.buyCout intValue]];
}

-(void)checkPrice{
    CGFloat total = 0.0f;
    CGFloat totalSave = 0.0f;
    for (ShoppingChartModel* model in self.shoppingChartLists){
        if ([model isKindOfClass:[ShoppingChartModel class]] && model.checked){
            total += [model.promotionPrice floatValue]*[model.buyCout intValue];
            totalSave += [model.marketPrice floatValue]*[model.buyCout intValue]-[model.promotionPrice floatValue]*[model.buyCout intValue];
        }
    }
    
    self.totalLabel.text= [NSString stringWithFormat:@"合计：￥%.2f",total];;
    self.totalSaveLabel.text = [NSString stringWithFormat:@"为您节省￥%.2f",totalSave];

}

-(void)countChangeAtIndex:(NSInteger)index count:(NSString *)count{
    if (index < self.shoppingChartLists.count){
        ShoppingChartModel* model = self.shoppingChartLists[index];
        model.buyCout = count;
    }
}

-(void)confirmOrderAction{
    NSMutableArray* selectedList = [[NSMutableArray alloc]initWithCapacity:self.shoppingChartLists.count];
    for (ShoppingChartModel* model in self.shoppingChartLists){
        if (model.checked){
            [selectedList addObject:model];
        }
    }
    
    if (selectedList.count > 0){
        
        NSMutableString* list = [[NSMutableString alloc]init];
        for (ShoppingChartModel* model  in selectedList) {
            if (!isEmptyString(list)){
                [list appendString:@","];
            }
            
            [list appendString:model.shoppingChartId];
        }
        
        NSDictionary* info = @{@"userId":[ZHAuthorizationManager shareInstance].userId,@"shoppingCartIdList":list,@"scene":@"15"};
        [HttpClient postDataWithParamers:info success:^(id responseObject) {
            
            ConfirmOrderModel* model = [ConfirmOrderModel praserModelWithInfo:responseObject];
            if (model){
            NSDictionary* userInfo = @{@"controller":@"ZHConfirmOrderVC",
                                       @"userinfo":model
                                       };

            [[MessageCenter instance] performActionWithUserInfo:userInfo];

            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    else{
        ALERT_MESSAGE(@"请选择宝贝后，再提交订单");
    }
}

-(void)doConfirmOrder{
}


@end
