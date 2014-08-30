//
//  ZHRootViewController.m
//  ZHGreenFuture
//
//  Created by admin on 14-8-30.
//  Copyright (c) 2014年 ZHiteam. All rights reserved.
//

#import "ZHRootViewController.h"
#import "ZHHomePageVC.h"
#import "ZHShoppingVC.h"
#import "ZHRecipeVC.h"
#import "ZHProfileVC.h"


@interface ZHRootViewController ()<TabbarControllerDelegate,TabbarDelegate>
@property(nonatomic, strong)NSArray               *tabbarVCItems;
@property(nonatomic, strong)TabbarViewController  *tabCtl;
@end

@implementation ZHRootViewController

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
    
    [self prepare];
    [self enterHome];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)prepare{
    [MemoryStorage setValue:self forKey:k_NAVIGATIONCTL];
    
    self.hasNavitaiongBar = NO;

}

-(void)enterHome{
    [self createTabbarVCItems];
    [self pushViewController:self.tabCtl animation:ANIMATE_TYPE_NONE];
    [self.tabCtl reloadData];
}


- (TabbarViewController *)tabCtl{
    if (_tabCtl == nil) {
        _tabCtl = [[TabbarViewController alloc]init];
        _tabCtl.hasNavitaiongBar = NO;
        _tabCtl.delegate = self;
        _tabCtl.dataSource = self;
    }
    return _tabCtl;
}

#pragma mark - Private Method
- (void)createTabbarVCItems{
    self.tabbarVCItems = @[[[ZHHomePageVC alloc] init], [[ZHShoppingVC alloc] init], [[ZHRecipeVC alloc] init],[[ZHProfileVC alloc] init]];
}

#pragma mark - Override

#pragma - mark TabbarDataSource
-(NSUInteger)numberOfItems{
    return TABBAR_COUNT;
}


-(TabbarItem *)tabbar:(TabbarView *)tabbar itemAtIndex:(NSUInteger)index{
    if (index >= TAB_BAR_HEIGHT ) {
        return nil;
    }
    
    NSString*   image = @"";
    NSString*   selectedImage = @"";
    
    switch (index) {
        case 0:
        {
            image = @"bar_item_01";
            selectedImage = @"bar_item_selected_01";
        }
            break;
        case 1:
        {
            image = @"bar_item_02";
            selectedImage = @"bar_item_selected_02";
        }
            break;
        case 2:
        {
            image = @"bar_item_01";
            selectedImage = @"bar_item_selected_01";
        }
            break;
        case 3:
        {
            image = @"bar_item_01";
            selectedImage = @"bar_item_selected_01";
        }
            break;
        default:
            break;
    }
    TabbarItem* item = [[TabbarItem alloc]initWithFrame:CGRectMake(0, 0, 0, 0) image:[UIImage themeImageNamed:image] selectedImage:[UIImage themeImageNamed:selectedImage]];
    
    return item;
}

#pragma mark - TabbarControllerDelegate
-(ZHViewController*)tabbarCtl:(TabbarViewController*)tabbarCtl viewControllerAtIndex:(NSUInteger)aIndex{
    if (aIndex < [self.tabbarVCItems count]) {
        ZHViewController* vc = [self.tabbarVCItems objectAtIndex:aIndex];
        vc.viewFrame = CGRectMake(0, 0, self.view.width,self.view.height-tabbarCtl.tabbarHeight);

//        vc.hasNavitaiongBar = NO;
        return vc;
    }
    return nil;
}


@end
