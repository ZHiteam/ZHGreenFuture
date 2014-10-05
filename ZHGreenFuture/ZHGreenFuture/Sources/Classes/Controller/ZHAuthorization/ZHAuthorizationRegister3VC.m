//
//  ZHAuthorizationRegister3VC.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-20.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHAuthorizationRegister3VC.h"
#import "ZHAuthorizationManager.h"
#import "ZHAuthorizationVC.h"

@interface ZHAuthorizationRegister3VC ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *password2TextField;
- (IBAction)commitButtonPressed:(id)sender;

@end

@implementation ZHAuthorizationRegister3VC

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
    
    [self configureNaivBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
- (void)backItemPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemPressed:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)commitButtonPressed:(id)sender {
    NSString *pass1 = self.passwordTextField.text;
    NSString *pass2 = self.password2TextField.text;
    
    if ([pass1 length] >0 && [pass1 isEqualToString:pass2]) {
        [[ZHAuthorizationManager shareInstance] registerWithAccount:self.account password:pass1 completionBlock:^(BOOL isSuccess, id info) {
            if (!isSuccess) {
                ZHALERTVIEW(nil, @"出错了，请再试一次" , nil,@"确定"  ,nil,nil);
            }else {
                [FEToastView showWithTitle:@"注册成功。" animation:YES interval:1.0];
                [ZHAuthorizationVC dismissLoginVC];
                [ZHAuthorizationVC shareInstance].isRunning = NO;
            }
        }];
    }else {
        {
            ZHALERTVIEW(nil,@"两次密码不一致，请重新输入。",nil, @"确定" ,nil,nil);
        }
    }
}
@end
