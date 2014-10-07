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
@property(nonatomic,strong) FEScrollPageView *bannerImageView;
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
    //self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationBar setTitle:self.myProductItem.followName];
    [self whithNavigationBarStyle];
    //[self.view addSubview:self.imageView];
    [self.view addSubview:self.bannerImageView];
    [self.view addSubview:self.detailCell];
    
    //TMP
    //[self.imageView setImageWithUrlString:self.myProductItem.workImageURL placeHodlerImage:[UIImage imageNamed:@"profile_myproductDetail"]];
    
    __weak typeof(self) weakSelf = self;
    [self.myProductModel loadDetailWithId:self.myProductItem.workId completionBlock:^(BOOL isSuccess) {
        //[weakSelf.imageView setImageWithUrlString:self.myProductItem.workImageURL placeHodlerImage:[UIImage imageNamed:@"profile_myproductDetail"]];
        [weakSelf reloadBannerImages];
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

- (FEScrollPageView *)bannerImageView{
    if (_bannerImageView == nil) {
        _bannerImageView = [[FEScrollPageView alloc] initWithFrame:self.contentBounds];
        _bannerImageView.isHiddenPageController = YES;
    }
    return _bannerImageView;
}

- (ZHMyProductDetaillCell *)detailCell{
    if (_detailCell == nil) {
        _detailCell = [ZHMyProductDetaillCell tableViewCell];
    }
    [_detailCell setFrame:CGRectMake(0, self.view.frame.size.height - [ZHMyProductDetaillCell height] , self.view.frame.size.width, [ZHMyProductDetaillCell height] )];
    return _detailCell;
}

#pragma mark - Privte Method
- (void)reloadBannerImages{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    NSInteger index = 0;
    for (NSString *imageURL in self.myProductModel.productDetail.workImageURLArray) {
        FEImageItem *item = [[FEImageItem alloc] initWithTitle:nil imageURL:imageURL tag:index++];
        [array addObject:item];
    }
    [self.bannerImageView setImageItems:[array copy] selectedBlock:nil isAutoPlay:NO];
}

@end
