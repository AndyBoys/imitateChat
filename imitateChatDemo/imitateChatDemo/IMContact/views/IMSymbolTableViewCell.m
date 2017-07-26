//
//  IMSymbolTableViewCell.m
//  lesogo_tianGengiPhone
//  时间和剪短信息行
//  Created by Lesogo_A1 on 2017/6/26.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import "IMSymbolTableViewCell.h"
#import "IMContactMessageModel.h"


@interface IMSymbolTableViewCell ()
@property (strong, nonatomic)  UILabel         *symbolTextView;;
@property (strong, nonatomic) id                ItemDatas;



@end


@implementation IMSymbolTableViewCell




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
        [self.contentView addSubview:self.symbolTextView];
    }
  
    return self;
}



-(UILabel *)symbolTextView
{
    if(!_symbolTextView)
    {
        _symbolTextView = [[UILabel alloc] init];
        _symbolTextView.textColor = [[UIColor grayColor] colorWithAlphaComponent:0.8];
        _symbolTextView.textAlignment = NSTextAlignmentCenter;
        _symbolTextView.font = [UIFont systemFontOfSize:15];
    }
    return _symbolTextView;
}

-(void)layoutSubviews
{
    self.contentView.frame  = self.bounds;
    self.symbolTextView.frame = CGRectMake(0, 0, self.width, self.height);
}


-(void)updateMessage:(IMContactMessageModel*)datas
{
    self.symbolTextView.text = datas.messageDate;
}





@end
