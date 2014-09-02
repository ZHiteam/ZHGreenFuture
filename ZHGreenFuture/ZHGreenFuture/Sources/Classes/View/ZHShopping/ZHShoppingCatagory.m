//
//  ZHShoppingCatagory.m
//  ZHGreenFuture
//
//  Created by elvis on 8/31/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHShoppingCatagory.h"
#import "ZHCatagoryCell.h"
#import "SecondCatagoryModel.h"

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
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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
    
    [array addObject:[self getTestData:[NSArray arrayWithObjects:@"通榆大米",@"小米",@"燕麦米",@"通榆大米",@"小米",@"燕麦米",@"小米",@"燕麦米", nil]]];
    
    for(int i = 0 ;i < 10; ++i){
       
        [array addObject:[self getTestData:[NSArray arrayWithObjects:@"通榆大米",@"小米",@"燕麦米",@"通榆大米", nil]]];
    }
    self.catagorys = [array mutableCopy];
    
    [self reloadData];
}

-(CatagoryModel*)getTestData:(NSArray*)tempTest{
    NSMutableArray* mutableArray = [[NSMutableArray alloc]initWithCapacity:4];
    
//    NSArray* tempTest = [NSArray arrayWithObjects:@"通榆大米",@"小米",@"燕麦米",@"通榆大米",@"小米",@"燕麦米",@"小米",@"燕麦米", nil];
    
    static NSString* des1 = @"有机大米指的是栽种稻米的过程中，使用天然有机的栽种方式，完全采用自然农耕法种出来的大米。有机大米必须是种植改良场推荐的良质米品种，而且在栽培过程中不能使用化学肥料，农药和生长调节剂等。";
    static NSString* des2 = @"有机大米指的是栽种稻米的过程中，使用天然有机的栽种方式，完全采用自然农耕法种出来的大米。";
    
    for(NSString* str in tempTest){
        
        SecondCatagoryModel* second = [[SecondCatagoryModel alloc]init];
        second.title = str;
        second.descript = rand()%2?des1:des2;
        second.imageUrl = @"";
        [mutableArray addObject:second];
    }
    
    CatagoryModel* model = [[CatagoryModel alloc]init];
    model.title = @"等米下锅";
    model.backgourndImageUrl = @"temp_liang";
    model.productList = [mutableArray mutableCopy];
    
    return model;
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
        SecondCatagoryModel* secondModel = model.productList[index.row];
        [[MessageCenter instance]performActionWithUserInfo:@{@"controller": @"ZHSubCatagoryVC",@"userinfo":secondModel}];
    }
}
@end
