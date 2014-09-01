//
//  ZHShoppingCatagory.m
//  ZHGreenFuture
//
//  Created by elvis on 8/31/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHShoppingCatagory.h"

@interface ZHShoppingCatagory()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ZHShoppingCatagory

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        // Initialization code
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
}

#pragma -mark UITableViewDataSource,UITableViewDelegate
@end
