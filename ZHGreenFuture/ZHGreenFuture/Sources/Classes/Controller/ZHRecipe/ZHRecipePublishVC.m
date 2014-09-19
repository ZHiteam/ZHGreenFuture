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
    
    if ([self.userInfo isKindOfClass:[UIImage class]]){
        self.images = [[NSMutableArray alloc]initWithObjects:self.userInfo, nil];
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

#pragma -mark done action
-(void)doneAction:(UIButton*)sender{
    [self.doneBtn setBackgroundColor:GRAY_LINE];
    [self performSelector:@selector(doneBgResume) withObject:nil afterDelay:0.2];
    
    ZHLOG(@"done");
}

-(void)doneBgResume{
    [self.doneBtn setBackgroundColor:GREEN_COLOR];
}

#pragma -mark CameraHelperDelegate
-(void)cameraTakePhotoSuccess:(UIImage *)image{
    [self.images addObject:image];
//    NSLog(@"%lf",image.size.height);
//    [self performSelector:@selector(layoutImages) withObject:nil afterDelay:0.5];
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
