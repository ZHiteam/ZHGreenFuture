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
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)loadRequest{
    
    [[ZHAddressManager instance]updateAddressListWithBlock:^(BOOL success) {
        if (success && [ZHAddressManager instance].addressList.count > 0){
            self.addressList = [[NSMutableArray alloc] initWithArray:[ZHAddressManager instance].addressList];
            [self.addressTable reloadData];
        }
    }];
    
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

   
    NSString* receiveId = @"";
    
    NSInteger oldIndex = -1;
    for (int i = 0; i < self.addressList.count ;++i){
        AddressModel* model = self.addressList[i];
        if ([model.currentAddress boolValue]){
            oldIndex = i;
        }
        
        if (i == index){
            receiveId = model.receiveId;
            model.currentAddress = @"1";
        }
        else{
            model.currentAddress = @"0";
        }
    }
    
    if (!isEmptyString(receiveId)){
        /// 发送默认地址请求
    [HttpClient requestDataWithParamers:@{@"scene":@"17",@"receiveId":receiveId} success:^(id responseObject) {
        
        BaseModel* model = [BaseModel praserModelWithInfo:responseObject];
        if ([model.state boolValue]){
//            SHOW_MESSAGE(@"设置默认地址成功", 2);
            [ZHAddressManager instance].addressList = [self.addressList mutableCopy];
        }
        else{
            SHOW_MESSAGE(@"设置默认地址失败", 2);
            if (oldIndex != -1){
                AddressModel* model = self.addressList[oldIndex];
                model.currentAddress = @"1";
                model = self.addressList[index];
                model.currentAddress = @"0";
            }

        }
        
        [self.addressTable reloadData];
    } failure:^(NSError *error) {
        SHOW_MESSAGE(@"设置默认地址失败", 2);
        if (oldIndex != -1){
            AddressModel* model = self.addressList[oldIndex];
            model.currentAddress = @"1";
            model = self.addressList[index];
            model.currentAddress = @"0";
        }
        
        [self.addressTable reloadData];
    }];

    }
}

-(void)editWithModel:(AddressModel *)model index:(NSInteger)index{
    /// 编辑事件 ，默默的偷懒不做空值判断了
    
    [[MessageCenter instance]performActionWithUserInfo:@{@"controller":@"ZHAddressEditVC",@"userinfo":model}];
}

-(void)deleteWithModel:(AddressModel *)model index:(NSInteger)index{
    /// 删除事件
    DoAlertView* alert = [[DoAlertView alloc]init];
    
    [alert doYesNo:@"确认删除收货地址" body:model.address yes:^(DoAlertView *alertView) {
        
        [HttpClient requestDataWithParamers:@{@"scene":@"20",@"receiveId":model.receiveId} success:^(id responseObject) {
            
            BaseModel* base = [BaseModel praserModelWithInfo:responseObject];
            
            if (index < self.addressList.count && [base.state boolValue]){
                [self.addressList removeObjectAtIndex:index];
                if ([self.delegate respondsToSelector:@selector(deleteAddress:)]){
                    [self.delegate deleteAddress:model];
                }
                
                [self.addressTable reloadData];
            }
        } failure:^(NSError *error) {
            ALERT_MESSAGE(@"删除失败");
        }];
        

    } no:^(DoAlertView *alertView) {
        
    }];

    

}
@end