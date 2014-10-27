//
//  ZHModifyPersonNickVC.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-27.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHModifyPersonNickVC.h"
#import "ZHProfileModel.h"
#import "ASProgressPopUpView.h"

@interface ZHModifyPersonNickVC ()
@property (strong, nonatomic)UITextField *textField;
@property (nonatomic, strong)UIButton *confirmButton;

@property (nonatomic,strong) ASProgressPopUpView*   progressView;
@property (nonatomic,strong) UIView*                progressPanel;

@end

@implementation ZHModifyPersonNickVC

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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.textField];
    [self.view addSubview:self.confirmButton];
    
    
    [self configureNaivBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)progressPanel{
    
    if (!_progressPanel){
        _progressPanel = [[UIView alloc]initWithFrame:self.view.bounds];
        _progressPanel.backgroundColor = RGBA(0, 0, 0, 0.8);
    }
    
    return _progressPanel;
}

-(ASProgressPopUpView *)progressView{
    
    if (!_progressView){
        _progressView = [[ASProgressPopUpView alloc]initWithFrame:CGRectMake(20, self.progressPanel.height/2-1, self.progressPanel.width-40, 2)];
        _progressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
        _progressView.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor greenColor]];
        [_progressView showPopUpViewAnimated:YES];
        [self.progressPanel addSubview:_progressView];
    }
    
    return _progressView;
}

#pragma mark - Private Method
- (void)configureNaivBar{
    [self.navigationBar setTitle:@"修改名称"];
    [self whithNavigationBarStyle];
}
-(void)showProgress{
    UIView* main = ((NavigationViewController*)[MemoryStorage valueForKey:k_NAVIGATIONCTL]).view;
    self.progressView.progress = 0.0f;
    [main addSubview:self.progressPanel];
}

-(void)stopProgress{
    [self.progressPanel removeFromSuperview];
    self.progressView.progress = 0.0f;
}

- (void)confirmButtonPressed:(id)sender {
    if ([self.textField.text length] >0) {
        [self.textField resignFirstResponder];
        
        //[FEToastView showWithTitle:@"正在修改..." animation:YES];
        //__weak __typeof(self) weakSelf = self;
        [self.profileModel modifyProfileInfo:self.profileModel.userAvatarImage userName:self.textField.text progressBlock:^(float progress) {
        } completionBlock:^(BOOL isSuccess) {
           // [FEToastView dismissWithAnimation:YES];
            NSString *message = isSuccess ? @"修改昵称成功" : @"修改昵称失败";
            [FEToastView showWithTitle:message animation:YES interval:2.0];
        }];
    }
}


#pragma mark - Private Method

- (UITextField *)textField{
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(12, 12+64, [UIScreen mainScreen].bounds.size.width - 24, 40)];
        _textField.text = self.profileModel.userName;
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.backgroundColor = [UIColor whiteColor];
    }
    return _textField;
}

- (UIButton *)confirmButton{
    if (_confirmButton == nil) {
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 44+80, self.view.frame.size.width - 24 , 48)];
        _confirmButton.backgroundColor = RGB(102, 170, 0);
        _confirmButton.titleLabel.textAlignment = NSTextAlignmentRight;
        _confirmButton.tag = 0x20;
        [_confirmButton setTitle:@"完成" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7] forState:UIControlStateHighlighted ];
        [_confirmButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7] forState: UIControlStateSelected];
        [_confirmButton addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

@end
