//
//  ZHRecipePubilshVC.m
//  ZHGreenFuture
//
//  Created by elvis on 9/3/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHRecipePublishVC.h"

#define IMAGE_SPAN  12
#define IMAGE_WIDTH 65
#define IMAGE_TAG_START -10001

@interface ZHRecipePublishVC ()

@property (nonatomic,strong) NSMutableArray*       imageViews;
@property (nonatomic,strong) UIControl*            addButton;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadContent{
    
    self.navigationBar.title = @"发布菜谱";
    
    UIButton* rightItem = [UIButton barItemWithTitle:@"发布" action:self selector:@selector(done)];
    [rightItem setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    [rightItem setTitleColor:GRAY_LINE forState:UIControlStateHighlighted];
    self.navigationBar.rightBarItem = rightItem;
    
    
    [self whithNavigationBarStyle];
    
    int count = self.imageViews.count;
    
    CGFloat xOffset = IMAGE_SPAN;
    CGFloat yOffset = 100;
    for (int i = 0; i < count ; ++i){
        UIImageView* view = self.imageViews[i];
        
        view.frame = CGRectMake(xOffset, yOffset, IMAGE_WIDTH, IMAGE_WIDTH);
        [self.view addSubview:view];
        
        xOffset += IMAGE_WIDTH+IMAGE_SPAN;
        
        if ( (i+1)%4 ==0 ){
            yOffset += IMAGE_SPAN+IMAGE_WIDTH;
            xOffset = IMAGE_SPAN;
        }
    }
    
    self.addButton.frame = CGRectMake(xOffset, yOffset, IMAGE_WIDTH, IMAGE_WIDTH);
    [self.view addSubview:self.addButton];
}


-(NSMutableArray *)imageViews{
    if (!_imageViews){
        _imageViews = [[NSMutableArray alloc]initWithCapacity:1];
        
        for (int i =0; i < self.images.count; ++i){
            UIButton* imageView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_WIDTH)];
            
            imageView.layer.borderColor = GRAY_LINE.CGColor;
            
            imageView.layer.borderWidth = 1;
            
            [imageView setImage:self.images[i] forState:UIControlStateNormal];

            [imageView addTarget:self action:@selector(imageChangeAction:) forControlEvents:UIControlEventTouchUpInside];
            
            imageView.tag = IMAGE_TAG_START+i;
            
            [_imageViews addObject:imageView];
        }
    }
    
    return _imageViews;
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

#pragma -mark image action
-(void)imageChangeAction:(id)sender{
    ZHLOG(@"image change action %@",sender);
}

-(void)addImageAction{
    ZHLOG(@"add image action");
}

#pragma -mark done action
-(void)done{
    ZHLOG(@"done");
}
@end
