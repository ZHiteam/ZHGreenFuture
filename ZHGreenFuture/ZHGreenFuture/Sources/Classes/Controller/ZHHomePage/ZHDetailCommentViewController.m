//
//  ZHDetailCommentViewController.m
//  ZHGreenFuture
//
//  Created by admin on 14-12-30.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHDetailCommentViewController.h"
#import "ZHDetailCommentCell.h"
#import "ZHProductComment.h"

@interface ZHDetailCommentViewController ()<UITableViewDelegate, UITableViewDataSource >
@property(nonatomic, strong)UITableView          *tableView;
@property(nonatomic, strong)ZHProductComment     *commentModel;
@property(nonatomic, strong)NSString             *productId;

@end

@implementation ZHDetailCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setTitle:@"评价列表"];
    [self whithNavigationBarStyle];
    
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = RGB(234, 234, 234);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadAllContent];
}


#pragma mark - Getter & Setter
- (void)setUserInfo:(id)userInfo{
    [super setUserInfo:userInfo];
    if (userInfo && [userInfo isKindOfClass:[NSString class]]) {
        self.productId = userInfo;
    }
}

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



- (ZHProductComment *)commentModel{
    if (_commentModel == nil) {
        _commentModel = [[ZHProductComment alloc] init];
    }
    return _commentModel;
}


#pragma mark - Private Method
- (void)loadAllContent{
    __weak typeof(self) weakSelf = self;
    [self.commentModel loadCommentWithProductId:self.productId completionBlock:^(BOOL isSuccess) {
        if (isSuccess) {
            [weakSelf.tableView reloadData];
        } else {
            [FEToastView showWithTitle:@"加载数据失败，请稍候再试。" animation:YES interval:2.0];
        }
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.commentModel.commentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZHDetailCommentCell *cell = nil;
    static NSString *CellIdentifier = @"kMyProductTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [ZHDetailCommentCell tableViewCell];
    }
 
    ZHCommentItem *item = [self.commentModel.commentArray objectAtIndex:indexPath.row];
    if ([item.userAvatarURL length] >0) {
        [cell.avatarImageView setImageWithURL:[NSURL URLWithString:item.userAvatarURL]];
    }
    cell.userNameLabel.text      = item.userName;
    cell.commentLabel.text       = item.type;
    cell.commentContentLabel.text= item.content;
    cell.dateLabel.text          = item.date;
    return cell;
}


#pragma mark -  UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZHDetailCommentCell height];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


@end
