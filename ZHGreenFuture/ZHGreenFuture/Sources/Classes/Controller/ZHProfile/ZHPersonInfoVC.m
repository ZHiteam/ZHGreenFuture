//
//  ZHPersonInfoVC.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-13.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHPersonInfoVC.h"

@interface ZHPersonInfoVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView          *tableView;
@property(nonatomic, strong)NSArray              *contentArray;
@property(nonatomic, strong)UIImageView          *avatarView;
@property(nonatomic, strong)UILabel              *userNameLabel;

@end

@implementation ZHPersonInfoVC

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
    self.contentArray = @[@"头像",@"昵称"];
    [self configureNaivBar];
    [self.view addSubview:self.tableView];
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

- (UIImageView *)avatarView{
    if (_avatarView == nil) {
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 120 , 7, 80, 30)];
        [_avatarView setImageWithURL:[NSURL URLWithString:self.avatarURL] placeholderImage:[UIImage imageNamed:@"avatar"]];
    }
    return _avatarView;
}

- (UILabel *)userNameLabel{
    if (_userNameLabel == nil) {
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 120 , 7, 80, 30)];
        _userNameLabel.text = [self.userName length] > 0 ? self.userName : @"艾米饭";
        //_userNameLabel.backgroundColor = [UIColor orangeColor];
    }
    return _userNameLabel;
}

#pragma mark - Private Method
- (void)configureNaivBar{
    [self.navigationBar setTitle:@"个人信息"];
    //default back
    [self whithNavigationBarStyle];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.contentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section ==0) {
        static NSString *CellIdentifier = @"kImageTableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            UIView *seperateLineview = [[UIView alloc] initWithFrame:CGRectMake(12, cell.frame.size.height-0.5, cell.frame.size.width-24, 0.5)];
            seperateLineview.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
            seperateLineview.tag = 0x88;
            [cell.contentView addSubview:seperateLineview];
        }
        UIView *seperateView = [cell.contentView viewWithTag:0x88];
        seperateView.frame = CGRectMake(12, cell.frame.size.height-0.5, cell.frame.size.width-24, 0.5);
        if ((indexPath.row+1)==[self.contentArray count]) {
            seperateView.frame = CGRectMake(0, cell.frame.size.height-0.5, cell.frame.size.width, 0.5);
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [self.contentArray objectAtIndex:indexPath.row];
        [self.avatarView removeFromSuperview];
        [self.userNameLabel removeFromSuperview];
        if (indexPath.row == 0) {
            [cell.contentView addSubview:self.avatarView];
        }else {
            [cell.contentView addSubview:self.userNameLabel];
        }
        return cell;
    }
    return nil;
}


#pragma mark -  UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@">>>>>didSelectRowAtIndexPath %@",indexPath);
}


@end
