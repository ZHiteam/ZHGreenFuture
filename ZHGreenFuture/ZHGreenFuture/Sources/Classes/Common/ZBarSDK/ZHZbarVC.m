//
//  ZHZbarVC.m
//  NewProject
//
//  Created by admin on 14-9-9.
//  Copyright (c) 2014年 Steven. All rights reserved.
//

#import "ZHZbarVC.h"
#import "ZBarSDK.h"
#import "ZHZbarPrivateVC.h"

@interface ZHZbarVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZBarReaderDelegate>
@property(nonatomic, assign)NSInteger    count;
@property(nonatomic, assign)BOOL         upOrdown;
@property(nonatomic, strong)NSTimer      *timer;
@property(nonatomic, strong)UIImageView  *line;
@property(nonatomic, copy)ZHScanCompletionBlock completionBlock;
@property(nonatomic, strong)UIViewController *containerVC;

@end

@implementation ZHZbarVC

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Publick Method

+ (instancetype)sharedInstance{
    static ZHZbarVC *shareInstance =nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ZHZbarVC alloc] init];
    });
    return shareInstance;
}

- (void)startScanWithVC:(UIViewController*)containerVC completionBlock:(ZHScanCompletionBlock)block{    self.completionBlock = block;
    self.containerVC     = containerVC;
    if([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0){
        ZHZbarPrivateVC * rt = [[ZHZbarPrivateVC alloc]init];
        rt.completionBlock = block;
        [containerVC presentViewController:rt animated:YES completion:nil];
    }
    else{
        [self scanBtnAction];
    }
}

#pragma mark - Private Method
-(void)scanBtnAction
{
    self.count = 0;
    self.upOrdown = NO;
    //初始话ZBar
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    //设置代理
    reader.readerDelegate = self;
    //支持界面旋转
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsHelpOnFail = NO;
    reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    view.backgroundColor = [UIColor clearColor];
    reader.cameraOverlayView = view;
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    label.text = @"请将扫描的二维码至于下面的框内\n谢谢！";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.lineBreakMode = 0;
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    image.frame = CGRectMake(20, 80, 280, 280);
    [view addSubview:image];
    
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [image addSubview:_line];
    //定时器，设定时间过1.5秒，
    self.timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(moveLineAnimation) userInfo:nil repeats:YES];
    [self.containerVC presentViewController:reader animated:YES completion:nil];
}

-(void)moveLineAnimation
{
    if (self.upOrdown == NO) {
        self.count ++;
        _line.frame = CGRectMake(30, 10+2*self.count, 220, 2);
        if (2*self.count == 260) {
            self.upOrdown = YES;
        }
    }
    else {
        self.count --;
        _line.frame = CGRectMake(30, 10+2*self.count, 220, 2);
        if (self.count == 0) {
            self.upOrdown = NO;
        }
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    self.count = 0;
    self.upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    self.count = 0;
    self.upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //初始化
        ZBarReaderController * read = [ZBarReaderController new];
        //设置代理
        read.readerDelegate = self;
        CGImageRef cgImageRef = image.CGImage;
        ZBarSymbol * symbol = nil;
        id <NSFastEnumeration> results = [read scanImage:cgImageRef];
        for (symbol in results)
        {
            break;
        }
        NSString * result;
        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding]){
            result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        else{
            result = symbol.data;
        }
        
        NSLog(@"%@",result);
        if (self.completionBlock) {
            self.completionBlock(result);
        }
    }];
}

@end
