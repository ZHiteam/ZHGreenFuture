//
//  ZHAddressManagerVC.m
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHAddressManagerVC.h"
#import "ZHAddressCell.h"

@interface ZHAddressManagerVC ()<UITableViewDataSource,UITableViewDelegate,ZHAddressCellDelegate>

@property (nonatomic,strong) NSMutableArray*    addressList;
@property (nonatomic,strong) UITableView*       addressTable;
@end

@implementation ZHAddressManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadContent];
    [self loadRequest];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.addressTable reloadData];
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
    
    if ([self.userInfo respondsToSelector:@selector(selectedAtAddress:)]){
        self.delegate = self.userInfo;
    }
    
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
    [[MessageCenter instance]performActionWithUserInfo:@{@"controller":@"ZHAddressEditVC"}];
}

#pragma -mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZHAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell){
        cell = [[ZHAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.delegate = self;
    }
    
    if (indexPath.row < self.addressList.count){
        cell.model = self.addressList[indexPath.row];
        cell.index = indexPath.row;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZHAddressCell cellHeight];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( indexPath.row < self.addressList.count && [self.delegate respondsToSelector:@selector(selectedAtAddress:)]){
        [self.delegate selectedAtAddress:self.addressList[indexPath.row]];
        
        [self.navigationCtl pop];
    }
}
#pragma -mark ZHAddressCellDelegate
-(void)setDefaultWithModel:(AddressModel *)model index:(NSInteger)index isDefault:(BOOL)isDefault{
    /// 发送默认地址请求
    
    for (int i = 0; i < self.addressList.count ;++i){
        AddressModel* model = self.addressList[i];
        model.currentAddress = NO;
        if (i == index){
            model.currentAddress = @"1";
        }
        else{
            model.currentAddress = @"0";
        }
    }
    
    [self.addressTable reloadData];
}

-(void)editWithModel:(AddressModel *)model index:(NSInteger)index{
    /// 编辑事件 ，默默的偷懒不做空值判断了
    
    [[MessageCenter instance]performActionWithUserInfo:@{@"controller":@"ZHAddressEditVC",@"userinfo":model}];
}

-(void)deleteWithModel:(AddressModel *)model index:(NSInteger)index{
    /// 删除事件
    if (index < self.addressList.count){
        [self.addressList removeObjectAtIndex:index];
        
        [self.addressTable reloadData];
    }
}
@end