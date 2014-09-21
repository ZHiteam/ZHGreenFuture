//
//  ZHAuthorizationRegister2VC.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-20.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHAuthorizationRegister2VC.h"
#import "ZHAuthorizationRegister3VC.h"

@interface ZHAuthorizationRegister2VC ()
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITextField *authCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *regetAuthCodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
- (IBAction)commitButtonPressed:(id)sender;

@end

@implementation ZHAuthorizationRegister2VC

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
    
    __weak typeof(self) weakSelf = self;
    [self.regetAuthCodeLabel touchEndedBlock:^(NSSet *touches, UIEvent *event) {
        [weakSelf regetAuthCode];
    }];
    
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
- (IBAction)commitButtonPressed:(id)sender {
    NSString *authCode = self.authCodeTextField.text;
    if (authCode==nil || [authCode length]==0)
	{
		ZHALERTVIEW(nil,@"验证码错误，请重新输入。",nil, @"确定" ,nil,nil);
        return;
	}
    
    ZHAuthorizationRegister3VC * vc = [[ZHAuthorizationRegister3VC alloc] initWithNibName:@"ZHAuthorizationRegister3VC" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)regetAuthCode{

}

- (void)backItemPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemPressed:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
