//
//  ZHPlaceHolderTextView.h
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHPlaceHolderTextView : UITextView{
    NSString *placeholder;
    UIColor *placeholderColor;

    @private
    UILabel *placeHolderLabel;
}

@property(nonatomic, strong) UILabel *placeHolderLabel;
@property(nonatomic, strong) NSString *placeholder;
@property(nonatomic, strong) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end