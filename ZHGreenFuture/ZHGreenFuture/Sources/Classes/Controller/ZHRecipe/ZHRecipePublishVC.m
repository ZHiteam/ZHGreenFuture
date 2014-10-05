//
//  ZHRecipePubilshVC.m
//  ZHGreenFuture
//
//  Created by elvis on 9/3/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHRecipePublishVC.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "ZHPlaceHolderTextView.h"
#import "CameraHelper.h"
#import "ASProgressPopUpView.h"

#define IMAGE_SPAN  12
#define IMAGE_WIDTH 65
#define IMAGE_TAG_START -10001

/// 最大输入字数
#define MAX_ENTER_COUNT  1000
/// 最大照片数
#define MAX_IMAGE_UPLOAD_COUNT  9

@interface ZHRecipePublishVC ()<UITextViewDelegate,CameraHelperDelegate>

@property (nonatomic,strong) TPKeyboardAvoidingScrollView*  content;
@property (nonatomic,strong) UIView*                sampleImagePanel;
@property (nonatomic,strong) NSMutableArray*        imageViews;
@property (nonatomic,strong) UIControl*             addButton;

@property (nonatomic,strong) UIButton*              doneBtn;
@property (nonatomic,strong) ZHPlaceHolderTextView*            descEdit;
@property (nonatomic,strong) NSString*                         textEntered;
@property (nonatomic,strong) ASProgressPopUpView*   progressView;
@property (nonatomic,strong) UIView*                progressPanel;
@end

@implementation ZHRecipePublishVC

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
    
    if ([self.userInfo isKindOfClass:[NSDictionary class]]){
        if ([self.userInfo[@"image"] isKindOfClass:[UIImage class]])
        self.images = [[NSMutableArray alloc]initWithObjects:self.userInfo[@"image"], nil];
        self.recipeId = self.userInfo[@"recipeId"];
    }
    
    [self loadContent];
}

-(void)viewWillAppear:(BOOL)animated{
    [self layoutImages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadContent{
    
    self.navigationBar.title = @"上传作品";
//    
//    UIButton* rightItem = [UIButton barItemWithTitle:@"发布" action:self selector:@selector(done)];
//    [rightItem setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
//    [rightItem setTitleColor:GRAY_LINE forState:UIControlStateHighlighted];
//    self.navigationBar.rightBarItem = rightItem;
    
    
    [self whithNavigationBarStyle];
    
    [self.view addSubview:self.content];
    
    [self.content addSubview:self.descEdit];
    
    [self.content addSubview:self.sampleImagePanel];
    
    [self.content addSubview:self.doneBtn];

}

-(TPKeyboardAvoidingScrollView *)content{
    if (!_content){
        _content = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:self.contentBounds];
    }
    
    return _content;
}


-(NSMutableArray *)imageViews{
    if (!_imageViews){
        _imageViews = [[NSMutableArray alloc]initWithCapacity:1];
        
        for (int i =0; i < self.images.count; ++i){
            UIButton* imageView = [self createImageViewAtIndex:i];
            
            [_imageViews addObject:imageView];
        }
    }
    
    return _imageViews;
}

-(UIButton*)createImageViewAtIndex:(NSInteger)index{
    UIButton* imageView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_WIDTH)];
    
    imageView.layer.borderColor = GRAY_LINE.CGColor;
    
    imageView.layer.borderWidth = 1;
    
    imageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    imageView.imageView.clipsToBounds = YES;
    
    if (index < self.images.count){
        [imageView setImage:self.images[index] forState:UIControlStateNormal];
    }
    
    [imageView addTarget:self action:@selector(imageChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    imageView.tag = IMAGE_TAG_START+index;
    
    return imageView;
}

-(UIButton *)doneBtn{
    
    if (!_doneBtn){
        _doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, self.addButton.bottom+IMAGE_SPAN, self.view.width-24, 48)];
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_doneBtn setTitleColor:WHITE_TEXT forState:UIControlStateNormal];
        
        _doneBtn.backgroundColor = GREEN_COLOR;
        
        [_doneBtn addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _doneBtn;
}

-(ZHPlaceHolderTextView *)descEdit{
    
    if (!_descEdit){
        _descEdit = [[ZHPlaceHolderTextView alloc]initWithFrame:CGRectMake(10, 5, self.view.width-20, 80)];
        _descEdit.font = FONT(14);
        _descEdit.delegate = self;
        
        _descEdit.placeholder = @"描述一下自己的作品吧...";
    }
    
    return _descEdit;
}

-(UIView *)sampleImagePanel{
    
    if (!_sampleImagePanel){
        _sampleImagePanel = [[UIView alloc]initWithFrame:CGRectMake(0, self.descEdit.bottom+10, self.view.width, IMAGE_SPAN+IMAGE_WIDTH)];
    }
    
    return _sampleImagePanel;
}

-(UIControl *)addButton{
    if (!_addButton){
        _addButton = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_WIDTH)];
        
        UIView* crossLineH = [[UIView alloc]initWithFrame:CGRectMake(IMAGE_WIDTH/4, IMAGE_WIDTH/2-2, IMAGE_WIDTH/2, 4)];
        crossLineH.backgroundColor = GRAY_LINE;
        [_addButton addSubview:crossLineH];
        
        UIView* crossLineV = [[UIView alloc]initWithFrame:CGRectMake(IMAGE_WIDTH/2-2, IMAGE_WIDTH/4, 4, IMAGE_WIDTH/2)];
        crossLineV.backgroundColor = GRAY_LINE;
        [_addButton addSubview:crossLineV];
        
        _addButton.layer.borderColor = GRAY_LINE.CGColor;
        _addButton.layer.borderWidth = 1;
        
        [_addButton addTarget:self action:@selector(addImageAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addButton;
}

-(void)layoutImages{
//    int count = self.imageViews.count;
    int count = self.images.count;
    
    [self.sampleImagePanel removeAllSubviews];
    
    CGFloat xOffset = IMAGE_SPAN;
    CGFloat yOffset = 10;
    for (int i = 0; i < count ; ++i){

        UIButton* view = nil;
        
        if (self.imageViews.count > i){
            view = self.imageViews[i];
        }
        else{
            
            view = [self createImageViewAtIndex:i];
            
            [self.imageViews addObject:view];
        }
        
        view.frame = CGRectMake(xOffset, yOffset, IMAGE_WIDTH, IMAGE_WIDTH);

        [view setImage:self.images[i] forState:UIControlStateNormal];
        
        [self.sampleImagePanel addSubview:view];
        
        xOffset += IMAGE_WIDTH+IMAGE_SPAN;
        
        if ( (i+1)%4 ==0 ){
            yOffset += IMAGE_SPAN+IMAGE_WIDTH;
            xOffset = IMAGE_SPAN;
        }
    }
    
    self.addButton.frame = CGRectMake(xOffset, yOffset, IMAGE_WIDTH, IMAGE_WIDTH);
    
    [self.sampleImagePanel addSubview:self.addButton];
    
    self.sampleImagePanel.height = self.addButton.bottom;
    
    self.doneBtn.top = self.sampleImagePanel.bottom + IMAGE_SPAN;
}

-(UIView *)progressPanel{
    
    if (!_progressPanel){
        _progressPanel = [[UIView alloc]initWithFrame:self.view.bounds];
        _progressPanel.backgroundColor = RGBA(0, 0, 0, 0.8);
    }
    
    return _progressPanel;
}

-(ASProgressPopUpView *)progressView{
    
    if (!_progressView){
        _progressView = [[ASProgressPopUpView alloc]initWithFrame:CGRectMake(20, self.progressPanel.height/2-1, self.progressPanel.width-40, 2)];
        _progressView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
        _progressView.popUpViewAnimatedColors = @[[UIColor redColor], [UIColor orangeColor], [UIColor greenColor]];
        [_progressView showPopUpViewAnimated:YES];
        [self.progressPanel addSubview:_progressView];
    }
    
    return _progressView;
}

#pragma -mark image action
-(void)imageChangeAction:(id)sender{
    ZHLOG(@"image change action %@",sender);
    UIButton* btn = (UIButton*)sender;
    int index = btn.tag - IMAGE_TAG_START;
    
    if (self.images.count == 0){
        return;
    }
    NSDictionary* userInfo = @{@"controller":@"ZHImagePreviewVC",
                               @"userinfo":@{
                                       @"images":self.images,
                                       @"selectIndex":[NSString stringWithFormat:@"%d",index]
                                       }
                               };
    
    [[MessageCenter instance]performActionWithUserInfo:userInfo];
}

-(void)addImageAction{
//    ZHLOG(@"add image action");
    
    if (self.images.count >= MAX_IMAGE_UPLOAD_COUNT){
        ALERT_MESSAGE(@"已达上传照片数上限");
        return;
    }
    
    [self cameraAction];
}

-(void)showProgress{
    UIView* main = ((NavigationViewController*)[MemoryStorage valueForKey:k_NAVIGATIONCTL]).view;
    self.progressView.progress = 0.0f;
    [main addSubview:self.progressPanel];
}

-(void)stopProgress{
    [self.progressPanel removeFromSuperview];
    self.progressView.progress = 0.0f;
}

#pragma -mark done action
-(void)doneAction:(UIButton*)sender{
    [self.doneBtn setBackgroundColor:GRAY_LINE];
    [self performSelector:@selector(doneBgResume) withObject:nil afterDelay:0.2];
    
    ZHLOG(@"done");
    
    if (isEmptyString(self.descEdit.text)){
        SHOW_MESSAGE(@"请输入描述", 2);
        return;
    }
    
    if (self.images.count < 1){
        SHOW_MESSAGE(@"至少上传一张图片", 2);
        return;
    }
    
//    userId 用户id
//    userNickName 用户昵称
//    recipeId 食谱id
//    title 作品标题
//    workImageData 作品图片二进制
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithCapacity:5];
    [dic setObject:@"9" forKey:@"scene"];
//#warning 判断用户登录,userID
    if (!isEmptyString([ZHAuthorizationManager shareInstance].userId)){
        [dic setObject:[ZHAuthorizationManager shareInstance].userId forKey:@"userId"];
    }
    
    if (!isEmptyString(self.recipeId)){
        [dic setObject:self.recipeId forKey:@"recipeId"];
    }
    
    [dic setObject:self.descEdit.text forKey:@"title"];
    
    
    NSMutableArray* imgDataArray = [[NSMutableArray alloc]initWithCapacity:self.images.count];
    for (int  i= 0 ; i < self.images.count; ++i){
        UIImage* img = self.images[i];
        if ([img isKindOfClass:[UIImage class]]){
            NSData *dataObj = UIImageJPEGRepresentation(img, 0.75);
            [imgDataArray addObject:dataObj];
//#warning 應该是多张图片，接口暂时只有一张图片，因此 break
//            break;
        }
    }
    NSDictionary* imageData = @{@"workImageData":imgDataArray};
    
    [self showProgress];
    
    [HttpClient upLoadDataWithParamers:dic datas:imageData success:^(id responseObject) {
        BaseModel* model = [BaseModel praserModelWithInfo:responseObject];
        if ([model.state boolValue]){
            SHOW_MESSAGE(@"上传成功", 2);
        }
        else{
            SHOW_MESSAGE(@"上传失败", 2);
        }
        
        [self stopProgress];

    } failure:^(NSError *error) {
        SHOW_MESSAGE(@"上传失败", 2);
        
        [self stopProgress];
    } progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        self.progressView.progress = totalBytesWritten*1.0/totalBytesExpectedToWrite;
    }];
}

-(void)doneBgResume{
    [self.doneBtn setBackgroundColor:GREEN_COLOR];
}

#pragma -mark CameraHelperDelegate
-(void)cameraTakePhotoSuccess:(UIImage *)image{
    [self.images addObject:image];
}

#pragma -mark -action
- (void)cameraAction{
    [CameraHelper takePhone:self];
}

#pragma -mark UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString* newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (newText.length > MAX_ENTER_COUNT){
        return NO;
    }
    self.textEntered = newText;
    return YES;
}
@end
