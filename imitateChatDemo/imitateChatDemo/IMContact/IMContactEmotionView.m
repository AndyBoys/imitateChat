//
//  IMContactEmotionView.m
//  lesogo_tianGengiPhone
//
//  Created by Lesogo_A1 on 2017/7/3.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import "IMContactEmotionView.h"
typedef void(^IMContactEmotionBlock)(NSString *emotion);


@interface IMContactEmotionView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView       *emotionView;
@property (strong, nonatomic) UICollectionViewFlowLayout    *flowLayout;

@property (nonatomic) IMContactEmotionBlock          emotionBlock;


@end


@implementation IMContactEmotionView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self addEmotionView];
    }
    
    return self;
}


-(void)setEmotionDatas:(NSMutableArray *)EmotionDatas
{
    _EmotionDatas = EmotionDatas;
    [_emotionView reloadData];
}


-(void)addEmotionView
{
    float itemtWidth = (self.width-80)/7.0;
    if(!_flowLayout)
    {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(itemtWidth, 30);
        _flowLayout.scrollDirection =UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing  = 5;
        _flowLayout.minimumInteritemSpacing = 5;
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        
    }
    
    
    if(!_emotionView)
    {
        _emotionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) collectionViewLayout:_flowLayout];
        _emotionView.delegate  =self;
        _emotionView.dataSource = self;
        _emotionView.backgroundColor = [UIColor clearColor];
        _emotionView.pagingEnabled = YES;
        [self addSubview:_emotionView];
        [_emotionView registerClass:[IMcontactEmotionCell class] forCellWithReuseIdentifier:@"emotioncell"];
      
        
    }
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_EmotionDatas count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"emotioncell";
    IMcontactEmotionCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.emotionLb.text = [_EmotionDatas objectAtIndex:indexPath.row];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _emotionBlock([_EmotionDatas objectAtIndex:indexPath.row]);
}



-(void)didSelectedEmotionItem:(void (^)(NSString *emotion))emotionBlock
{
    _emotionBlock = emotionBlock;
}

@end


@implementation IMcontactEmotionCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self.contentView addSubview:self.emotionLb];
    }
    return self;
   
}

//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if(self)
//    {
//      
//    }
//    
//    return self;
//        
//}


-(UILabel *)emotionLb
{
    if(!_emotionLb)
    {
        _emotionLb =[[UILabel alloc] init];
        _emotionLb.backgroundColor = [UIColor clearColor];
        _emotionLb.font = [UIFont systemFontOfSize:15];
        _emotionLb.textAlignment = NSTextAlignmentCenter;
    }
    return _emotionLb;
    
}


-(void)layoutSubviews
{
    self.contentView.frame = self.bounds;
    self.emotionLb.frame = self.bounds;
}


@end
