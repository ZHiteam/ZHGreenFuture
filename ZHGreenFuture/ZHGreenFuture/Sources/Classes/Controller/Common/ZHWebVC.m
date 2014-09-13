//
//  ZHWebVC.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-13.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHWebVC.h"

@interface ZHWebVC ()
@property(nonatomic, strong)UIWebView *webView;
@property(nonatomic, strong)NSString  *urlStr;
@end

@implementation ZHWebVC

- (instancetype)initWithURL:(NSString*)urlStr{
    self = [super init];
    if (self) {
        self.webView = [[UIWebView alloc] init];
        self.urlStr  = urlStr;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureNaivBar];
    // Do any additional setup after loading the view.
    self.webView.frame = self.view.bounds;
    [self.view addSubview:self.webView];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlStr]];
    [self.webView loadRequest:request];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)configureNaivBar{
    [self.navigationBar setTitle:self.urlStr];
    [self whithNavigationBarStyle];
}

@end
