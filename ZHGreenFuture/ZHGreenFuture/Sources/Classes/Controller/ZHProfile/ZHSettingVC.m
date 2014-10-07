//
//  ZHSettingVC.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-9.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHSettingVC.h"

@interface ZHSettingVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView          *tableView;
@property(nonatomic, strong)NSArray              *contentArray;
@property(nonatomic, strong)UISwitch             *switchButton;
@end

@implementation ZHSettingVC

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

    
    self.contentArray = @[@"消息推送",@"清除缓存",@"给有好粮评分",@"意见反馈",@"分享给朋友",@"关于有好粮"];
    [self.view addSubview:self.tableView];
    [self configureNaivBar];
    
    UIColor *color = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    self.view.backgroundColor = color ;
    self.tableView.backgroundColor = color;
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

- (UISwitch *)switchButton{
    if (_switchButton == nil) {
        _switchButton = [[UISwitch alloc] initWithFrame:CGRectZero];
        _switchButton.on = YES;
    }
    return _switchButton;
}

#pragma mark - Private Method

- (void)configureNaivBar{
    [self.navigationBar setTitle:@"设置"];
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
        
        cell.textLabel.text = [self.contentArray objectAtIndex:indexPath.row];
        cell.accessoryView = indexPath.row == 0 ? self.switchButton : nil;
        return cell;
    }
    return nil;
}


#pragma mark -  UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@">>>>>didSelectRowAtIndexPath %@",indexPath);
    
    /// add by kongkong for version
    switch (indexPath.row) {
            /// 关于有好粮
        case 5:
        {
            NSString* msg = [NSString stringWithFormat:@"版本号：%@\nBuild：%@",ZH_VERSION,ZH_BUILD];
            ALERT_IMAGE_MESSAGE([UIImage themeImageNamed:@"logo.png"], msg);
        }
            break;
            
        default:
            break;
    }
    
}


@end
