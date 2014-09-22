//
//  ZHAddressManagerVC.m
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHAddressManagerVC.h"
#import "ZHAddressCell.h"

@interface ZHAddressManagerVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray*    addressList;
@property (nonatomic,strong) UITableView*       addressTable;
@end

@implementation ZHAddressManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadContent];
    
    [self loadRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadRequest{
#warning TEST
    
    self.addressList = [[NSMutableArray alloc]initWithCapacity:3];
    for (int i = 0 ;i < 3; ++i){
        AddressModel* model = [[AddressModel alloc]init];
        model.name = @"王百万";
        model.phone = @"15067192558";
        model.address = @"浙江省杭州市西湖区东部软件园科技广场617";
        
        [self.addressList addObject:model];
    }
    
    [self.addressTable reloadData];
}

-(void)loadContent{
    self.navigationBar.title = @"收货地址管理";
    
    [self whithNavigationBarStyle];
    
    UIButton* rightBtn = [UIButton barItemWithTitle:@"添加" action:self selector:@selector(addAction)];
    rightBtn.width += 10;
    [rightBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    self.navigationBar.rightBarItem = rightBtn;
    
    [self.view addSubview:self.addressTable];
}


-(UITableView *)addressTable{
    
    if (!_addressTable){
        _addressTable = [[UITableView alloc]initWithFrame:self.contentBounds];
        _addressTable.backgroundColor = GRAY_LINE;
        _addressTable.showsVerticalScrollIndicator = NO;
        _addressTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _addressTable.delegate = self;
        _addressTable.dataSource = self;
    }
    
    return _addressTable;
}

#pragma -mark add action
-(void)addAction{
    
}

#pragma -mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZHAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell){
        cell = [[ZHAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.row < self.addressList.count){
        cell.model = self.addressList[indexPath.row];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZHAddressCell cellHeight];
}

@end