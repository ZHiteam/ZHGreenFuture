//
//  ZHShoppingCatagory.m
//  ZHGreenFuture
//
//  Created by elvis on 8/31/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHShoppingCatagory.h"
#import "ZHCatagoryCell.h"

@interface ZHShoppingCatagory()<UITableViewDataSource,UITableViewDelegate,ZHCatagoryCellDelegate>

@property (nonatomic,strong)NSArray*    catagorys;

@end

@implementation ZHShoppingCatagory

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGB(238, 238, 238);
        self.dataSource = self;
        self.delegate = self;
        self.clipsToBounds = NO;
        
        self.showsVerticalScrollIndicator = NO;
        [self loadRequest];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)loadRequest{
    [HttpClient requestDataWithURL:@"" paramers:nil success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
#warning test data
    NSMutableArray* array = [[NSMutableArray alloc]initWithCapacity:10];
    CatagoryModel* model = [[CatagoryModel alloc]init];
    model.title = @"等米下锅";
    model.backgourndImageUrl = @"temp_liang";
    
    model.productList = [NSArray arrayWithObjects:@"通榆大米",@"小米",@"燕麦米",@"通榆大米",@"小米",@"燕麦米",@"小米",@"燕麦米", nil];
    
    [array addObject:model];

    
    for(int i = 0 ;i < 10; ++i){
        CatagoryModel* model = [[CatagoryModel alloc]init];
        model.title = @"等米下锅";
        model.backgourndImageUrl = @"temp_liang";
        
        model.productList = [NSArray arrayWithObjects:@"通榆大米",@"小米",@"燕麦米", nil];
        
        [array addObject:model];
    }
    self.catagorys = [array mutableCopy];
    
    [self reloadData];
}

#pragma -mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.catagorys.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeightAtIndex:indexPath];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identify = @"cell";
    
    ZHCatagoryCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell){
        cell = [[ZHCatagoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellDelegate = self;
    }
    
    if (indexPath.row < self.catagorys.count){
        CatagoryModel* model = self.catagorys[indexPath.row];
        cell.catagory = model;
        
        cell.height = [self cellHeightAtIndex:indexPath];
        cell.cellIndex = indexPath.row;
        [cell reloadData];
    }
    
    return cell;
}


-(CGFloat)cellHeightAtIndex:(NSIndexPath*)indexPath{
    CGFloat height = 0;
    
    if (indexPath.row < self.catagorys.count){
        CatagoryModel* model = self.catagorys[indexPath.row];
        
        int count = model.productList.count;
        if (count <=3){
            count +=3;
        }
        
        height = [ZHCatagoryCell getCellHeightWithCatagoryCount:count];
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@">>>>>didSelectRowAtIndexPath %@",indexPath);
}


#pragma -mark ZHCatagoryCellDelegate
-(void)catagorySelectedAtIndex:(NSIndexPath *)index{
    ZHLOG(@" catagorySelectedAtIndex index:%d subIndex:%d",index.section,index.row);
    
    if (index.section >= self.catagorys.count){
        return;
    }
    
    CatagoryModel* model = self.catagorys[index.section];
    
    if ( -1 == index.row){
        [[MessageCenter instance]performActionWithUserInfo:@{@"controller": @"ZHCatagoryVC"}];
    }
    else if (index.row < model.productList.count){
        
    }
}
@end
