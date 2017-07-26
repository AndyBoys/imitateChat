//
//  IMContactMessageModel.h
//  lesogo_tianGengiPhone
//
//  Created by Lesogo_A1 on 2017/6/27.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IMContactMessageType)
{
    IMContactMessageTypeText                    =0,//文字
    IMContactMessageTypeImage                   =1,//图片
    IMContactMessageTypeVoice                   =2,//声音
    IMContactMessageTypeVedio                   =3,//视频
    IMContactMessageTypeEmotion                 =4,//表情
    
    IMContactMessageTypePromptInformation       =5, //提示信息
    IMContactMessageTypeRomote                     //远程消息
};

typedef NS_ENUM(NSInteger, IMContactLineState)
{
    IMContactLineStateOnLine            =1,//在线
    IMContactLineStateOffLine           =2,//离线
    IMContactLineStateLeaveLine         =3 //离开
};


typedef NS_ENUM(NSInteger, IMContactUserRole) {
    IMContactUserRoleReceiver           =1,//接收者
    IMContactUserRoleSender             =2//发送者
};




@interface IMContactMessageModel : NSObject<NSCopying>


@property (nonatomic) NSInteger         primaryKeyID;

/**
 用户Id
 */
@property (copy, nonatomic) NSString        *userId;



/**
 用户名称
 */
@property (copy, nonatomic) NSString        *userName;


/**
 用户头像地址
 */
@property (copy, nonatomic) NSString        *userHeaderImagePath;


/**
 用户角色
 */
@property (nonatomic) IMContactUserRole       userRole;


/**
 消息类型
 */
@property (nonatomic) IMContactMessageType       messageType;

/**
 文字信息（附表情）
 */
@property (copy, nonatomic) NSString        *messageContent;

/**
 发送消息的时间
 */
@property (copy, nonatomic) NSString        *messageDate;



/**
 当前用户状态
 */
@property (nonatomic) IMContactLineState        currentState;


/**
 发送图片地址
 */
@property (copy, nonatomic) NSString        *pictureUrlPath;



/**
 图片
 */
@property (copy, nonatomic) NSData          *imageData;


/**
 声音地址
 */
@property (copy, nonatomic) NSString        *voiceUrlPath;


/**
 视频地址
 */
@property (copy, nonatomic) NSString        *vedioUrlPath;


/**
 音视频时长
 */
@property (nonatomic) NSInteger             duration;




/**
 是否播放语音或视频流
 */
@property (assign, nonatomic) BOOL          isPlayStream;





@end
