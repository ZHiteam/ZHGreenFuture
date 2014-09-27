//
//  ZHCommentVC.m
//  ZHGreenFuture
//
//  Created by elvis on 9/24/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHCommentVC.h"
#import "RecipeCommentItemView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ZHAuthorizationVC.h"

@interface ZHCommentVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (nonatomic,strong) UITableView*       content;
@property (nonatomic,strong) UIView*            toolBar;
@property (nonatomic,strong) NSArray*           commentList;

@property (nonatomic,strong) TPKeyboardAvoidingScrollView*  commentView;
@property (nonatomic,strong) UIView*            comment;
@property (nonatomic,strong) UITextView*        edit;
@end

@implementation ZHCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadContent];
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadRequest{
    
    if(isEmptyString(self.recipeId)){
        return;
    }
    
    [HttpClient requestDataWithURL:@"serverAPI.action" paramers:@{@"scene":@"28",@"recipeId":self.recipeId} success:^(id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            if ([responseObject[@"commentList"]isKindOfClass:[NSArray class]]){
                NSArray* array = (NSArray*)responseObject[@"commentList"];
                NSMutableArray* muData = [[NSMutableArray alloc]initWithCapacity:array.count];
                
                for (id val in array){
                    CommentModel* item  =[CommentModel praserModelWithInfo:val];
                    if (item){
                        [muData addObject:item];
                    }
                }
                
                self.commentList = [muData mutableCopy];
                
                [self.content reloadData];
                if (self.commentList.count > 0){
                    [self.content scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                 
                }

            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)loadContent{
    if ([self.userInfo isKindOfClass:[NSString class]]){
        self.recipeId = self.userInfo;
    }
    
    self.navigationBar.title = @"全部评论";
    [self whithNavigationBarStyle];
    
    [self.view addSubview:self.content];
    [self.view addSubview:self.toolBar];
}

-(UITableView *)content{
    
    if (!_content){
        _content = [[UITableView alloc]initWithFrame:self.contentBounds];
        _content.height -= TAB_BAR_HEIGHT;
        _content.showsVerticalScrollIndicator = NO;
        _content.delegate = self;
        _content.dataSource = self;
        _content.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _content;
}

-(UIView *)toolBar{
    
    if (!_toolBar){
        _toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-TAB_BAR_HEIGHT, self.view.width, TAB_BAR_HEIGHT)];
        
        _toolBar.backgroundColor = GREEN_COLOR;
        
        UIButton* camera = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, TAB_BAR_HEIGHT, TAB_BAR_HEIGHT)];
        [camera setImage:[UIImage themeImageNamed:@"btn_comment"] forState:UIControlStateNormal];
        [_toolBar addSubview:camera];
        
        UIButton* upload = [[UIButton alloc]initWithFrame:CGRectMake(camera.left+5, 0, 150, TAB_BAR_HEIGHT)];
        [upload setTitle:@"评论" forState:UIControlStateNormal];
        [upload setTitleColor:WHITE_TEXT forState:UIControlStateNormal];
        [_toolBar addSubview:upload];
        
        UIControl* mask = [[UIControl alloc]initWithFrame:_toolBar.bounds];
        [_toolBar addSubview:mask];
        
        [mask addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _toolBar;
}

-(TPKeyboardAvoidingScrollView *)commentView{
    if (!_commentView){
        _commentView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.view.bounds];
        _commentView.backgroundColor = RGBA(0, 0, 0, 0);
    }
    return _commentView;
}

-(UIView *)comment{
    
    if (!_comment){
        _comment = [[UIView alloc]initWithFrame:CGRectMake(0, self.commentView.height-200, self.commentView.width, 200)];
        _comment.backgroundColor = WHITE_BACKGROUND;
        
        UIButton* cancle = [UIButton barItemWithTitle:@"取消" action:self selector:@selector(disMissEdit)];
        [cancle setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        cancle.frame = CGRectMake(10, 3, 40, 30);
        [_comment addSubview:cancle];
        
        UILabel* label = [UILabel labelWithText:@"评论" font:FONT(16) color:BLACK_TEXT textAlignment:NSTextAlignmentCenter];
        label.frame = CGRectMake(100, 0, _comment.width-200, 30);
        [_comment addSubview:label];
        
        UIButton* ok = [UIButton barItemWithTitle:@"发送" action:self selector:@selector(commentOK)];
        [ok setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
        ok.frame = CGRectMake(_comment.width-50, 3, 40, 30);
        [_comment addSubview:ok];
        
        _edit = [[UITextView alloc]initWithFrame:CGRectMake(10, 40, _comment.width-20, _comment.height-50)];
        _edit.layer.borderColor = GRAY_LINE.CGColor;
        _edit.layer.borderWidth = 1;
        _edit.layer.cornerRadius = 3;
        _edit.layer.masksToBounds = YES;
        _edit.autocorrectionType = UITextAutocorrectionTypeYes;
        _edit.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _edit.keyboardType = UIKeyboardTypeDefault;
//        _edit.returnKeyType = UIReturnKeyDone;
        _edit.delegate = self;
        [_comment addSubview:_edit];
        
        
        
        [self.commentView addSubview:self.comment];
        
    }
    return _comment;
}

#pragma -mark comment action
-(void)commentAction{
    if (![[[ZHAuthorizationVC shareInstance] authManager] isLogin])
    {
        [ZHAuthorizationVC showLoginVCWithCompletionBlock:^(BOOL isSuccess, id info) {
            if (isSuccess) {
                [self _commentAction];
            }
        }];
    }
    else{
        [self _commentAction];
    }
}

-(void)_commentAction{
    UIView* main = ((NavigationViewController*)[MemoryStorage valueForKey:k_NAVIGATIONCTL]).view;
    self.comment.top = self.comment.bottom;
    [main addSubview:self.commentView];
    [UIView animateWithDuration:0.3 animations:^{
        self.comment.bottom = self.commentView.height;
        self.commentView.backgroundColor = RGBA(0, 0, 0, 0.6);
    }];
}

-(void)disMissEdit{
    [self.edit resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.comment.top = self.comment.bottom;
        self.commentView.backgroundColor = RGBA(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        [self.commentView removeFromSuperview];
        self.edit.text = @"";
    }];
}

-(void)commentOK{
    if (isEmptyString(self.edit.text)){
        ALERT_MESSAGE(@"请输入评论内容");
        return;
    }
    
    DoAlertView* alert = [[DoAlertView alloc]init];
    [alert doYesNo:@"确定要评论？" yes:^(DoAlertView *alertView) {
        /// 评论
        [self doComment];
        
        [self disMissEdit];
    } no:^(DoAlertView *alertView) {
        
    }];
}

-(void)doComment{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:3];
    [dic setObject:@"29" forKey:@"scene"];
    // recipeId
    if (!isEmptyString(self.recipeId)){
        [dic setObject:self.recipeId forKey:@"recipeId"];
    }
    // content
    if (!isEmptyString(self.edit.text)){
        [dic setObject:self.edit.text forKey:@"content"];
    }
#warning 缺少userID,暂时屏蔽下面判断
    if (!isEmptyString([ZHAuthorizationManager shareInstance].userId)){
        [dic setObject:[ZHAuthorizationManager shareInstance].userId forKey:@"userId"];
    }
    // userid
//    
//    if (dic.count < 4){
//        return;
//    }
//    
    [HttpClient requestDataWithURL:@"serverAPI.action" paramers:dic success:^(id responseObject) {
        SHOW_MESSAGE(@"评论成功", 2);
        [self loadRequest];
    } failure:^(NSError *error) {
        SHOW_MESSAGE(@"评论失败", 2);
    }];
}

#pragma -mark UITableViewDataSource,UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentList.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecipeCommentItemView* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell){
        cell = [[RecipeCommentItemView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.lineTop = NO;
    }
    
    if (indexPath.row < self.commentList.count){
        cell.model = self.commentList[indexPath.row];
    }

    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [RecipeCommentItemView itemHeight];
}

@end
