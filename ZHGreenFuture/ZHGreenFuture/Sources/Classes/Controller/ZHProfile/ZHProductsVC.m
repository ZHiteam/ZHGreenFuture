//
//  ZHProductsVC.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-13.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHProductsVC.h"
#import "ZHMyProductModel.h"
#import "ZHMyProductCell.h"
#import "UIImageView+ZHiteam.h"
#import "UIImageView+WebCache.h"
#import "ZHMyProductDetailVC.h"



@interface ZHProductsVC ()<UITableViewDelegate, UITableViewDataSource >
@property(nonatomic, strong)UITableView          *tableView;
@property(nonatomic, strong)ZHMyProductModel     *myProductModel;
@end

@implementation ZHProductsVC

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
    [self.navigationBar setTitle:@"我的作品"];
    [self whithNavigationBarStyle];
   
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
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.contentBounds];
        //_tableView.clipsToBounds = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGB(234, 234, 234);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

- (ZHMyProductModel *)myProductModel{
    if (_myProductModel == nil) {
        _myProductModel = [[ZHMyProductModel alloc] init];
    }
    return _myProductModel;
}


#pragma mark - Private Method
- (void)loadAllContent{
    __weak typeof(self) weakSelf = self;
    [self.myProductModel loadDataWithUserId:[[ZHAuthorizationManager shareInstance] userId] completionBlock:^(BOOL isSuccess) {
        [weakSelf.tableView reloadData];
    }];

}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [[self.myProductModel myProductList] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZHMyProductCell *cell = nil;
    static NSString *CellIdentifier = @"kMyProductTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [ZHMyProductCell tableViewCell];
    }
    ZHMyProductItem *item = [[self.myProductModel myProductList] objectAtIndex:indexPath.section];
    [cell.productImageView setImageWithUrlString:item.workImageURL];
    cell.titleLabel.text        = item.followName;
    cell.contentLabel.text      = item.content;
    cell.publishDateLabel.text  = item.publishDate;
    return cell;
}


#pragma mark -  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZHMyProductCell height];
}

 - (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
     return 12.0;
 }
 
 - (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
     UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
     view.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
     return view;
 }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZHMyProductItem *item = [[self.myProductModel myProductList] objectAtIndex:indexPath.section];
    
    ZHMyProductDetailVC *detailVC = [[ZHMyProductDetailVC alloc] init];
    detailVC.myProductModel = self.myProductModel;
    detailVC.myProductItem  = item;
    NavigationViewController    *navi = [MemoryStorage valueForKey:k_NAVIGATIONCTL];
    [navi pushViewController:detailVC animation:ANIMATE_TYPE_DEFAULT];
}

@end
