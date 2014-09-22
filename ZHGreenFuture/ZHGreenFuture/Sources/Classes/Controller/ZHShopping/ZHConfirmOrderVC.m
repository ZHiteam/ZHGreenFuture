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

@interface ZHConfirmOrderVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) TPKeyboardAvoidingTableView*   confiemOrderTable;
@property (nonatomic,strong) UITableViewCell*               addressView;

@property (nonatomic,strong) AddressModel*                  addressModel;

@end

@implementation ZHConfirmOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadContent{
    
    if ([self.userInfo isKindOfClass:[NSArray class]]){
        self.chartList = self.userInfo;
    }
    
    self.navigationBar.title = @"确认订单";
    [self whithNavigationBarStyle];
    
    [self.view addSubview:self.confiemOrderTable];
}

-(TPKeyboardAvoidingTableView *)confiemOrderTable{
    
    if (!_confiemOrderTable){
        _confiemOrderTable = [[TPKeyboardAvoidingTableView alloc]initWithFrame:self.contentBounds];
        _confiemOrderTable.backgroundColor = GRAY_LINE;
        _confiemOrderTable.showsVerticalScrollIndicator = NO;
        
        _confiemOrderTable.delegate = self;
        _confiemOrderTable.dataSource = self;
    }
    
    return _confiemOrderTable;
}

-(UITableViewCell *)addressView{
    
    if (!_addressView){
        _addressView = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCell"];
        _addressView.height = 50;
        if (!self.addressModel){
            UIControl* ctl = [[UIControl alloc]initWithFrame:_addressView.bounds];
            [_addressView addSubview:ctl];

            UIButton* location = [[UIButton alloc]initWithFrame:CGRectMake(10, 16, 14, 18)];
            [location setImage:[UIImage themeImageNamed:@"btn_location"] forState:UIControlStateNormal];
            [ctl addSubview:location];
            
            UIButton* makSure = [[UIButton alloc]initWithFrame:CGRectMake(location.right+10, location.top, 120, location.height)];
            [makSure setTitle:@"请填写收货地址" forState:UIControlStateNormal];
            [makSure setTitleColor:BLACK_TEXT forState:UIControlStateNormal];
            makSure.titleLabel.font = FONT(16);
            makSure.titleLabel.textAlignment = NSTextAlignmentLeft;
            [ctl addSubview:makSure];

            UIButton* more = [[UIButton alloc]initWithFrame:CGRectMake(_addressView.width-28, 16, 18, 18)];
            [more setImage:[UIImage themeImageNamed:@"detailMore"] forState:UIControlStateNormal];
            [ctl addSubview:more];
            
            [ctl addTarget:self action:@selector(addressManagerPage) forControlEvents:UIControlEventTouchUpInside];
            [location addTarget:self action:@selector(addressManagerPage) forControlEvents:UIControlEventTouchUpInside];
            [makSure addTarget:self action:@selector(addressManagerPage) forControlEvents:UIControlEventTouchUpInside];
            [more addTarget:self action:@selector(addressManagerPage) forControlEvents:UIControlEventTouchUpInside];
        }
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
        return self.chartList.count+4;
    }
    
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = nil;
    
    if (0 == indexPath.section){
        cell = self.addressView;
    }
    else if(indexPath.row < self.chartList.count){
        cell = [self charCellAtIndex:indexPath];
    }
    else if (indexPath.row < self.chartList.count+3){
        cell = [self otherCellAtIndex:[NSIndexPath indexPathForRow:indexPath.row-self.chartList.count inSection:indexPath.section]];
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
    
    if(indexPath.row < self.chartList.count){
        return [ZHShoppingChartCell cellHeight];
    }
    else if (indexPath.row < self.chartList.count+3){
        return 40;
    }
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
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
    
    if (index.row < self.chartList.count){
        cell.model = self.chartList[index.row];
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
    }
    
    UILabel* label = (UILabel*)[cell viewWithTag:-101];
    UILabel* desc = (UILabel*)[cell viewWithTag:-102];
    
    if (0 ==index.row){
        label.text = @"商品总价：";
        desc.text = @"￥19.89";
    }
    else if (1 == index.row){
        label.text = @"运费：";
        desc.text = @"全国包邮";
    }
    else{
        label.text = @"优惠：";
        desc.text = @"-￥7.89";
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
        
        note.tag = -103;
        
        [cell addSubview:note];
    }
    
    return cell;
}

#pragma -mark Adress Manager
-(void)addressManagerPage{
    [[MessageCenter instance]performActionWithUserInfo:@{@"controller":@"ZHAddressManagerVC"}];
}
@end
