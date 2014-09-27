//
//  ZHCatagoryVC.m
//  ZHGreenFuture
//
//  Created by elvis on 9/1/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHCatagoryVC.h"
#import "ZHSwipSegment.h"
#import "ZHProductItem.h"
#import "ZHProductTableViewCell.h"

@interface ZHCatagoryVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView*            contentView;
@property (nonatomic,strong) UITableView*       contentTableView;

@property (nonatomic,strong) ZHSwipSegment*     catagoryList;

@property (nonatomic,strong) NSArray*   productList;
//@property (nonatomic,strong) NSTimer*   resumeTimer;
@property (nonatomic,assign) BOOL       needResume;
@property (nonatomic,assign) BOOL       resumeDelay;

@property (nonatomic,strong) ZHSegmentView*  segmentView;
@property (nonatomic,strong) UIView*         segmentPanel;

@property (nonatomic,assign) BOOL       startScroll;
@property (nonatomic,assign) CGFloat    direct;

@property (nonatomic,assign) NSTimeInterval     lastTimeInterval;


@end

@implementation ZHCatagoryVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadContent];
    [self loadRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadContent{
    self.view.backgroundColor = RGB(238, 238, 238);
    
    if ([self.userInfo isKindOfClass:[CatagoryModel class]]){
        self.model = self.userInfo;
    }
    
    self.navigationBar.title = self.model.title;

    [self whithNavigationBarStyle];
    
    [self.view addSubview:self.contentView];
    [self.view insertSubview:self.catagoryList belowSubview:self.contentView];
    
    self.contentView.top = self.catagoryList.height;
    
    [self.contentView addSubview:self.contentTableView];
    
    [self.contentView addSubview:self.segmentPanel];
}

-(UIView *)contentView{
    if (!_contentView){
        _contentView = [[UIView alloc]initWithFrame:self.contentBounds];
    }
    return _contentView;
}

-(UITableView *)contentTableView{
    if (!_contentTableView){
        _contentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.segmentPanel.height, self.contentView.width, self.contentView.height-self.segmentPanel.height)];
        _contentTableView.backgroundColor = RGB(238, 238, 238);
        _contentTableView.dataSource = self;
        _contentTableView.delegate = self;
        _contentTableView.clipsToBounds = NO;
        _contentTableView.pagingEnabled = NO;
        
        _contentTableView.showsVerticalScrollIndicator = NO;
        
    }
    return _contentTableView;
}

-(ZHSwipSegment *)catagoryList{
    if (!_catagoryList){
        
        NSMutableArray* items = [[NSMutableArray alloc]initWithCapacity:self.model.productList.count];
        [items addObject:@"全部"];
        for (SecondCatagoryModel* sc in self.model.productList){
            if (!isEmptyString(sc.title)){
                [items addObject:sc.title];
            }
        }
        
        _catagoryList = [[ZHSwipSegment alloc]initWithFrame:CGRectMake(0, self.contentView.top, self.view.width, 40) segments:items];
        _catagoryList.segmentDelegate = self;
        
        [_catagoryList touchEndedBlock:^(NSSet *touches, UIEvent *event) {
            self.resumeDelay = YES;
            ZHLOG(@"resume delay");
        }];
    }
    
    return _catagoryList;
}

-(ZHSegmentView *)segmentView{
    if (!_segmentView){
        _segmentView = [[ZHSegmentView alloc]initWithFrame:CGRectMake(12, 12, self.view.width-20, 28) segments:@[@"价格",@"人气",@"上市时间"]];
        _segmentView.segmentDelegate = self;
    }
    
    return _segmentView;
}

-(UIView *)segmentPanel{
    if (!_segmentPanel){
        _segmentPanel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 52)];
        _segmentPanel.backgroundColor = WHITE_BACKGROUND;
        _segmentPanel.layer.borderColor = GRAY_LINE.CGColor;
        _segmentPanel.layer.borderWidth = 0.5;
        
        [self.segmentPanel addSubview:self.segmentView];
    }
    
    return _segmentPanel;
}

-(void)loadRequest{
    [HttpClient requestDataWithParamers:nil success:^(id responseObject) {
        
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
    
    [self.contentTableView reloadData];
    [self resumeNormal];
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


#pragma -mark timer to resume normal state
-(void)resumeNormal{
    self.catagoryList.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.top = self.catagoryList.height+self.contentBounds.origin.y;
    }];
    
    [[Timer instance]removeTarget:self];
    [[Timer instance]fireAfter:5 target:self action:@selector(normalAction)];
    
    self.resumeDelay = NO;
}

-(void)normalAction{
    if (self.resumeDelay){
        [self resumeNormal];
        return;
    }
    
    if (self.contentBounds.origin.y == self.contentView.top){
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self doNormal];
    } completion:^(BOOL finished) {
        self.catagoryList.hidden = YES;
    }];
}

-(void)doNormal{
    self.contentView.top = self.contentBounds.origin.y;
 
}


#pragma -mark UIScrollViewDelegate
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"%lf",scrollView.contentOffset.y);
    
    if (scrollView.contentOffset.y < 0){
        self.needResume = YES;
        //        [self resumeNormal];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"%lf",scrollView.contentOffset.y);
    CGFloat yOffset = scrollView.contentOffset.y;
    
    if (yOffset == 0 && self.needResume){
        self.needResume = NO;
        [self resumeNormal];
    }
}


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
        if (scrollView.contentOffset.y - self.direct > 0){
            ZHLOG(@"UP");
            
            [self hideSegment];
        }
        else if (scrollView.contentOffset.y - self.direct < 0){
            ZHLOG(@"DOWN");
            
            [self showSegment];
        }
        self.startScroll = NO;
    }
}


#pragma -mark segment animation
-(void)hideSegment{
    [UIView animateWithDuration:0.3 animations:^{
        self.segmentPanel.bottom = 0;
    } completion:^(BOOL finished) {
        self.segmentPanel.hidden = YES;
        
        [self doNormal];
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentTableView.frame = self.contentView.bounds;
    }];
}

-(void)showSegment{
    self.segmentPanel.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.segmentPanel.top = 0;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
       self.contentTableView.frame = CGRectMake(0, self.segmentPanel.bottom, self.contentView.width, self.contentView.height-self.segmentPanel.height);
    }];
}

#pragma -mark ZHSegmentViewDelegate
-(void)segment:(ZHSegmentView *)segment selectAtIndex:(NSInteger)index{

    if (segment == self.catagoryList){
        [self resumeNormal];
    }

    
    ZHLOG(@"segment:%@ Index :%d",[segment class],index);
}

@end
