//
//  ZHMyProductDetailVC.m
//  ZHGreenFuture
//
//  Created by admin on 14-9-27.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHMyProductDetailVC.h"
#import "ZHMyProductDetaillCell.h"

@interface ZHMyProductDetailVC ()
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) ZHMyProductDetaillCell *detailCell;

@end

@implementation ZHMyProductDetailVC

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
    [self.navigationBar setTitle:self.myProductItem.followName];
    [self whithNavigationBarStyle];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.detailCell];
    
    //TMP
    [self.imageView setImageWithUrlString:self.myProductItem.workImageURL placeHodlerImage:[UIImage imageNamed:@"profile_myproductDetail"]];
    
    __weak typeof(self) weakSelf = self;
    [self.myProductModel loadDetailWithId:self.myProductItem.workId completionBlock:^(BOOL isSuccess) {
        [weakSelf.imageView setImageWithUrlString:self.myProductItem.workImageURL placeHodlerImage:[UIImage imageNamed:@"profile_myproductDetail"]];
        weakSelf.detailCell.publishDateLabel.text = weakSelf.myProductModel.productDetail.publishDate;
        weakSelf.detailCell.contentLabel.text = weakSelf.myProductModel.productDetail.content;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter & Setter
- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentBounds];
    }
    return _imageView;
}

- (ZHMyProductDetaillCell *)detailCell{
    if (_detailCell == nil) {
        _detailCell = [ZHMyProductDetaillCell tableViewCell];
    }
    [_detailCell setFrame:CGRectMake(0, self.view.frame.size.height - [ZHMyProductDetaillCell height] , self.view.frame.size.width, [ZHMyProductDetaillCell height] )];
    return _detailCell;
}

@end
