//
//  ZHAuthorizationRegister2VC.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-20.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHAuthorizationRegister2VC.h"
#import "ZHAuthorizationRegister3VC.h"
#import "ZHAuthorizationManager.h"


@interface ZHAuthorizationRegister2VC ()
@property (strong, nonatomic)dispatch_source_t timer;
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
    
    self.infoLabel.text = [NSString stringWithFormat:@"验证短信已经发送到:%@",self.account];
    
    [self configureNaivBar];
    [self startTimeOut];
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

#pragma mark - Privte Method
-(void)startTimeOut{
    UILabel *weakLeable = self.regetAuthCodeLabel;
    weakLeable.textColor = RGB(170, 170, 170);
    weakLeable.text = [NSString stringWithFormat:@"重新获取(60)"];
    __block int timeout=10; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                weakLeable.text = [NSString stringWithFormat:@"重新获取"];
                weakLeable.textColor = RGB(102, 170, 0);
                weakLeable.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@">>>%@",strTime);
                weakLeable.text = [NSString stringWithFormat:@"重新获取(%@)",strTime];
                weakLeable.textColor = RGB(170, 170, 170);
                weakLeable.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
    
}

- (void)cancelTimout{
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    
}
#pragma mark - Event Handler
- (IBAction)commitButtonPressed:(id)sender {
    NSString *authCode = self.authCodeTextField.text;
    if (authCode==nil || [authCode length]==0){
		ZHALERTVIEW(nil,@"验证码错误，请重新输入。",nil, @"确定" ,nil,nil);
        return;
	}
    [self cancelTimout];
    
    __weak __typeof(self) weakSelf = self;
    [[ZHAuthorizationManager shareInstance] postValidateCode:authCode account:self.account completionBlock:^(BOOL isSuccess, id info) {
        if (!isSuccess) {
            ZHALERTVIEW(nil, @"出错了，请再试一次" , nil,@"确定"  ,nil,nil);
        }else {
            ZHAuthorizationRegister3VC * vc = [[ZHAuthorizationRegister3VC alloc] initWithNibName:@"ZHAuthorizationRegister3VC" bundle:nil];
            vc.account = weakSelf.account;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    }];
}

- (void)regetAuthCode{
    __weak __typeof(self) weakSelf = self;
    [[ZHAuthorizationManager shareInstance] getValidateCodeWithAccount:self.account completionBlock:^(BOOL isSuccess, id info) {
        if (!isSuccess) {
            ZHALERTVIEW(nil, @"出错了，请再试一次" , nil,@"确定"  ,nil,nil);
        }else {
            [weakSelf startTimeOut];
        }
    }];
}

- (void)backItemPressed:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemPressed:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
