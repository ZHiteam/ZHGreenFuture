//
//  ZHRecipeVC.m
//  ZHGreenFuture
//
//  Created by admin on 14-8-30.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHRecipeVC.h"
#import "LunarCalendar.h"
#import "RecipeCell.h"
#import "ZHTagsView.h"

#import "RecipeModel.h"

@interface ZHRecipeVC ()<UITableViewDataSource,UITableViewDelegate,ZHTagsViewDelegate>

@property (nonatomic,strong) UIView*            titleViewPanel;
@property (nonatomic,strong) UILabel*           weekLabel;
@property (nonatomic,strong) UILabel*           dateLabel;

@property (nonatomic,strong) ZHTagsView*        tagView;
@property (nonatomic,strong) UIView*            tagPanel;

@property (nonatomic,strong) UITableView*       recipeContent;

@property (nonatomic,strong)RecipeModel*        recipeModel;
@end

@implementation ZHRecipeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadContent];
    
//    [self loadRequest];
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadRequest{
    [HttpClient requestDataWithParamers:@{@"scene":@"6"}success:^(id responseObject) {
        FELOG(@"%@",responseObject);
        
        self.recipeModel = (RecipeModel*)[RecipeModel praserModelWithInfo:responseObject];
        
        [self autoResizeContent];
    } failure:^(NSError *error) {
        
    }];
}

//-(void)loadMore{
//    [HttpClient requestDataWithParamers:@{@"scene":@"6"}success:^(id responseObject) {
//        FELOG(@"%@",responseObject);
//        
//        self.recipeModel = (RecipeModel*)[RecipeModel praserModelWithInfo:responseObject];
//        
//        [self autoResizeContent];
//    } failure:^(NSError *error) {
//        
//    }];
//}

-(void)loadContent{
    [self loadTitleContent];
    
    [self.view addSubview:self.tagPanel];
    
    [self.view insertSubview:self.recipeContent belowSubview:self.tagPanel];
}

-(void)loadTitleContent{
    NSDate* date = [NSDate date];
    NSDateFormatter* formater = [[NSDateFormatter alloc]init];
    
    [formater setDateFormat: @"yyyy.MM.dd"];
    self.dateLabel.text = [formater stringFromDate:date];
    
    [formater setDateFormat:@"EE"];
    LunarCalendar* lunar = [date chineseCalendarDate];
    
    self.weekLabel.text = [NSString stringWithFormat:@"%@/%@",lunar.DayLunar,[formater stringFromDate:date]];///@"大暑/周一";
    
    [self.navigationBar setTitleView:self.titleViewPanel];
}

-(UIView *)titleViewPanel{
    if (!_titleViewPanel){
        _titleViewPanel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width-88, NAVIGATION_BAR_HEIGHT)];
        
        [_titleViewPanel addSubview:self.weekLabel];
        [_titleViewPanel addSubview:self.dateLabel];
        
        self.weekLabel.frame = CGRectMake(0, 2, _titleViewPanel.width, NAVIGATION_BAR_HEIGHT/3*2);
        self.dateLabel.frame = CGRectMake(0, NAVIGATION_BAR_HEIGHT/2, _titleViewPanel.width, NAVIGATION_BAR_HEIGHT/3);
    }
    
    return _titleViewPanel;
}

-(UILabel *)weekLabel{
    if (!_weekLabel){
        _weekLabel = [UILabel labelWithText:@"" font:FONT(18) color:WHITE_TEXT textAlignment:NSTextAlignmentCenter];
        
    }
    return _weekLabel;
}

-(UILabel *)dateLabel{
    if (!_dateLabel){
        _dateLabel = [UILabel labelWithText:@"" font:FONT(12) color:WHITE_TEXT textAlignment:NSTextAlignmentCenter];
    }
    
    return _dateLabel;
}

-(UIView *)tagPanel{
    if (!_tagPanel){
        self.tagView.frame = CGRectMake(0, 30, self.tagView.width, self.tagView.height);
        
        _tagPanel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 30+self.tagView.height+20)];
        
        UILabel* titleLabel = [UILabel labelWithText:@"大家都在关注：" font:FONT(14) color:RGB(0x77, 0x77, 0x77) textAlignment:NSTextAlignmentLeft];
        titleLabel.frame = CGRectMake(12, 5, self.view.width-12, 30);
        
        [_tagPanel addSubview:titleLabel];
        
        [_tagPanel addSubview:self.tagView];
        _tagPanel.backgroundColor = WHITE_BACKGROUND;
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, _tagPanel.height-1, _tagPanel.width, 1)];
        line.backgroundColor = GRAY_LINE;
        line.tag = -111;
        [_tagPanel addSubview:line];
        line.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    }
    return _tagPanel;
}

-(ZHTagsView *)tagView{
    if (!_tagView){
        
        _tagView = [[ZHTagsView alloc]initWithFrame:CGRectMake(0, 30, self.view.width, 10) tags:self.recipeModel.tags];
        _tagView.delegate = self;
    }
    
    return _tagView;
}


-(UITableView *)recipeContent{
    if (!_recipeContent){
        _recipeContent = [[UITableView alloc]initWithFrame:self.contentBounds];

        _recipeContent.backgroundColor = RGB(238, 238, 238);
        _recipeContent.dataSource = self;
        _recipeContent.delegate = self;
        _recipeContent.clipsToBounds = NO;
        _recipeContent.pagingEnabled = NO;
        _recipeContent.separatorStyle = UITableViewCellSeparatorStyleNone;
        _recipeContent.showsVerticalScrollIndicator = NO;
        
//        [_recipeContent addPullToRefreshWithActionHandler:^{
//            [_recipeContent.pullToRefreshView startAnimating];
//        }];
//        __block __typeof(self)recipeVc = self;
//        [_recipeContent addInfiniteScrollingWithActionHandler:^{
//            [recipeVc loadMore];
//        }];
    }
    
    return _recipeContent;
}


-(void)autoResizeContent{
    [self.tagView loadContentWithTags:self.recipeModel.tags];
    
    self.tagPanel.height = 30+self.tagView.height+20;
    [self.tagPanel viewWithTag:-111].top = self.tagPanel.height-1;

    [self.recipeContent reloadData];
}

#pragma -mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (0 == section) {
        return 1;
    }
    
    return self.recipeModel.recipeItemList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( 0 == indexPath.section){
        return self.tagPanel.height;
    }
    
    return [RecipeCell cellHeight];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ( 0 == indexPath.section){
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            [cell.contentView addSubview:self.tagPanel];
        }
        
        return cell;
    }
    
    static NSString* identify= @"recipeCell";
    RecipeCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[RecipeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    if (self.recipeModel.recipeItemList.count > indexPath.row) {
        RecipeItemModel* item = self.recipeModel.recipeItemList[indexPath.row];
        cell.recipeItem = item;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.section){
        return;
    }
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:2];
    [dic setObject:@"ZHRecipeDetailVC" forKey:@"controller"];
    if (indexPath.row < self.recipeModel.recipeItemList.count){
        RecipeItemModel* model = self.recipeModel.recipeItemList[indexPath.row];
        if (model){
            [dic setObject:model forKey:@"userinfo"];
        }
    }
    
    [[MessageCenter instance]performActionWithUserInfo:dic];
}

#pragma -mark ZHTagsViewDelegate
-(void)tagSelectWithId:(NSString *)tagId{
    if (isEmptyString(tagId)){
        return;
    }
    else if ([tagId isEqualToString:@"-1"]){
        return [self loadRequest];
    }
    
    [HttpClient requestDataWithParamers:@{@"scene":@"6",@"tagId":tagId}success:^(id responseObject) {
        FELOG(@"%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary* dic = (NSDictionary*)responseObject;
            if ([dic[@"recipeList"] isKindOfClass:[NSArray class]]){
                NSArray* arry = (NSArray*)dic[@"recipeList"];
                
                NSMutableArray* muData = [[NSMutableArray alloc]initWithCapacity:arry.count];
                for(id val in arry){
                    RecipeItemModel* item = (RecipeItemModel*)[RecipeItemModel praserModelWithInfo:val];
                    [muData addObject:item];
                }
                
                self.recipeModel.recipeItemList = [muData mutableCopy];
                
                [self autoResizeContent];
            }
        }

    } failure:^(NSError *error) {
        
    }];
}
@end
