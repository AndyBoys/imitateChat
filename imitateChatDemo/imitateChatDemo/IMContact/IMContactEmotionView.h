//
//  IMContactEmotionView.h
//  lesogo_tianGengiPhone
//
//  Created by Lesogo_A1 on 2017/7/3.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface IMContactEmotionView : UIView
@property (strong, nonatomic) NSMutableArray    *EmotionDatas;

-(void)didSelectedEmotionItem:(void(^)(NSString *emotion))emotionBlock;

@end


@interface IMcontactEmotionCell :UICollectionViewCell
@property (strong, nonatomic) UILabel       *emotionLb;

@end
