//
//  IMVoiceTableViewCell.m
//  lesogo_tianGengiPhone
//  语音
//  Created by Lesogo_A1 on 2017/6/26.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import "IMVoiceTableViewCell.h"
#import "IMTextTableViewCell.h"

typedef void(^IMContactvoiceBlock)(BOOL isPlay);


@interface IMVoiceTableViewCell ()


@property (strong, nonatomic) UIButton       *voiceImageView;

@property (strong, nonatomic) CAShapeLayer      *shapelayer;

@property (strong, nonatomic) UIImageView       *userHeaderImageView;//用户头像

@property (strong, nonatomic) UILabel           *timeLength;//时长记录
@property (nonatomic) IMContactHeaderBlock      headerBlock;

@property (nonatomic) IMContactvoiceBlock       voiceBlock;
@property (strong, nonatomic) IMContactMessageModel *cellItemModel;
@end



@implementation IMVoiceTableViewCell

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
        [self.contentView addSubview:self.voiceImageView];
        [self.contentView addSubview:self.userHeaderImageView];
        [self.contentView addSubview:self.timeLength];
    }
    return self;
}

-(UIButton *)voiceImageView
{
    if(!_voiceImageView)
    {
        _voiceImageView = [[UIButton alloc] init];
        _voiceImageView.backgroundColor = [UIColor clearColor];
        _voiceImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_voiceImageView setImage:[UIImage imageNamed:@"切片-15"] forState:(UIControlStateNormal)];
         [_voiceImageView setImage:[UIImage imageNamed:@"切片-16"] forState:(UIControlStateSelected)];
        [_voiceImageView addTarget:self action:@selector(didFinishedVoice:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _voiceImageView;
}

-(UIImageView *)userHeaderImageView
{
    if(!_userHeaderImageView)
    {
        _userHeaderImageView = [[UIImageView alloc] init];
        _userHeaderImageView.backgroundColor = [UIColor redColor];
        [_userHeaderImageView.layer setMasksToBounds:YES];
        [_userHeaderImageView.layer setCornerRadius:20];
        _userHeaderImageView.userInteractionEnabled = YES;
        [_userHeaderImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didHeader:)]];
    }
    return _userHeaderImageView;
}



-(UILabel *)timeLength
{
    if(!_timeLength)
    {
        _timeLength = [[UILabel alloc] init];
        _timeLength.font = [UIFont systemFontOfSize:13];
        _timeLength.textColor = [UIColor whiteColor] ;
    }
    return _timeLength;
}



-(void)layoutSubviews
{
    NSLog(@"layoutSubviews");
    self.contentView.frame  = self.bounds;
    
    if(_cellItemModel.userRole == IMContactUserRoleSender)
    {
        self.voiceImageView.frame = CGRectMake(70, (self.height-30)/2.0-2.5, 30, 30);
        self.userHeaderImageView.frame= CGRectMake(10, 10, 40, 40);
        self.timeLength.frame = CGRectMake(125, 5, 40, self.height-20);
        self.timeLength.textAlignment = NSTextAlignmentRight;
        
        UIBezierPath    *bezier = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(65, 5, 100, self.height-20) cornerRadius:5];
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
        [self.contentView.layer insertSublayer:_shapelayer below:self.voiceImageView.layer];
        
        
    }else
    {
        self.voiceImageView.frame = CGRectMake(self.width-100, (self.height-30)/2.0-2.5, 30, 30);
        self.userHeaderImageView.frame = CGRectMake(self.width-50, 10, 40, 40);
        self.timeLength.frame = CGRectMake(self.width-160, 5, 40, self.height-20);
        self.timeLength.textAlignment = NSTextAlignmentLeft;

        
        UIBezierPath    *bezier = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.width-165, 5, 100, self.height-20) cornerRadius:5];
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
        [self.contentView.layer insertSublayer:_shapelayer below:self.voiceImageView.layer];
    }
}


-(void)stopPlayVoice
{
    self.voiceImageView.selected = NO;
}

-(void)setIsExpert:(int )isExpert
{
    _isExpert = isExpert;
}


-(void)didHeader:(UIGestureRecognizer *)headergesture
{
    _headerBlock(@" your App usetId");
}

-(void)didFinishedVoice:(UIButton *)sender
{
    if(!sender.selected)
    {
        sender.selected = YES;
    }
    else{
        sender.selected = NO;
    }
    _voiceBlock(sender.selected);
}

-(void)updateMessage:(IMContactMessageModel*)datas voiceBlock:(void(^)(BOOL isPlay))voiceBlock headerBlock:(void(^)(NSString *userId))headerBlock
{
    _cellItemModel = datas;
    self.timeLength.text = [NSString stringWithFormat:@"%ds",(int)datas.duration];
    _voiceBlock = voiceBlock;
    _headerBlock = headerBlock;
}


@end
