//
//  ZHSubCatagoryVC.m
//  ZHGreenFuture
//
//  Created by elvis on 9/1/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHSubCatagoryVC.h"
#import "ZHProductItem.h"
#import "ZHProductTableViewCell.h"
#import "ZHTableView.h"

@interface ZHSubCatagoryVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIImageView*           bannerView;
@property (nonatomic,strong) UILabel*               titleLabel;
@property (nonatomic,strong) UILabel*               descriptionLabel;
@property (nonatomic,strong) ZHTableView*           contentView;
@property (nonatomic,strong) NSArray*               productList;

@property (nonatomic,assign) BOOL                   startScroll;
@property (nonatomic,assign) CGFloat                direct;
@end

@implementation ZHSubCatagoryVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.userInfo isKindOfClass:[SecondCatagoryModel class]]){
        self.model = self.userInfo;
    }
    
    [self loadContent];
    
    [self loadRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadContent{
    self.navigationBar.title = self.model.title;
    [self whithNavigationBarStyle];
    
    [self.view addSubview:self.bannerView];
    
    [self.view insertSubview:self.contentView belowSubview:self.bannerView];
    
    
    UIImageView* mask = [[UIImageView alloc]initWithFrame:self.bannerView.bounds];
    mask.image = [UIImage themeImageNamed:@"banner_mask"];
    [self.bannerView addSubview:mask];
}

-(UIImageView *)bannerView{
    if (!_bannerView){
        _bannerView = [[UIImageView alloc]initWithFrame:self.contentBounds];
        _bannerView.height = 160;
        
        [_bannerView addSubview:self.titleLabel];
        [_bannerView addSubview:self.descriptionLabel];
        
        [_bannerView setImageWithUrlString:self.model.imageUrl placeHodlerImage:[UIImage themeImageNamed:@"temp_banner_01"]];
        
        
        self.descriptionLabel.top = _bannerView.height-_descriptionLabel.height;
        
        self.titleLabel.bottom = _descriptionLabel.top;
    }
    
    return _bannerView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [UILabel labelWithText:self.model.title font:FONT(24) color:WHITE_TEXT textAlignment:NSTextAlignmentLeft];
        _titleLabel.frame = CGRectMake(12, 0, self.view.width-24, 30);
    }
    
    return _titleLabel;
}

-(UILabel *)descriptionLabel{
    if (!_descriptionLabel){
        
        _descriptionLabel = [[UILabel alloc]init];
        _descriptionLabel.text = self.model.descript;
        _descriptionLabel.font = FONT(12);
        _descriptionLabel.textColor = WHITE_TEXT;
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        _descriptionLabel.numberOfLines = 3;
        
        CGSize labelSize = [self.model.descript sizeWithFont:_descriptionLabel.font
                            constrainedToSize:CGSizeMake(self.view.width-24, MAXFLOAT)
                                lineBreakMode:NSLineBreakByWordWrapping];
        
        _descriptionLabel.frame = CGRectMake(12, 0, self.view.width-24, labelSize.height);
        _descriptionLabel.height = labelSize.height;
        
    }
    return _descriptionLabel;
}


-(UITableView *)contentView{
    if (!_contentView){
        _contentView = [[ZHTableView alloc]initWithFrame:CGRectMake(self.bannerView.left, self.bannerView.bottom, self.bannerView.width, self.contentBounds.size.height-self.bannerView.height)];
        
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.backgroundColor = RGB(238, 238, 238);
        _contentView.dataSource = self;
        _contentView.delegate = self;
        
        _contentView.clipsToBounds = NO;
        
        _contentView.pagingEnabled = NO;
    }
    
    return _contentView;
}

-(void)loadRequest{
    [HttpClient requestDataWithURL:@"" paramers:nil success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
#warning test data
    NSMutableArray* array = [[NSMutableArray alloc]initWithCapacity:10];
    for(int i = 0 ;i < 10; ++i){
        //4.product
        ZHProductItem *productItem = [[ZHProductItem alloc] init];
        productItem.title = @"东北特产全胚芽燕麦850g";
        productItem.subTitle = @"它的营养价值很高，其脂肪含量是大米的4倍";
        productItem.price = @"288.81";
        productItem.buyCount = @"435";
        [array addObject:productItem];
    }
    self.productList = [array mutableCopy];
    
    [_contentView reloadData];
}

#pragma -mark UITableViewDataSource,UITableViewDelegate
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"kProductTableViewCell";
    ZHProductTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [ZHProductTableViewCell tableViewCell];
    }
    
    ZHProductItem *item = [self.productList objectAtIndex:indexPath.row];
    [cell.imageURL setImageWithURL:[NSURL URLWithString:item.imageURL] placeholderImage:[UIImage imageNamed:@"productPlaceholder"]];
    cell.title.text = item.title;
    cell.subTitle.text = item.subTitle;
    ///435人已买
    cell.priceTitle.text = item.price;
    cell.buyCount.text = [item.buyCount length] >0 ? [NSString stringWithFormat:@"/%@人已买",item.buyCount] :@"1人已买";
    [cell updateBuyCountLabelPositon];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ZHProductTableViewCell height];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.productList.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma -mark 

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    /// 防止滑倒顶部和滑倒底部反弹事件
    if (scrollView.contentOffset.y < 0 || scrollView.contentOffset.y > (scrollView.contentSize.height-scrollView.height)){
        return;
    }
    self.direct = scrollView.contentOffset.y;
    self.startScroll = YES;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    self.direct = scrollView.contentOffset.y;
    self.startScroll = YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.startScroll){
//        ZHLOG(@"did scroll  %lf",scrollView.contentOffset.y);
        if (scrollView.contentOffset.y - self.direct > 0){
            ZHLOG(@"UP");
            
            [self hideBanner];
        }
        else if (scrollView.contentOffset.y - self.direct < 0){
            ZHLOG(@"DOWN");
            
            [self showBanner];
        }
        self.startScroll = NO;
    }
}

#pragma -mark action
-(void)hideBanner{
    
    if (self.bannerView.bottom == self.navigationBar.bottom){
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bannerView.bottom = self.navigationBar.bottom;
        
        self.contentView.frame = self.contentBounds;
    } completion:^(BOOL finished) {
    }];
}

-(void)showBanner{
    
    if (self.bannerView.top == self.navigationBar.bottom){
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bannerView.top = self.navigationBar.bottom;
        
        self.contentView.frame = CGRectMake(0, self.bannerView.bottom, self.bannerView.width, self.contentBounds.size.height-self.bannerView.height);
    } completion:^(BOOL finished) {
    }];
}
@end
