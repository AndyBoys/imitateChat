//
//  IMTextTableViewCell.h
//  lesogo_tianGengiPhone
//
//  Created by Lesogo_A1 on 2017/6/26.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMContactDef.h"
#import "IMContactMessageModel.h"

@interface IMTextTableViewCell : UITableViewCell
@property (nonatomic) int     isExpert;
-(void)updateMessage:(IMContactMessageModel*)datas headerBlock:(void(^)(NSString *userId))Block;



@end
