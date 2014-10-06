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
}

-(void)viewWillAppear:(BOOL)animated{
    
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
    
//    [self.view addSubview:self.bannerView];
//    
//    [self.view insertSubview:self.contentView belowSubview:self.bannerView];
    
    [self.view addSubview:self.contentView];
    
    
    UIImageView* mask = [[UIImageView alloc]initWithFrame:self.bannerView.bounds];
    mask.image = [UIImage themeImageNamed:@"banner_mask"];
    [self.bannerView addSubview:mask];
}

-(UIImageView *)bannerView{
    if (!_bannerView){
        _bannerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 160)];
        _bannerView.contentMode = UIViewContentModeScaleAspectFill;
        _bannerView.clipsToBounds = YES;
        
        [_bannerView addSubview:self.titleLabel];
        [_bannerView addSubview:self.descriptionLabel];
        
        [_bannerView setImageWithUrlString:self.model.imageUrl placeHodlerImage:nil];///[UIImage themeImageNamed:@"temp_banner_01"]];
        
        
        self.descriptionLabel.top = _bannerView.height-_descriptionLabel.height-10;
        
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
//        _contentView = [[ZHTableView alloc]initWithFrame:CGRectMake(self.bannerView.left, self.bannerView.bottom, self.bannerView.width, self.contentBounds.size.height-self.bannerView.height)];
        _contentView = [[ZHTableView alloc]initWithFrame:self.contentBounds];
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.backgroundColor = RGB(238, 238, 238);
        _contentView.dataSource = self;
        _contentView.delegate = self;
        _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentView.clipsToBounds = NO;
        
        _contentView.pagingEnabled = NO;
    }
    
    return _contentView;
}

-(void)loadRequest{
    if (isEmptyString(self.model.categoryId)){
        return;
    }
    [HttpClient requestDataWithParamers:@{@"scene":@"5",@"categoryId":self.model.categoryId} success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
        self.model = (SecondCatagoryModel*)[SecondCatagoryModel praserModelWithInfo:responseObject];
        
        self.productList = self.model.dataItems;

        [self.bannerView setImageWithUrlString:self.model.imageUrl placeHodlerImage:nil];
        [self.contentView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma -mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"kProductTableViewCell";

    if (indexPath.section == 0){
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            [cell.contentView addSubview:self.bannerView];
        }
        
        return cell;
    }
    
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
    
    if (indexPath.section == 0){
        return self.bannerView.height;
    }
    
    return [ZHProductTableViewCell height];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 1;
    }
    
    return self.productList.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        ZHProductItem *item = [self.productList objectAtIndex:indexPath.row];
        NSString *productId = [item.productId length] >0 ? item.productId : @"";
        [[MessageCenter instance]performActionWithUserInfo:@{@"controller": @"ZHDetailVC",@"userinfo" : productId}];
    }
}
@end
