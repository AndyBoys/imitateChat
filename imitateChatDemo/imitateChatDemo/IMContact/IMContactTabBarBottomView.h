//
//  IMContactTabBarBottomView.h
//  lesogo_tianGengiPhone
//
//  Created by Lesogo_A1 on 2017/6/26.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface IMContactTabBarBottomView : UIView

/**
 录音完成后回调，返回录音文件地址

 @param recorderBlock recorderBlock 调回音频地址
 */
-(void)didFinishedRecorder:(void (^)(NSString *aduioPath, NSURL *audioURL, CGFloat duration))recorderBlock;

/**
 发送视频信息

 @param vedioBlock vedioBlock description
 */
-(void)didSendVedio:(void(^)(NSString *vedioPath, NSURL *vedioURL))vedioBlock;


/**
 发送图片信息

 @param imageBlock imageBlock description
 */
-(void)didSendImage:(void(^)(NSData  *imageData))imageBlock;


/**
 发送文字和表情信息

 @param messageBlock messageBlock description
 */
-(void)didSendContentMessage:(void(^)(NSString *contentMeaage))messageBlock;


/**
 发起远程请求 flag参数备选

 @param remoteBlock remoteBlock description
 */
-(void)didSendRemoteRequest:(void (^)(BOOL flag))remoteBlock;


/**
 改变布局
 
 @param frameBlock frameBlock frame 当前布局
 */
-(void)didChangeFrame:(void(^)(CGRect frame))frameBlock;


/**
 播放音频

 @param audioURL audioURL 音频路径
 */
-(void)startPlayAudioWithURL:(NSURL *)audioURL;


/**
 播放音频

 @param audioPath audioPath 音频路径
 */
-(void)startPlayAudioWithPath:(NSString *)audioPath;


/**
 停止播放   
 */
-(void)stopPlayAudio;


@end
