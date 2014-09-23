//
//  ZHAddressEditVC.m
//  ZHGreenFuture
//
//  Created by elvis on 9/22/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHAddressEditVC.h"

@interface ZHAddressEditVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign) NSInteger type;

@property (nonatomic,strong) UITableView*   addressTable;
@end

@implementation ZHAddressEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadContent];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadContent{
    
    if ([self.userInfo isKindOfClass:[AddressModel class]]){
        self.model = self.userInfo;
        self.navigationBar.title = @"编辑收货地址";
        self.type = 0;
    }
    else{
        self.navigationBar.title = @"新增收货地址";
        self.type = 1;
    }
    
    UIButton* doneBtn = [UIButton barItemWithTitle:@"完成" action:self selector:@selector(doneAction)];
    doneBtn.width += 10;
    [doneBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    self.navigationBar.rightBarItem = doneBtn;
    
    [self whithNavigationBarStyle];
    
    [self.view addSubview:self.addressTable];
}

-(UITableView *)addressTable{
    
    if (!_addressTable){
        _addressTable = [[UITableView alloc]initWithFrame:self.contentBounds];
        _addressTable.delegate  =self;
        _addressTable.dataSource = self;
        _addressTable.showsVerticalScrollIndicator = NO;
        _addressTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _addressTable.backgroundColor = GRAY_LINE;
    }
    
    return _addressTable;
}

#pragma -mark UITableViewDataSource,UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherCell"];
        UILabel* label = [UILabel labelWithText:@"" font:FONT(14) color:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft];
        label.frame = CGRectMake(10, 0, 100, 40);
        label.tag = -101;
        
        [cell addSubview:label];
        
        UITextField* field = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, cell.width-100, 40)];
        field.font = FONT(14);
        field.clearButtonMode = UITextFieldViewModeWhileEditing;
        field.tag = -102;
        [cell addSubview:field];
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(10, 39, cell.width-20, 1)];
        line.backgroundColor = GRAY_LINE;
        [cell addSubview:line];
        
        cell.backgroundColor = WHITE_BACKGROUND;
    }
    
    UILabel* label = (UILabel*)[cell viewWithTag:-101];
    UITextField* field = (UITextField*)[cell viewWithTag:-102];
    
    if (0 ==indexPath.row){
        label.text = @"收货人：";
        if (isEmptyString(field.text)){
            field.text = self.model.name;
        }
    }
    else if (1 == indexPath.row){
        label.text = @"手机号：";
        if (isEmptyString(field.text)){
            field.text = self.model.phone;
        }
    }
    else{
        label.text = @"详细地址：";
        if (isEmptyString(field.text)){
            field.text = self.model.address;
        }
    }
    
    return cell;
}

-(NSString*)fieldValueAtIndex:(NSInteger)index{
    NSString* val = nil;
    if (index <0 || index > 3){
        return val;
    }
    UITableViewCell* cell = [self.addressTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    UITextField* field = (UITextField*)[cell viewWithTag:-102];
    val = field.text;
    
    return val;
}

-(void)doneAction{
    NSString* name = [self fieldValueAtIndex:0];
    if (isEmptyString(name)) {
        ALERT_MESSAGE(@"收货人不能为空");
        return;
    }
    
    NSString* phone = [self fieldValueAtIndex:1];
    if (isEmptyString(phone)){
        ALERT_MESSAGE(@"手机号不能为空");
        return;
    }
    
    NSString* address = [self fieldValueAtIndex:2];
    if (isEmptyString(address)){
        ALERT_MESSAGE(@"收货地址不能为空");
        return;
    }
    
    if (self.model){
        self.model.name= name;
        self.model.phone = phone;
        self.model.address = address;
    }
    
    /// 发送网络请求
    /// 编辑请求
    if (0 == self.type){
        
    }
    /// 新增请求
    else{
        
    }
    [self.navigationCtl pop];
}
@end
