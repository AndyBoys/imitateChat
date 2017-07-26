//
//  IMImageTableViewCell.m
//  lesogo_tianGengiPhone
//  图片
//  Created by Lesogo_A1 on 2017/6/26.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import "IMImageTableViewCell.h"
#import "IMTextTableViewCell.h"

typedef void(^IMContactImageBlock)(NSString *imagePath);


@interface IMImageTableViewCell ()
@property (strong, nonatomic) UIImageView       *contentImageView;

@property (strong, nonatomic) CAShapeLayer      *shapelayer;

@property (strong, nonatomic) UIImageView       *userHeaderImageView;//用户头像
@property (nonatomic) IMContactHeaderBlock      headerBlock;
@property (nonatomic) IMContactImageBlock       imageBlock;

@property (strong, nonatomic) IMContactMessageModel *cellItemModel;
@end




@implementation IMImageTableViewCell

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
        [self.contentView addSubview:self.contentImageView];
        [self.contentView addSubview:self.userHeaderImageView];
    }
    return self;
}




-(UIImageView *)contentImageView
{
    if(!_contentImageView)
    {
        _contentImageView = [[UIImageView alloc] init];
        _contentImageView.backgroundColor = [UIColor clearColor];
        _contentImageView.contentMode = UIViewContentModeScaleToFill;
        _contentImageView.userInteractionEnabled  = YES;
        [_contentImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didImageView:)]];
    }
    return _contentImageView;
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
        _userHeaderImageView.userInteractionEnabled  = YES;
        [_userHeaderImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didHeader:)]];
    }
    return _userHeaderImageView;
}


-(void)layoutSubviews
{
    NSLog(@"layoutSubviews");
    self.contentView.frame  = self.bounds;
    //    CGSize size =  [Tool getHeightWithMessage:message size:CGSizeMake(LCDW-20-140, 100000) font:[UIFont systemFontOfSize:15]];
    
    
    if(_cellItemModel.userRole == IMContactUserRoleSender)
    {
        self.contentImageView.frame = CGRectMake(70, 5, self.width/2.0- 70, self.height-20);
        self.userHeaderImageView.frame= CGRectMake(10, 10, 40, 40);
        UIBezierPath    *bezier = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(65, 5, self.width/2.0-65, self.height-20) cornerRadius:5];
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
        [self.contentView.layer insertSublayer:_shapelayer below:self.contentImageView.layer];
    }else
    {
        self.contentImageView.frame = CGRectMake(self.width/2.0, 5, self.width/2.0- 70, self.height-20);
        self.userHeaderImageView.frame = CGRectMake(self.width-50, 10, 40, 40);
        
        UIBezierPath    *bezier = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.width/2.0, 5, self.width/2.0- 65, self.height-20) cornerRadius:5];
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
        [self.contentView.layer insertSublayer:_shapelayer below:self.contentImageView.layer];
    }
    
}

-(void)setIsExpert:(int )isExpert
{
    _isExpert = isExpert;
}


-(void)didImageView:(UIGestureRecognizer *)headergesture
{
    _imageBlock(@" image url path");
}

-(void)didHeader:(UIGestureRecognizer *)headergesture
{
    _headerBlock(@" your App usetId");
}



-(void)updateMessage:(IMContactMessageModel*)datas imageBlock:(void(^)(NSString *imagePath))imageBlock headerBlock:(void(^)(NSString *userId))headerBlock
{
//    self.contentLabel.text = @"新《种子法》和相关配套法规相续出台实施，省农作物品种盛鼎委员会一定要认真研究...";
    _cellItemModel = datas;
    if(datas.imageData)
    {
        [_contentImageView setImage:[UIImage imageWithData:datas.imageData]];
    }
    
    _imageBlock = imageBlock;
    _headerBlock = headerBlock;
}

@end
