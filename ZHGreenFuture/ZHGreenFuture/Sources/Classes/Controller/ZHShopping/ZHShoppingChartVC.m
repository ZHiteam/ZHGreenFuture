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

@interface ZHShoppingChartVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView*   chartTable;
@property (nonatomic,assign) BOOL           chartEditing;

@property (nonatomic,strong) UIView*        toolBar;
@property (nonatomic,strong) UIButton*      checkOut;
@property (nonatomic,strong) ZHCheckbox*    allSelect;

@property (nonatomic,strong) UILabel*       totalLabel;
@property (nonatomic,strong) UILabel*       totalSaveLabel;

@property (nonatomic,strong) UILabel*       allSelectedLabel;

@property (nonatomic,strong) NSMutableArray*       shoppingChartLists;
@end

@implementation ZHShoppingChartVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadContent];
    
    [self loadRequest];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadRequest{
#warning TEST
    self.shoppingChartLists = [[NSMutableArray alloc]initWithCapacity:10];
    
    for (int i = 0 ; i < 10; ++i){
        ShoppingChartModel* model = [[ShoppingChartModel alloc]init];
        model.title = @"【三千禾】东北农家黑 荞麦米 粗粮 五谷杂 荞麦米 粗粮 五谷杂";
        model.skuInfo = @"重量：500g；礼盒装";
        model.marketPrice = @"￥19.89";
        model.promotionPrice = @"￥9.89";
        model.buyCout = [NSString stringWithFormat:@"%d",i+1];
        
        [self.shoppingChartLists addObject:model];
    }
    
    
    [self.chartTable reloadData];
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
            ZHLOG(@"selected %d",checked);

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
    }
    
    [self.chartTable reloadData];
    [self reloadToolBar];
}


#pragma -mark edit action
-(void)editAction{
    self.chartEditing = !self.chartEditing;
    
}

#pragma -mark checkout action
-(void)checkOutAction{
    
    /// 删除
    if (self.chartEditing){
        
    }
    /// 结算
    else{
        if (self.shoppingChartLists.count > 0){
            
            NSMutableArray* selectedList = [[NSMutableArray alloc]initWithCapacity:self.shoppingChartLists.count];
            for (ShoppingChartModel* model in self.shoppingChartLists){
                if (model.checked){
                    [selectedList addObject:model];
                }
            }
            
            if (selectedList.count > 0){
                NSDictionary* userInfo = @{@"controller":@"ZHConfirmOrderVC",
                                           @"userinfo":selectedList
                                           };
                
                [[MessageCenter instance] performActionWithUserInfo:userInfo];
            }
            else{
                ALERT_MESSAGE(@"请选择宝贝后，再提交订单");
            }
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
    }
    
    ShoppingChartModel* model = nil;
    if (indexPath.row < self.shoppingChartLists.count){
        model = self.shoppingChartLists[indexPath.row];
    }
    
    if (model){
        cell.model = model;
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
    ZHLOG(@"delected at row %d",indexPath.row);
    [tableView setEditing:NO animated:YES];
}
@end
