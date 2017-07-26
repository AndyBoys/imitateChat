//
//  IMContactManager.h
//  lesogo_tianGengiPhone
//
//  Created by Lesogo_A1 on 2017/7/6.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMContactManager : NSObject

+(IMContactManager *)shareInstance;


/*
 YWAPI的单例是IMSDK的API入口，调用syncInitWithOwnAppKey:getError:方法进行初始化【YWAPI.h】
 初始化成功后调用fetchNewIMCoreForOpenIM接口获取并保存YWIMCore的实例，你可以使用YWIMCore的实例建立消息通道。【YWAPI.h】
 
 *  初始化示例代码
 */
- (BOOL)exampleInit;

/**
 *  设置证书名的示例代码  com.lesogo.tiangeng     com.taobao.tcmpushtest
 */
- (void)exampleSetCertName;

/**
 *  您需要在-[AppDelegate application:didFinishLaunchingWithOptions:]中第一时间设置此回调
 *  在IMSDK截获到Push通知并需要您处理Push时，IMSDK会自动调用此回调
 */
- (void)exampleHandleAPNSPush;



/**
 *  用户在应用的服务器登录成功之后，向云旺服务器登录之前调用
 *  @param ywLoginId, 用来登录云旺IMSDK的id
 *  @param password, 用来登录云旺IMSDK的密码
 *  @param aSuccessBlock, 登陆成功的回调
 *  @param aFailedBlock, 登录失败的回调
 */
- (void)callThisAfterISVAccountLoginSuccessWithYWLoginId:(NSString *)ywLoginId passWord:(NSString *)passWord preloginedBlock:(void(^)())aPreloginedBlock successBlock:(void(^)())aSuccessBlock failedBlock:(void (^)(NSError *error))aFailedBlock;

///**
// 登录的过程分为两个步骤：
// 调用setFetchLoginInfoBlock:设置获取登录信息的回调。一般地，你需要在这个回调里先获取该用户的昵称，成功后再调用aCompletionBlock，将userId、password、displayName等信息告知IMSDK。（昵称用于对方收到系统推送时显示）【IYWLoginService.h】
// 调用asyncLoginWithCompletionBlock:真正发起登录【IYWLoginService.h】
// *  预登陆
// */
//- (void)examplePreLoginWithLoginId:(NSString *)loginId successBlock:(void(^)())aPreloginedBlock;
//
///**
// *  登录的示例代码 注意： 您可以使用“visitor1” - “visitor1000”，密码为“taobao1234”，登录我们的Demo进行体验
// */
//- (void)exampleLoginWithUserID:(NSString *)aUserID password:(NSString *)aPassword successBlock:(void(^)())aSuccessBlock failedBlock:(void (^)(NSError *))aFailedBlock;



//登录之后调用

/**
 *  监听连接状态
 */
- (void)exampleListenConnectionStatus;

/**
 *  监听自己发送的消息的生命周期
 */
- (void)exampleListenMyMessageLife;

/**
 你需要监听所有消息，并可以对透传消息做特定的处理。下面的代码监听了所有消息，当消息体是透传指令时，展示一个弹框。
 *  监听新消息
 */
- (void)exampleListenNewMessage;




@end
