//
//  ZHAuthorizationRegister1VC.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-20.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHAuthorizationRegister1VC.h"
#import "ZHAuthorizationRegister2VC.h"

@interface ZHAuthorizationRegister1VC ()
@property(nonatomic, strong)UIImageView            *phoneImageView;
@property(nonatomic, strong)UITextField            *accountTextField;
@property(nonatomic, strong)UIButton               *registerButton;

@end

@implementation ZHAuthorizationRegister1VC

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
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
    [self.view addSubview:self.phoneImageView];
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.registerButton];
    
    [self configureNaivBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter & Setter
- (UIImageView *)phoneImageView{
    if ( _phoneImageView == nil){
        _phoneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 26, 20, 20)];
        _phoneImageView.image = [UIImage imageNamed:@"auth_phone"];
    }
    return _phoneImageView;
}


- (UITextField *)accountTextField{
    if (_accountTextField == nil) {
        _accountTextField =  [[UITextField alloc] initWithFrame:CGRectMake(38, 26, [UIScreen mainScreen].bounds.size.width - 56, 20)];
        _accountTextField.font = [UIFont systemFontOfSize:14.0];
       _accountTextField.placeholder = @"输入常用手机号";
    }
    return _accountTextField;
}


- (UIButton *)registerButton{
    if (_registerButton == nil) {
        _registerButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 60, self.view.frame.size.width - 24 , 48)];
        _registerButton.backgroundColor = RGB(102, 170, 0);
        _registerButton.titleLabel.textAlignment = NSTextAlignmentRight;
        _registerButton.tag = 0x20;
        [_registerButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registerButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted ];
        [_registerButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7] forState: UIControlStateSelected];
        [_registerButton addTarget:self action:@selector(registerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (void)configureNaivBar{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32 , 44)];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button setTitleColor:RGB(102, 170, 0) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24 , 44)];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"btn_back_login"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    //调整位置
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - Event Handler
- (void)registerButtonPressed:(id)sender{
    ZHAuthorizationRegister2VC * vc = [[ZHAuthorizationRegister2VC alloc] initWithNibName:@"ZHAuthorizationRegister2VC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backItemPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemPressed:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
