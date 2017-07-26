//
//  IMVoiceTableViewCell.h
//  lesogo_tianGengiPhone
//
//  Created by Lesogo_A1 on 2017/6/26.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMContactMessageModel.h"
@interface IMVoiceTableViewCell : UITableViewCell
@property (nonatomic) int     isExpert;
-(void)updateMessage:(IMContactMessageModel*)datas voiceBlock:(void(^)(BOOL isPlay))voiceBlock headerBlock:(void(^)(NSString *userId))headerBlock;
-(void)stopPlayVoice;

@end
