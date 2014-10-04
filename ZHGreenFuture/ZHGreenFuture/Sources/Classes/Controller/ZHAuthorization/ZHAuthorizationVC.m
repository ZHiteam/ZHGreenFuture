//
//  ZHAuthorizationVC.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-20.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHAuthorizationVC.h"
#import "ZHAuthorizationRegister1VC.h"


@interface ZHAuthorizationVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong)UITableView          *tableView;
@property(nonatomic, copy)ZHAuthCompletionBlock completionBlock;
@property(nonatomic, strong)UIButton             *loginButton;
@property(nonatomic, weak)UITextField            *accountTextField;
@property(nonatomic, weak)UITextField            *passwordTextField;

@end

@implementation ZHAuthorizationVC

+ (instancetype)shareInstance{
    static ZHAuthorizationVC *shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ZHAuthorizationVC alloc] init];
    });
    return shareInstance;
}


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
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureNaivBar];
    [self.view addSubview:self.tableView];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Method

+ (void)showLoginVCWithCompletionBlock:(ZHAuthCompletionBlock)block{
    ZHAuthorizationVC *vc = [ZHAuthorizationVC shareInstance];
    if (!vc.isRunning) {
        vc.isRunning       = YES;
        vc.completionBlock = block;
        vc.modalPresentationStyle = UIModalPresentationCurrentContext;
        
        UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:vc];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:naviVC animated:YES completion:nil];
    }
}

+ (void)dismissLoginVC{
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (ZHAuthorizationManager *)authManager{
    return [ZHAuthorizationManager shareInstance];
}

#pragma mark - Getter & Setter
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        //_tableView.clipsToBounds = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];//RGB(234, 234, 234);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizesSubviews = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}


- (UIButton *)loginButton{
    if (_loginButton == nil) {
        _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 0, self.view.frame.size.width - 24 , 48)];
        _loginButton.backgroundColor = RGB(102, 170, 0);
        _loginButton.titleLabel.textAlignment = NSTextAlignmentRight;
        _loginButton.tag = 0x20;
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted ];
        [_loginButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7] forState: UIControlStateSelected];
        [_loginButton addTarget:self action:@selector(loginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}


#pragma mark - Privte Method
- (void)configureNaivBar{
    self.title = @"登录";
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];//RGB(102, 170, 0);
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32 , 44)];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button setTitle:@"注册" forState:UIControlStateNormal];
    [button setTitleColor:RGB(102, 170, 0) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24 , 44)];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"btn_back_login"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(leftItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    //调整位置
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - Event Handler
- (void)leftItemPressed:(id)sender{
    [ZHAuthorizationVC dismissLoginVC];
    self.completionBlock(NO,nil);
    self.isRunning = NO;
}

- (void)rightItemPressed:(id)sender{
    ZHAuthorizationRegister1VC * vc = [[ZHAuthorizationRegister1VC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loginButtonPressed:(id)sender{
    NSString* userNameStr = self.accountTextField.text;
	NSString* passwordStr = self.passwordTextField.text;
	[self.accountTextField	resignFirstResponder];
	[self.passwordTextField resignFirstResponder];
	userNameStr = [userNameStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ;
	
    if (userNameStr==nil || [userNameStr length]==0)
	{
		ZHALERTVIEW(nil,@"用户名不合法，请重新输入。",nil, @"确定" ,nil,nil);
        return;
	}
	else if (passwordStr==nil || [passwordStr length]==0)
	{
		ZHALERTVIEW(nil,@"密码错误，请重新输入。",nil, @"确定" ,nil,nil);
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    [[ZHAuthorizationManager shareInstance] logInWithAccount:userNameStr password:passwordStr completionBlock:^(BOOL isSuccess, id info) {
        if (weakSelf.completionBlock) {
            weakSelf.completionBlock(isSuccess,info);
        }
        
        if (!isSuccess) {
            /// modify by kongkong
            ALERT_MESSAGE(@"登录出错");
            //            ZHALERTVIEW(@"登录出错", nil , nil,@"确定"  ,nil,nil);
        } else {
            [ZHAuthorizationVC dismissLoginVC];
            [FEToastView showWithTitle:@"登录成功" animation:YES interval:2.0];
        }
        weakSelf.isRunning = NO;
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"kTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(44, 0, [UIScreen mainScreen].bounds.size.width - 56, 48)];
        textField.tag = 0x11;
        [cell.contentView addSubview:textField];
        UIView *seperateLineView = [[UIView alloc] initWithFrame:CGRectMake(12, cell.frame.size.height-0.5, cell.frame.size.width -24, 0.5)];
        seperateLineView.backgroundColor = RGB(204, 204, 204);
        seperateLineView.tag = 0x12;
        [cell.contentView addSubview:seperateLineView];
    }
    //[self.loginButton removeFromSuperview];
    UITextField *textField = (UITextField*)[cell.contentView viewWithTag:0x11];
    textField.hidden = NO;
    textField.backgroundColor = [UIColor clearColor];
    UIView *seperateView = [cell.contentView viewWithTag:0x12];
    seperateView.hidden = YES;
    UIView *loginButton = [cell viewWithTag:0x20];
    [loginButton removeFromSuperview];
    if(indexPath.row == 0) {
        cell.imageView.image  = [UIImage imageNamed:@"auth_account"];
        textField.placeholder = @"手机号/用户名";
        textField.secureTextEntry = NO;
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        //textField.font = [UIFont systemFontOfSize:14.0];
        seperateView.hidden = NO;
        self.accountTextField = textField;
    }else if ( indexPath.row == 1) {
        cell.imageView.image = [UIImage imageNamed:@"auth_password"];
        textField.placeholder = @"请输入密码";
        textField.secureTextEntry = YES;
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.passwordTextField = textField;
    } else if( indexPath.row == 2) {
        textField.hidden = YES;
        [cell addSubview:self.loginButton];
    }
    return cell;
}


#pragma mark -  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor whiteColor];//RGB(234, 234, 234);
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSLog(@">>>>>didSelectRowAtIndexPath %@",indexPath);
}


@end
