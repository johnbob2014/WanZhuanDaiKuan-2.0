//
//  DetailsTableViewCell.m
//  房贷计算器
//
//  Created by 张保国 on 15/7/11.
//  Copyright (c) 2015年 CutePanda. All rights reserved.
//

#import "DetailsTableViewCell.h"
#import "UIView+AEBHandyAutoLayout.h"
@interface DetailsTableViewCell()
@property (strong,nonatomic) UILabel *l0;
@property (strong,nonatomic) UILabel *l1;
@property (strong,nonatomic) UILabel *l2;
@property (strong,nonatomic) UILabel *l3;
@property (strong,nonatomic) UILabel *l4;
@property (strong,nonatomic) UILabel *l5;
@property (strong,nonatomic) UILabel *l6;
@property (strong,nonatomic) UILabel *l7;
@property (strong,nonatomic) UILabel *l8;
@end

@implementation DetailsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        UIApplication *app=[UIApplication sharedApplication];
        UIInterfaceOrientation currentOrientation=app.statusBarOrientation;
        
        _l0=[UILabel new];
        _l0.font=_labelFont;
        _l0.textAlignment=NSTextAlignmentCenter;
        [self.contentView addSubview:_l0];
        _l0.translatesAutoresizingMaskIntoConstraints=NO;
        
        _l1=[UILabel new];
        [self.contentView addSubview:_l1];
        _l1.translatesAutoresizingMaskIntoConstraints=NO;
        _l1.font=_labelFont;
        _l1.textAlignment=NSTextAlignmentCenter;
        
        _l2=[UILabel new];
        [self.contentView addSubview:_l2];
        _l2.translatesAutoresizingMaskIntoConstraints=NO;
        _l2.font=_labelFont;
        _l2.textAlignment=NSTextAlignmentRight;
        
        _l3=[UILabel new];
        [self.contentView addSubview:_l3];
        _l3.translatesAutoresizingMaskIntoConstraints=NO;
        _l3.font=_labelFont;
        _l3.textAlignment=NSTextAlignmentRight;
        
        _l4=[UILabel new];
        [self.contentView addSubview:_l4];
        _l4.translatesAutoresizingMaskIntoConstraints=NO;
        _l4.font=_labelFont;
        _l4.textAlignment=NSTextAlignmentRight;

        _l5=[UILabel new];
        [self.contentView addSubview:_l5];
        _l5.translatesAutoresizingMaskIntoConstraints=NO;
        _l5.font=_labelFont;
        _l5.textAlignment=NSTextAlignmentRight;

        _l6=[UILabel new];
        [self.contentView addSubview:_l6];
        _l6.translatesAutoresizingMaskIntoConstraints=NO;
        _l6.font=_labelFont;
        _l6.textAlignment=NSTextAlignmentRight;

        _l7=[UILabel new];
        [self.contentView addSubview:_l7];
        _l7.translatesAutoresizingMaskIntoConstraints=NO;
        _l7.font=_labelFont;
        _l7.textAlignment=NSTextAlignmentRight;

        _l8=[UILabel new];
        [self.contentView addSubview:_l8];
        _l8.translatesAutoresizingMaskIntoConstraints=NO;
        _l8.font=_labelFont;
        _l8.textAlignment=NSTextAlignmentRight;

        
        //所有标签的上部和高度都是固定的，上部位置紧贴contentView，高度等于contentView
        [self.contentView addConstraints:[_l0 constraintsAssignTop]];
        [self.contentView addConstraint:[_l0 constraintHeightEqualToView:self.contentView]];
        [self.contentView addConstraints:[_l1 constraintsAssignTop]];
        [self.contentView addConstraint:[_l1 constraintHeightEqualToView:self.contentView]];
        [self.contentView addConstraints:[_l2 constraintsAssignTop]];
        [self.contentView addConstraint:[_l2 constraintHeightEqualToView:self.contentView]];
        [self.contentView addConstraints:[_l3 constraintsAssignTop]];
        [self.contentView addConstraint:[_l3 constraintHeightEqualToView:self.contentView]];
        [self.contentView addConstraints:[_l4 constraintsAssignTop]];
        [self.contentView addConstraint:[_l4 constraintHeightEqualToView:self.contentView]];
        [self.contentView addConstraints:[_l5 constraintsAssignTop]];
        [self.contentView addConstraint:[_l5 constraintHeightEqualToView:self.contentView]];
        [self.contentView addConstraints:[_l6 constraintsAssignTop]];
        [self.contentView addConstraint:[_l6 constraintHeightEqualToView:self.contentView]];
        [self.contentView addConstraints:[_l7 constraintsAssignTop]];
        [self.contentView addConstraint:[_l7 constraintHeightEqualToView:self.contentView]];
        [self.contentView addConstraints:[_l8 constraintsAssignTop]];
        [self.contentView addConstraint:[_l8 constraintHeightEqualToView:self.contentView]];
        
        //仅需要区分屏幕方向的不同，设置不同的左部和宽度
        //CGFloat contentViewWidth=self.contentView.frame.size.width;
        
        if (UIInterfaceOrientationIsPortrait(currentOrientation)) {
            _l5.hidden=YES;
            _l6.hidden=YES;
            _l7.hidden=YES;
            _l8.hidden=YES;
            //显示5个标签，6个空格
            CGFloat contentViewWidth=[[UIScreen mainScreen]bounds].size.width;
            CGFloat blankSpaceWidth=contentViewWidth*0.1/7;
            
            [self.contentView addConstraint:[_l0 constraintWidth:contentViewWidth*0.1]];
            [self.contentView addConstraints:[_l0 constraintsLeftInContainer:blankSpaceWidth]];
            
            [self.contentView addConstraint:[_l1 constraintWidth:contentViewWidth*0.2]];
            [self.contentView addConstraints:[_l1 constraintsLeftToRightOfView:_l0 constant:blankSpaceWidth]];
            
            [self.contentView addConstraint:[_l2 constraintWidth:contentViewWidth*0.2]];
            [self.contentView addConstraints:[_l2 constraintsLeftToRightOfView:_l1 constant:blankSpaceWidth]];
            
            [self.contentView addConstraint:[_l3 constraintWidth:contentViewWidth*0.2]];
            [self.contentView addConstraints:[_l3 constraintsLeftToRightOfView:_l2 constant:blankSpaceWidth]];
            
            [self.contentView addConstraint:[_l4 constraintWidth:contentViewWidth*0.2]];
            [self.contentView addConstraints:[_l4 constraintsLeftToRightOfView:_l3 constant:blankSpaceWidth]];
        }
        
        if (UIInterfaceOrientationIsLandscape(currentOrientation)) {
            _l5.hidden=NO;
            _l6.hidden=NO;
            _l7.hidden=NO;
            _l8.hidden=NO;
            //显示9个标签，10个空格
            CGFloat contentViewWidth=[[UIScreen mainScreen]bounds].size.width;
            CGFloat blankSpaceWidth=contentViewWidth*0.1/20;
            
            [self.contentView addConstraint:[_l0 constraintWidth:contentViewWidth*0.06]];
            [self.contentView addConstraints:[_l0 constraintsLeftInContainer:blankSpaceWidth]];
            
            [self.contentView addConstraint:[_l1 constraintWidth:contentViewWidth*0.12]];
            [self.contentView addConstraints:[_l1 constraintsLeftToRightOfView:_l0 constant:blankSpaceWidth]];
            
            [self.contentView addConstraint:[_l2 constraintWidth:contentViewWidth*0.1]];
            [self.contentView addConstraints:[_l2 constraintsLeftToRightOfView:_l1 constant:blankSpaceWidth]];
            
            [self.contentView addConstraint:[_l3 constraintWidth:contentViewWidth*0.1]];
            [self.contentView addConstraints:[_l3 constraintsLeftToRightOfView:_l2 constant:blankSpaceWidth]];
            
            [self.contentView addConstraint:[_l4 constraintWidth:contentViewWidth*0.1]];
            [self.contentView addConstraints:[_l4 constraintsLeftToRightOfView:_l3 constant:blankSpaceWidth]];

            [self.contentView addConstraint:[_l5 constraintWidth:contentViewWidth*0.12]];
            [self.contentView addConstraints:[_l5 constraintsLeftToRightOfView:_l4 constant:blankSpaceWidth]];
            
            [self.contentView addConstraint:[_l6 constraintWidth:contentViewWidth*0.12]];
            [self.contentView addConstraints:[_l6 constraintsLeftToRightOfView:_l5 constant:blankSpaceWidth]];
            
            [self.contentView addConstraint:[_l7 constraintWidth:contentViewWidth*0.12]];
            [self.contentView addConstraints:[_l7 constraintsLeftToRightOfView:_l6 constant:blankSpaceWidth]];
            
            [self.contentView addConstraint:[_l8 constraintWidth:contentViewWidth*0.1]];
            [self.contentView addConstraints:[_l8 constraintsLeftToRightOfView:_l7 constant:blankSpaceWidth]];
            
        }
        
        self.lineLabels=[NSArray arrayWithObjects:_l0,_l1,_l2,_l3,_l4,_l5,_l6,_l7,_l8, nil];
        

    }
    return self;
}

-(void)setLabelFont:(UIFont * __nullable)labelFont{
    if (_labelFont!=labelFont) {
        _labelFont=labelFont;
        _l0.font=_labelFont;
        _l1.font=_labelFont;
        _l2.font=_labelFont;
        _l3.font=_labelFont;
        _l4.font=_labelFont;
        _l5.font=_labelFont;
        _l6.font=_labelFont;
        _l7.font=_labelFont;
        _l8.font=_labelFont;
    }
    
}

@end
