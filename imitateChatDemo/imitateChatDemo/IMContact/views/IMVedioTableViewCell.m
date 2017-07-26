//
//  IMVedioTableViewCell.m
//  lesogo_tianGengiPhone
// 视频cell
//  Created by Lesogo_A1 on 2017/6/26.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import "IMVedioTableViewCell.h"
#import "IMTextTableViewCell.h"
#import <MediaPlayer/MediaPlayer.h>


typedef void(^playVedioBlock)(NSString * vedioUrl);




@interface IMVedioTableViewCell ()
@property (strong, nonatomic) UIImageView       *vedioImageView;
@property (strong, nonatomic) UIButton          *playOrStop;



@property (strong, nonatomic) CAShapeLayer      *shapelayer;

@property (strong, nonatomic) UIImageView       *userHeaderImageView;//用户头像

//@property (strong, nonatomic) UILabel           *timeLength;//时长记录
@property (nonatomic) playVedioBlock            completeBlock;
@property (nonatomic) IMContactHeaderBlock      headerBlock;


@property (nonatomic) BOOL                      isPlayVedio;

@property (strong, nonatomic) IMContactMessageModel *cellItemModel;


@end




@implementation IMVedioTableViewCell

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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinisedThumbnailImage:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
        _isPlayVedio = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.vedioImageView];
        [self.contentView addSubview:self.userHeaderImageView];
        [self.contentView addSubview:self.playOrStop];
    }
    return self;
}




-(UIImageView *)vedioImageView
{
    if(!_vedioImageView)
    {
        _vedioImageView = [[UIImageView alloc] init];
        _vedioImageView.backgroundColor = [UIColor redColor];
        _vedioImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _vedioImageView;
}


-(UIButton *)playOrStop
{
    if(!_playOrStop)
    {
        _playOrStop = [[UIButton alloc] init];
        [_playOrStop setImage:[UIImage imageNamed:@"userDetailAccount"] forState:(UIControlStateNormal)];
        [_playOrStop setImage:[UIImage imageNamed:@"userDetailAccountManager"] forState:(UIControlStateSelected)];
        _playOrStop.backgroundColor = [UIColor blueColor];
        [_playOrStop addTarget:self action:@selector(didFinishedPlay:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _playOrStop;
    
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



//
//-(UILabel *)timeLength
//{
//    if(!_timeLength)
//    {
//        _timeLength = [[UILabel alloc] init];
//        _timeLength.font = [UIFont systemFontOfSize:13];
//        _timeLength.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
//    }
//    return _timeLength;
//}



-(void)layoutSubviews
{
    NSLog(@"layoutSubviews %d",_isPlayVedio);
    self.contentView.frame  = self.bounds;
    self.playOrStop.selected = _isPlayVedio;
    
    
    if(_cellItemModel.userRole == IMContactUserRoleSender)
    {
        self.vedioImageView.frame = CGRectMake(70, 5, self.height-10, self.height-10);
        self.userHeaderImageView.frame= CGRectMake(10, 10, 40, 40);
    
        UIBezierPath    *bezier = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(65, 5, 100, self.height-10) cornerRadius:5];
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
        [self.contentView.layer insertSublayer:_shapelayer below:self.vedioImageView.layer];
        
    }else
    {
        self.vedioImageView.frame = CGRectMake(self.width-50-self.height-10, 5, self.height-10, self.height-10);
        self.userHeaderImageView.frame = CGRectMake(self.width-50, 10, 40, 40);

        UIBezierPath    *bezier = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.width-165, 5, 100, self.height-10) cornerRadius:5];
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
        [self.contentView.layer insertSublayer:_shapelayer below:self.vedioImageView.layer];
    }
    
    self.playOrStop.frame=CGRectMake((self.vedioImageView.width-40)/2.0+self.vedioImageView.left, (self.vedioImageView.height-40)/2.0, 40, 40);
}





-(void)setIsExpert:(int )isExpert
{
    _isExpert = isExpert;
}

-(void)didHeader:(UIGestureRecognizer *)headergesture
{
    _headerBlock(@" your App usetId");
}

-(void)didFinishedPlay:(UIButton *)sender
{
    if(sender.selected)
        sender.selected = NO;
    else
        sender.selected = YES;
    _isPlayVedio = sender.selected;
    _completeBlock(_cellItemModel.vedioUrlPath);
}


-(void)updateMessage:(IMContactMessageModel*)datas completeBlock:(void(^)(NSString * vedioUrl))Block headerBlock:(void(^)(NSString *userId))headerlock
{
//    self.timeLength.text = @"12\"";
    if([datas.vedioUrlPath length]>0)
    {
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:datas.vedioUrlPath]] ;
//        [player requestThumbnailImagesAtTimes:@[@(1.0)] timeOption:(MPMovieTimeOptionNearestKeyFrame)];
//        UIImage *thumb= [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
//        _vedioImageView.image = thumb;
    }

    _cellItemModel = datas;
    _completeBlock = Block;
    _headerBlock = headerlock;
    
    
}

-(void)didFinisedThumbnailImage:(NSNotification *)notification
{
    UIImage *thumb = [notification.userInfo objectForKey:MPMoviePlayerThumbnailImageKey];
    _vedioImageView.image = thumb;
}

@end
