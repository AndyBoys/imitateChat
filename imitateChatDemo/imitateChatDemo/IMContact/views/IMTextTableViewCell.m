//
//  IMTextTableViewCell.m
//  lesogo_tianGengiPhone
//  文字
//  Created by Lesogo_A1 on 2017/6/26.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import "IMTextTableViewCell.h"

@interface IMTextTableViewCell ()
@property (strong, nonatomic) UILabel       *contentLabel;

@property (strong, nonatomic) CAShapeLayer      *shapelayer;

@property (strong, nonatomic) UIImageView   *userHeaderImageView;//用户头像

@property (nonatomic) IMContactHeaderBlock      headerBlock;
@property (strong, nonatomic) IMContactMessageModel *cellItemModel;

@end



@implementation IMTextTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[ super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.userHeaderImageView];
    }
    return self;
}




-(UILabel *)contentLabel
{
    if(!_contentLabel)
    {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor whiteColor] ;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

-(UIImageView *)userHeaderImageView
{
    if(!_userHeaderImageView)
    {
        _userHeaderImageView = [[UIImageView alloc] init];
        _userHeaderImageView.backgroundColor = [UIColor redColor];
        [_userHeaderImageView.layer setMasksToBounds:YES];
        [_userHeaderImageView.layer setCornerRadius:20];
        _userHeaderImageView.userInteractionEnabled  = YES;
        [_userHeaderImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didHeader:)]];
    }
    return _userHeaderImageView;
}


-(void)layoutSubviews
{
     NSLog(@"layoutSubviews");
    
    self.contentView.frame  = self.bounds;
    
    CGSize size =  [Tool getHeightWithMessage:_cellItemModel.messageContent size:CGSizeMake(LCDW-20-140, 100000) font:[UIFont systemFontOfSize:15]];
   
   
    if(_cellItemModel.userRole == IMContactUserRoleSender)
    {
        self.contentLabel.frame = CGRectMake(75, 5, size.width+10, self.height-30);
        self.contentLabel.textAlignment = NSTextAlignmentLeft;
        
        self.userHeaderImageView.frame= CGRectMake(10, 10, 40, 40);
//        UIBezierPath    *bezier = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(65, 0, self.width-130, self.height-20) cornerRadius:5];
         UIBezierPath    *bezier = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(65, 0, size.width+20, self.height-20) cornerRadius:5];
        CAShapeLayer    *shape = [CAShapeLayer layer];
        shape.strokeColor = [RGBACOLOR(0, 180, 112, 1) CGColor];
        shape.fillColor = [RGBACOLOR(0, 180, 112, 1) CGColor];
        
        [bezier moveToPoint:CGPointMake(55, 20)];
        [bezier addLineToPoint:CGPointMake(65, 10)];
        [bezier addLineToPoint:CGPointMake(65, 30)];
        [bezier addLineToPoint:CGPointMake(55, 20)];
        [bezier closePath];
        shape.path = [bezier CGPath];
        [_shapelayer removeFromSuperlayer];
        _shapelayer = shape;
        [self.contentView.layer insertSublayer:_shapelayer below:self.contentLabel.layer];
    }else
    {
        self.contentLabel.frame = CGRectMake(self.width-85- size.width, 5, size.width+10, self.height-30);
        self.contentLabel.textAlignment = NSTextAlignmentRight;
        
        self.userHeaderImageView.frame= CGRectMake(self.width-50, 10, 40, 40);
        UIBezierPath    *bezier = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.width-85- size.width, 0,  size.width+20, self.height-20) cornerRadius:5];
        CAShapeLayer    *shape = [CAShapeLayer layer];
        shape.strokeColor = [RGBACOLOR(0, 180, 112, 1) CGColor];
        shape.fillColor = [RGBACOLOR(0, 180, 112, 1) CGColor];
        [bezier moveToPoint:CGPointMake(self.width-55, 20)];
        [bezier addLineToPoint:CGPointMake(self.width-65, 10)];
        [bezier addLineToPoint:CGPointMake(self.width-65, 30)];
        [bezier addLineToPoint:CGPointMake(self.width-55, 20)];
        [bezier closePath];
        shape.path = [bezier CGPath];
        [_shapelayer removeFromSuperlayer];
        _shapelayer = shape;
        [self.contentView.layer insertSublayer:_shapelayer below:self.contentLabel.layer];
    }
    
}

-(void)setIsExpert:(int )isExpert
{
    _isExpert = isExpert;
}


-(void)didHeader:(UIGestureRecognizer *)headergesture
{
    _headerBlock(@" your App usetId");
}



-(void)updateMessage:(IMContactMessageModel*)datas headerBlock:(void(^)(NSString *userId))Block
{
    _cellItemModel = datas;
    self.contentLabel.text = datas.messageContent;
    _headerBlock = Block;
    
    
    
}




@end
