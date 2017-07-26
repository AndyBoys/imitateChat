//
//  IMContactMessageModel.m
//  lesogo_tianGengiPhone
//
//  Created by Lesogo_A1 on 2017/6/27.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import "IMContactMessageModel.h"


@implementation IMContactMessageModel

@synthesize userId = _userId;
@synthesize userHeaderImagePath = _userHeaderImagePath;
@synthesize userName = _userName;
@synthesize messageDate = _messageDate;
@synthesize messageContent = _messageContent;

@synthesize currentState = _currentState;
@synthesize pictureUrlPath = _pictureUrlPath;
@synthesize imageData = _imageData;
@synthesize voiceUrlPath = _voiceUrlPath ;
@synthesize vedioUrlPath = _vedioUrlPath;//video
@synthesize messageType = _messageType;
@synthesize duration = _duration;

@synthesize isPlayStream = _isPlayStream;
@synthesize primaryKeyID = _primaryKeyID;



-(id)copyWithZone:(NSZone *)zone
{
    IMContactMessageModel *model  = [[IMContactMessageModel allocWithZone:zone] init];
    model->_userId = _userId;
    model->_userHeaderImagePath = _userHeaderImagePath;
    model->_userName = _userName;
    model->_messageDate = _messageDate;
    model->_messageContent = _messageContent;
    model->_pictureUrlPath = _pictureUrlPath;
    model->_voiceUrlPath = _voiceUrlPath;
    model->_vedioUrlPath = _vedioUrlPath;
    model.messageType = _messageType;
    model.currentState =  _currentState;
    model.duration = _duration;
    model.userRole = _userRole;
    model.primaryKeyID =_primaryKeyID;
    model.imageData = _imageData;
    return model;
}



+(NSString *)getPrimaryKey
{
    return @"primaryKeyID";
}
+(NSString *)getTableName
{
    return @"IMContactMessage";
}
+(int)getTableVersion
{
    return 20170628;
}



@end
