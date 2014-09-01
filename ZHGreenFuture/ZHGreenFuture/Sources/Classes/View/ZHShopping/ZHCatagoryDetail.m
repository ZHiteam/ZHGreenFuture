//
//  ZHCatagoryDetail.m
//  ZHGreenFuture
//
//  Created by elvis on 9/1/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHCatagoryDetail.h"
#import "ZHProductTableViewCell.h"
#import "ZHHomePageModel.h"
#import "ZHSegmentView.h"
#import "ZHSwipSegment.h"
#import "UIView+FETouchBlocks.h"

@interface ZHCatagoryDetail()<UITableViewDataSource,UITableViewDelegate,ZHSegmentViewDelegate>

@property (nonatomic,strong) ZHSwipSegment*     catagoryList;

@property (nonatomic,strong) NSArray*   productList;
@property (nonatomic,strong) NSTimer*   resumeTimer;
@property (nonatomic,assign) BOOL       needResume;
@property (nonatomic,assign) BOOL       resumeDelay;

@property (nonatomic,strong) ZHSegmentView*  segmentView;
@property (nonatomic,strong) UIView*         segmentPanel;


@end

@implementation ZHCatagoryDetail

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self loadContent];
        [self loadRequest];
    }
    return self;
}

-(void)loadContent{
    self.backgroundColor = RGB(238, 238, 238);
    self.dataSource = self;
    self.delegate = self;
    self.clipsToBounds = NO;
    self.pagingEnabled = NO;
    
    self.showsVerticalScrollIndicator = NO;
    
    [self addSubview:self.catagoryList];
    
}

-(ZHSwipSegment *)catagoryList{
    if (!_catagoryList){
        _catagoryList = [[ZHSwipSegment alloc]initWithFrame:CGRectMake(0, -40, self.width, 40) segments:@[@"全部",@"通榆大米",@"小米",@"燕麦米",@"通榆大米",@"小米",@"燕麦米"]];
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
        _segmentView = [[ZHSegmentView alloc]initWithFrame:CGRectMake(12, 12, self.width-20, 28) segments:@[@"价格",@"人气",@"上市时间"]];
        _segmentView.segmentDelegate = self;
    }
    
    return _segmentView;
}

-(UIView *)segmentPanel{
    if (!_segmentPanel){
        _segmentPanel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 52)];
        _segmentPanel.backgroundColor = WHITE_BACKGROUND;
        _segmentPanel.layer.borderColor = GRAY_LINE.CGColor;
        _segmentPanel.layer.borderWidth = 0.5;
        
        [self.segmentPanel addSubview:self.segmentView];
    }
    
    return _segmentPanel;
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
    
    [self reloadData];
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

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.segmentPanel;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 52;
}
#pragma -mark rewrite methods
-(void)reloadData{
    [super reloadData];
    
    [self resumeNormal];
}

#pragma -mark timer to resume normal state
-(NSTimer *)resumeTimer{
    _resumeTimer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(normalAction) userInfo:nil repeats:NO];
    
    return _resumeTimer;
}

-(void)resumeNormal{
    [self setContentOffset:CGPointMake(0, -40) animated:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.resumeTimer forMode:NSRunLoopCommonModes];
    
    self.resumeDelay = NO;
    
    
}

-(void)normalAction{
    
    if (self.resumeDelay){
        [self resumeNormal];
        return;
    }
    
    if (self.contentOffset.y < 0){
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
    }

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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 50){
//        self.sectionHeaderHeight = 0;
    }
}

#pragma -mark ZHSegmentViewDelegate
-(void)segment:(ZHSegmentView *)segment selectAtIndex:(NSInteger)index{
    ZHLOG(@"segment:%@ Index :%d",[segment class],index);
}
@end
