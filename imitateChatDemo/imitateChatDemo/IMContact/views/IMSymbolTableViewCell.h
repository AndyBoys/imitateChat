//
//  IMSymbolTableViewCell.h
//  lesogo_tianGengiPhone
//
//  Created by Lesogo_A1 on 2017/6/26.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMContactMessageModel.h"


@interface IMSymbolTableViewCell : UITableViewCell

-(void)updateMessage:(IMContactMessageModel*)datas;

@end
