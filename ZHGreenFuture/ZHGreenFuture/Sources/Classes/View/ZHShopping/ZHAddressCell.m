//
//  ZHAddressCell.m
//  ZHGreenFuture
//
//  Created by elvis on 9/19/14.
//  Copyright (c) 2014 ZHiteam. All rights reserved.
//

#import "ZHAddressCell.h"
#import "ZHCheckbox.h"

@interface ZHAddressCell()
@property (nonatomic,strong) UIView*    contentPanel;
@property (nonatomic,strong) UILabel*   nameLabel;
@property (nonatomic,strong) UILabel*   phoneLabel;
@property (nonatomic,strong) UILabel*   addressLabel;
@property (nonatomic,strong) ZHCheckbox*    defaultAddress;
@property (nonatomic,strong) UIButton*      editBtn;
@property (nonatomic,strong) UIButton*      deleteBtn;
@end

@implementation ZHAddressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self){
        [self loadContent];
    }
    
    return self;
}

-(void)loadContent{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addSubview:self.contentPanel];
    [self.contentPanel addSubview:self.nameLabel];
    [self.contentPanel addSubview:self.phoneLabel];
    [self.contentPanel addSubview:self.addressLabel];
    
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 60, self.contentPanel.width, 1)];
    line.backgroundColor = GRAY_LINE;
    [self.contentPanel addSubview:line];
    
    [self.contentPanel addSubview:self.defaultAddress];
    [self.contentPanel addSubview:self.editBtn];
    [self.contentPanel addSubview:self.deleteBtn];
}

#pragma -mark getter start
-(UIView *)contentPanel{
    if (!_contentPanel){
        _contentPanel = [[UIView alloc]initWithFrame:CGRectMake(10, 10, self.width-20, [ZHAddressCell cellHeight]-20)];
        _contentPanel.backgroundColor = WHITE_BACKGROUND;
        _contentPanel.layer.cornerRadius = 3;
        _contentPanel.layer.masksToBounds = YES;
    }
    return _contentPanel;
}

-(UILabel *)nameLabel{
    
    if (!_nameLabel){
        _nameLabel = [UILabel labelWithText:@"" font:FONT(14) color:BLACK_TEXT textAlignment:NSTextAlignmentLeft];
        _nameLabel.frame = CGRectMake(10, 10, 60, 20);
    }
    
    return _nameLabel;
}

-(UILabel *)phoneLabel{
    
    if (!_phoneLabel){
        _phoneLabel = [UILabel labelWithText:@"" font:FONT(14) color:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft];
        _phoneLabel.frame = CGRectMake(self.nameLabel.right+10, self.nameLabel.top, 150, self.nameLabel.height);
    }
    
    return _phoneLabel;
}

-(UILabel *)addressLabel{
    if (!_addressLabel){
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.nameLabel.bottom, self.contentPanel.width-20, 20)];
        _addressLabel.font = FONT(14);
        _addressLabel.textColor = GRAY_LINE;
        _addressLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return _addressLabel;
}

-(ZHCheckbox *)defaultAddress{
    
    if (!_defaultAddress){
        _defaultAddress = [[ZHCheckbox alloc]initWithFrame:CGRectMake(10, 70, 20, 20)];
        UIButton* labelBtn = [[UIButton alloc]initWithFrame:CGRectMake(_defaultAddress.right+3, _defaultAddress.top, 60, _defaultAddress.height)];
        labelBtn.titleLabel.font = FONT(14);
        labelBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [labelBtn setTitle:@"设为默认" forState:UIControlStateNormal];
        [labelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [labelBtn setTouchUpInsideBlock:^(UIControl *ctl) {
            _defaultAddress.checked = !_defaultAddress.checked;
        }];
        
        [self.contentPanel addSubview:labelBtn];
    }
    
    return _defaultAddress;
}

-(UIButton *)editBtn{
    
    if (!_editBtn){
        _editBtn = [[UIButton alloc]initWithFrame:CGRectMake(160, self.defaultAddress.top, 50, 20)];
        [_editBtn setImage:[UIImage themeImageNamed:@"btn_edit_with_label"] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editAddressAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _editBtn;
}

-(UIButton *)deleteBtn{
    if (!_deleteBtn){
        _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.contentPanel.width-70, self.editBtn.top, 50, 20)];
        [_deleteBtn setImage:[UIImage themeImageNamed:@"btn_delete_with_label"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteAddressAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

#pragma -mark getter end

-(void)setModel:(AddressModel *)model{
    if (!model){
        return;
    }
    
    self.nameLabel.text = model.name;
    self.phoneLabel.text = model.phone;
    self.addressLabel.text = model.address;
    
    self.defaultAddress.checked = [model.currentAddress boolValue];
}

-(void)editAddressAction{
    
}

-(void)deleteAddressAction{
    
}

+(CGFloat)cellHeight{
    return 120;
}
@end
