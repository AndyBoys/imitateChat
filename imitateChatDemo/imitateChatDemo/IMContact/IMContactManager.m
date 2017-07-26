//
//  IMContactManager.m
//  lesogo_tianGengiPhone
//
//  Created by Lesogo_A1 on 2017/7/6.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import "IMContactManager.h"


static IMContactManager     *IMManager = nil;
@interface IMContactManager ()

@end


@implementation IMContactManager


+(IMContactManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        IMManager = [[ IMContactManager alloc] init];
    });
    return IMManager;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        [self exampleInit];
        [self exampleSetCertName];
        [self exampleHandleAPNSPush];
    }
    
    return self;
}



#pragma mark - basic

- (NSNumber *)lastEnvironment
{
    NSNumber *environment = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastEnvironment"];
    if (environment == nil) {
        return @(YWEnvironmentRelease);
    }
    return environment;
}

/**
 *  设置证书名的示例代码  com.lesogo.tiangeng     com.taobao.tcmpushtest
 */
- (void)exampleSetCertName
{
    /// 你可以根据当前的bundleId，设置不同的证书，避免修改代码
    /// 这些证书是我们在百川后台添加的。
    if ([[NSBundle mainBundle].bundleIdentifier isEqualToString:@"com.taobao.tcmpushtest"]) {
        [[[YWAPI sharedInstance] getGlobalPushService] setXPushCertName:@"sandbox"];
    } else {
        /// 默认的情况下，我们都设置为生产证书
        [[[YWAPI sharedInstance] getGlobalPushService] setXPushCertName:@"production"];
    }
}


/*
 YWAPI的单例是IMSDK的API入口，调用syncInitWithOwnAppKey:getError:方法进行初始化【YWAPI.h】
 初始化成功后调用fetchNewIMCoreForOpenIM接口获取并保存YWIMCore的实例，你可以使用YWIMCore的实例建立消息通道。【YWAPI.h】
 
 *  初始化示例代码
 */
- (BOOL)exampleInit;
{
    /// 设置环境
    [[YWAPI sharedInstance] setEnvironment:YWEnvironmentRelease];
    /// 开启日志
    [[YWAPI sharedInstance] setLogEnabled:YES];
    
    NSLog(@"SDKVersion:%@", [YWAPI sharedInstance].YWSDKIdentifier);
    
    NSError *error = nil;
    
    /// 异步初始化IM SDK   23825620  云旺：23015524
    [[YWAPI sharedInstance] syncInitWithOwnAppKey:@"23825620" getError:&error];
    
    if (error.code != 0 && error.code != YWSdkInitErrorCodeAlreadyInited) {
        /// 初始化失败
        return NO;
    } else {
        if (error.code == 0) {
            /// 首次初始化成功
            /// 获取一个IMKit并持有
            self.myYWIMKit = [[YWAPI sharedInstance] fetchIMKitForOpenIM];
        } else {
            /// 已经初始化
        }
        return YES;
    }
}


#pragma mark - apns

/**
 *  您需要在-[AppDelegate application:didFinishLaunchingWithOptions:]中第一时间设置此回调
 *  在IMSDK截获到Push通知并需要您处理Push时，IMSDK会自动调用此回调
 */
- (void)exampleHandleAPNSPush
{
    //    __weak typeof(self) weakSelf = self;
    
    [[[YWAPI sharedInstance] getGlobalPushService] addHandlePushBlockV4:^(NSDictionary *aResult, BOOL *aShouldStop) {
        BOOL isLaunching = [aResult[YWPushHandleResultKeyIsLaunching] boolValue];
        UIApplicationState state = [aResult[YWPushHandleResultKeyApplicationState] integerValue];
        NSString *conversationId = aResult[YWPushHandleResultKeyConversationId];
        Class conversationClass = aResult[YWPushHandleResultKeyConversationClass];
        
        
        if (conversationId.length <= 0) {
            return;
        }
        
        if (conversationClass == NULL) {
            return;
        }
        if (isLaunching) {
            /// 用户划开Push导致app启动
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            });
            
        } else {
            /// app已经启动时处理Push
            
            if (state != UIApplicationStateActive) {
            } else {
                /// 应用处于前台
                /// 建议不做处理，等待IM连接建立后，收取离线消息。
            }
        }
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
}








/**
 你需要监听所有消息，并可以对透传消息做特定的处理。下面的代码监听了所有消息，当消息体是透传指令时，展示一个弹框。
 *  监听新消息
 */
- (void)exampleListenNewMessage
{
    [[self.myYWIMKit.IMCore  getConversationService] addOnNewMessageBlockV2:^(NSArray *aMessages, BOOL aIsOffline) {
        /// 你可以在此处根据需要播放提示音
        
        /// 展示透传消息
        [aMessages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            id<IYWMessage> message = [obj conformsToProtocol:@protocol(IYWMessage)] ? obj : nil;
            if (message) {
                /// 处理消息
            }
            id<IYWMessage> msg = obj;
            YWMessageBodyCustomize *body = nil;
            if ([msg respondsToSelector:@selector(messageBody)]) {
                body = [[msg messageBody] isKindOfClass:[YWMessageBodyCustomize class]] ? (YWMessageBodyCustomize *)[msg messageBody] : nil;
            }
            if (body) {
                NSData *contentData = [body.content dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *contentDictionary = [NSJSONSerialization JSONObjectWithData:contentData
                                                                                  options:0
                                                                                    error:NULL];
                NSString *messageType = contentDictionary[@"customizeMessageType"];
                if ([messageType isEqualToString:@"yuehoujifen"] && body.isTransparent) {
                    NSString *text = contentDictionary[@"Text"];
                    if (text.length > 0) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"阅后即焚" message:text delegate:nil cancelButtonTitle:@"朕知道了" otherButtonTitles:nil];
                            [av show];
                        });
                    }
                }
            }
        }];
    } forKey:self.description ofPriority:YWBlockPriorityDeveloper];
}



/**
 *  监听连接状态
 */
- (void)exampleListenConnectionStatus
{
    __weak typeof(self) weakSelf = self;
    [[self.myYWIMKit.IMCore getLoginService] addConnectionStatusChangedBlock:^(YWIMConnectionStatus aStatus, NSError *aError) {
        
        
        if (aStatus == YWIMConnectionStatusForceLogout || aStatus == YWIMConnectionStatusMannualLogout || aStatus == YWIMConnectionStatusAutoConnectFailed) {
            /// 手动登出、被踢、自动连接失败，都退出到登录页面
            if (aStatus != YWIMConnectionStatusMannualLogout) {
            }
        }
        else if (aStatus == YWIMConnectionStatusConnected) {
            /// 监听群系统消息
        }
    } forKey:[self description] ofPriority:YWBlockPriorityDeveloper];
}



/**
 *  监听自己发送的消息的生命周期
 */
- (void)exampleListenMyMessageLife
{
    [[self.myYWIMKit.IMCore getConversationService] addMessageLifeDelegate:self forPriority:YWBlockPriorityDeveloper];
}

/**
 *  用户在应用的服务器登录成功之后，向云旺服务器登录之前调用
 *  @param ywLoginId, 用来登录云旺IMSDK的id
 *  @param password, 用来登录云旺IMSDK的密码
 *  @param aSuccessBlock, 登陆成功的回调
 *  @param aFailedBlock, 登录失败的回调
 */
- (void)callThisAfterISVAccountLoginSuccessWithYWLoginId:(NSString *)ywLoginId passWord:(NSString *)passWord preloginedBlock:(void(^)())aPreloginedBlock successBlock:(void(^)())aSuccessBlock failedBlock:(void (^)(NSError *))aFailedBlock
{
    /// 监听连接状态
    [self exampleListenConnectionStatus];
    [self exampleListenNewMessage];
    
    
    /// 设置声音播放模式
    /// 设置头像和昵称
    //    /// 设置最大气泡宽度
    /// 监听新消息
    
    // 设置提示
    /// 监听头像点击事件
    /// 监听链接点击事件
    /// 监听预览大图事件
    //    /// 自定义皮肤
    //    [self exampleCustomUISkin];
    /// 开启群@消息功能
    /// 开启单聊已读未读状态显示
    
    if ([ywLoginId length] > 0 && [passWord length] > 0) {
        /// 预登陆
        [self examplePreLoginWithLoginId:ywLoginId successBlock:aPreloginedBlock];
        
        /// 真正登录
        [self exampleLoginWithUserID:ywLoginId password:passWord successBlock:aSuccessBlock failedBlock:aFailedBlock];
    } else {
        if (aFailedBlock) {
            aFailedBlock([NSError errorWithDomain:YWLoginServiceDomain code:YWLoginErrorCodePasswordError userInfo:nil]);
        }
    }
}

/**
 登录的过程分为两个步骤：
 调用setFetchLoginInfoBlock:设置获取登录信息的回调。一般地，你需要在这个回调里先获取该用户的昵称，成功后再调用aCompletionBlock，将userId、password、displayName等信息告知IMSDK。（昵称用于对方收到系统推送时显示）【IYWLoginService.h】
 调用asyncLoginWithCompletionBlock:真正发起登录【IYWLoginService.h】
 *  预登陆
 */
- (void)examplePreLoginWithLoginId:(NSString *)loginId successBlock:(void(^)())aPreloginedBlock
{
    /// 预登录
    if ([[self.myYWIMKit.IMCore getLoginService] preLoginWithPerson:[[YWPerson alloc] initWithPersonId:loginId]]) {
        /// 预登录成功，直接进入页面,这里可以打开界面
        
        if (aPreloginedBlock) {
            aPreloginedBlock();
        }
    }
}


/**
 *  登录的示例代码 注意： 您可以使用“visitor1” - “visitor1000”，密码为“taobao1234”，登录我们的Demo进行体验
 */
- (void)exampleLoginWithUserID:(NSString *)aUserID password:(NSString *)aPassword successBlock:(void(^)())aSuccessBlock failedBlock:(void (^)(NSError *))aFailedBlock
{
    aSuccessBlock = [aSuccessBlock copy];
    aFailedBlock = [aFailedBlock copy];
    
    /// 登录之前，先告诉IM如何获取登录信息。
    /// 当IM向服务器发起登录请求之前，会调用这个block，来获取用户名和密码信息。
    [[self.myYWIMKit.IMCore getLoginService] setFetchLoginInfoBlock:^(YWFetchLoginInfoCompletionBlock aCompletionBlock) {
        aCompletionBlock(YES, aUserID, aPassword, nil, nil);
    }];
    
    /// 发起登录
    [[self.myYWIMKit.IMCore getLoginService] asyncLoginWithCompletionBlock:^(NSError *aError, NSDictionary *aResult) {
        if (aError.code == 0 || [[self.myYWIMKit.IMCore getLoginService] isCurrentLogined]) {
            /// 登录成功
            if (aSuccessBlock) {
                aSuccessBlock();
            }
        } else {
            
            if (aFailedBlock) {
                aFailedBlock(aError);
            }
        }
    }];
}


#pragma mark- life delegate
/**
 *  即将发送某个消息体
 *  @param aContext 即将发送消息的上下文，目前有效的字段包含：messageBody, controlParameters, conversation
 *  @return 返回context IMSDK根据返回的context来真正发送消息，也就是说，可以通过needContinue字段控制实际是否发送，通过messageBody、controlParameters、conversation来控制实际发送的消息内容等；如果返回nil，则保持原先的值
 
 *  @brief 强烈的建议你，不要在这个回调中直接调用YWConversation的消息发送API，否则你需要特别注意发送的消息不会触发再次发送新消息，避免死循环。
 
 */
- (YWMessageLifeContext *)messageLifeWillSend:(YWMessageLifeContext *)aContext;
{
    /// 你可以通过返回context，来实现改变消息的能力
    if ([aContext.messageBody isKindOfClass:[YWMessageBodyText class]]) {
        NSString *text = [(YWMessageBodyText *)aContext.messageBody messageText];
        if ([text rangeOfString:@"法轮功"].location != NSNotFound) {
            YWMessageBodySystemNotify *bodyNotify = [[YWMessageBodySystemNotify alloc] initWithContent:@"消息包含违禁词语"];
            [aContext setMessageBody:bodyNotify];
            
            NSDictionary *params = @{kYWMsgCtrlKeyClientLocal:@{kYWMsgCtrlKeyClientLocalKeyOnlySave:@(YES)}};
            [aContext setControlParameters:params];
            
            return aContext;
        }
    }
    return nil;
}



/**
 *  完成某条消息的发送
 *  @param aMessage 所完成的消息
 *  @param aResult 结果
 */
- (void)messageLifeDidSend:(NSString *)aMessageId conversationId:(NSString *)aConversationId result:(NSError *)aResult{
    /// 你可以在消息发送完成后，做一些事情，例如播放一个提示音等等
}






#pragma mark -发送消息
/**
 * 消息发送分为以下几个步骤：
 构造消息体：根据你要发送的消息类型，构造YWMessageBody的子类对象，塞入要发送的数据。【YWMessageBody.h】
 构造消息控制参数（用于控制消息Push文案、是否仅存本地等），详细请阅读本文后面的章节消息发送控制
 获取会话：根据接收方，获取对应的会话，例如一个单聊会话。
 发送消息：通过YWConversation的asyncSendMessageBody:progress:completion:方法发送消息。
 
 文本消息体YWMessageBodyText   messageText
 图片消息体YWMessageBodyImage
 
 
 
 语音消息体 YWMessageBodyVoice
 YWMessageBodyVoice *bodyVoice = [[YWMessageBodyVoice alloc] initWithMessageVoiceData:wavData
 duration:nRecordingTime];
 [self.conversation asyncSendMessageBody:bodyVoice progress:nil completion:NULL];
 
 
 用地理坐标和位置名称 YWMessageBodyLocation
 YWMessageBodyLocation *messageBody = [[YWMessageBodyLocation alloc] initWithMessageLocation:location locationName:name];
 if (messageBody) {
 [weakController.conversation asyncSendMessageBody:messageBody progress:nil completion:NULL];
 }
 
 
 自定义消息体 YWMessageBodyCustomize允许您发送包含您的自定义数据的消息，您需要使用自定义消息内容
 YWMessageBodyCustomize *messageBody = [[YWMessageBodyCustomize alloc] initWithMessageCustomizeContent:self.contentTextView.text summary:self.summeryTextView.text];
 
 [self.conversation asyncSendMessageBody:messageBody
 progress:nil
 completion:^(NSError *error, NSString *messageID) {
 /// show result
 }];
 
 
 **/
- (void)sendImageMessageData:(NSData *)imageData
{
    /// 构造消息体
    YWMessageBodyImage *imageMessageBody = [[YWMessageBodyImage alloc] initWithMessageImageData:imageData];
    
    /// 获取会话
    YWP2PConversation *conv = [YWP2PConversation fetchConversationByPerson:[[YWPerson alloc] initWithPersonId:@"uid1"] creatIfNotExist:YES baseContext:self.myYWIMKit.IMCore];
    
    /// 发送消息
    [conv asyncSendMessageBody:imageMessageBody controlParameters:nil progress:^(CGFloat progress, NSString *messageID) {
        
        /// 更新消息进度显示
        
    } completion:^(NSError *error, NSString *messageID) {
        if (error) {
            /// 消息发送失败，提示用户
        }
    }];
}

@end
