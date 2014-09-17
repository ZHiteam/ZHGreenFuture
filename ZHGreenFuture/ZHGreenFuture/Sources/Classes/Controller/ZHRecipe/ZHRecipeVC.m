//
//  ZHRecipeVC.m
//  ZHGreenFuture
//
//  Created by admin on 14-8-30.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHRecipeVC.h"
#import "LunarCalendar.h"
#import <DBCamera/DBCameraContainerViewController.h>
#import <DBCamera/DBCameraViewController.h>
#import "RecipeCell.h"
#import "ZHTagsView.h"

#import "RecipeModel.h"

@interface ZHRecipeVC ()<DBCameraViewControllerDelegate,DBCameraViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>

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
    
    [self loadRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#warning TEST
-(void)loadRequest{
    NSArray* tags = @[@"解暑",@"夏季",@"清肠",@"粥",@"养生茶",@"润肺止咳"];
    NSMutableArray* tagArray = [[NSMutableArray alloc]initWithCapacity:tags.count];
    
    for (NSString* tag in tags){
        TagModel* model = [[TagModel alloc]init];
        model.tagName = tag;
        model.url = @"green://list?type=111";
        [tagArray addObject:model];
    }
    
    NSMutableArray* itemArray = [[NSMutableArray alloc]initWithCapacity:10];
    for (int i = 0 ; i < 10; ++i){
        RecipeItemModel* item = [[RecipeItemModel alloc]init];
        item.recipeId = [NSString stringWithFormat:@"20010100%d",i];
        [itemArray addObject:item];
    }
    
    self.recipeModel = [[RecipeModel alloc]init];
    self.recipeModel.tags = tagArray;
    self.recipeModel.recipeItemList = itemArray;
    
    [self autoResizeContent];
}

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
    
//    self.navigationBar.rightBarItem = [UIButton barItemWithTitle:@"" image:[UIImage themeImageNamed:@"btn_camera"] action:self selector:@selector(cameraAction)];
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
        
        _tagPanel = [[UIView alloc]initWithFrame:CGRectMake(self.contentBounds.origin.x, self.contentBounds.origin.y, self.view.width, 30+self.tagView.height+20)];
        
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
    }
    
    return _tagView;
}


-(UITableView *)recipeContent{
    if (!_recipeContent){
        _recipeContent = [[UITableView alloc]initWithFrame:CGRectMake(0, self.tagPanel.bottom, self.tagPanel.width, self.contentBounds.size.height-self.tagPanel.height)];
        _recipeContent.backgroundColor = RGB(238, 238, 238);
        _recipeContent.dataSource = self;
        _recipeContent.delegate = self;
        _recipeContent.clipsToBounds = NO;
        _recipeContent.pagingEnabled = NO;
        _recipeContent.separatorStyle = UITableViewCellSeparatorStyleNone;
        _recipeContent.showsVerticalScrollIndicator = NO;

    }
    
    return _recipeContent;
}

-(void)autoResizeContent{
    [self.tagView loadContentWithTags:self.recipeModel.tags];
    
    self.tagPanel.height = 30+self.tagView.height+20;
    [self.tagPanel viewWithTag:-111].top = self.tagPanel.height-1;
    
    self.recipeContent.frame = CGRectMake(0, self.tagPanel.bottom, self.tagPanel.width, self.contentBounds.size.height-self.tagPanel.height);
}
#pragma -mark -action
- (void)cameraAction{
    
    DBCameraContainerViewController *container = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    DBCameraViewController *cameraController = [DBCameraViewController initWithDelegate:self];
    [cameraController setUseCameraSegue:NO];
    [container setCameraViewController:cameraController];

    [container setFullScreenMode];
    
    UIViewController* mainVC = [MemoryStorage valueForKey:k_NAVIGATIONCTL];

    [mainVC presentViewController:container animated:YES completion:^{

    }];
}

#pragma -mark DBCameraViewControllerDelegate
- (void) dismissCamera:(id)cameraViewController{
    [cameraViewController restoreFullScreenMode];
    UIViewController* mainVC = [MemoryStorage valueForKey:k_NAVIGATIONCTL];
    [mainVC dismissViewControllerAnimated:YES completion:nil];
}

- (void) camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata{
    [cameraViewController restoreFullScreenMode];
    UIViewController* mainVC = [MemoryStorage valueForKey:k_NAVIGATIONCTL];
    [mainVC dismissViewControllerAnimated:YES completion:nil];
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObject:@"ZHRecipePublishVC" forKey:@"controller"];
    
    if (image){
        [dic setValue:image forKey:@"userinfo"];
        [[MessageCenter instance]performActionWithUserInfo:dic];
    }
}

#pragma -mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recipeModel.recipeItemList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [RecipeCell cellHeight];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identify= @"recipeCell";
    RecipeCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[RecipeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
//        cell = [RecipeCell instanceWithNibName:@"RecipeCell" bundle:nil owner:nil];
    }
    
    if (self.recipeModel.recipeItemList.count > indexPath.row) {
        RecipeItemModel* item = self.recipeModel.recipeItemList[indexPath.row];
        cell.recipeItem = item;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[MessageCenter instance]performActionWithUserInfo:@{@"controller": @"ZHRecipeDetailVC"}];
}

@end
