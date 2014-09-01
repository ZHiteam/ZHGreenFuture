//
//  ZHCatagoryVC.m
//  ZHGreenFuture
//
//  Created by elvis on 9/1/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHCatagoryVC.h"
#import "ZHCatagoryDetail.h"

@interface ZHCatagoryVC ()

@property(nonatomic,strong) ZHCatagoryDetail*   catagoryView;
@end

@implementation ZHCatagoryVC

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
    
    [self loadContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadContent{
    self.view.backgroundColor = RGB(238, 238, 238);
    
    self.navigationBar.title = @"XXX分类";
    
    [self.view addSubview:self.catagoryView];
}


-(ZHCatagoryDetail *)catagoryView{
    if (!_catagoryView){
        _catagoryView = [[ZHCatagoryDetail alloc]initWithFrame:self.contentBounds];
    }
    
    return _catagoryView;
}
@end
