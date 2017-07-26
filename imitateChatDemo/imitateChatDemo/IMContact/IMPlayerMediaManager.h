//
//  IMPlayerMediaManager.h
//  lesogo_tianGengiPhone
//
//  Created by Lesogo_A1 on 2017/7/5.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMPlayerMediaManager : NSObject
+(IMPlayerMediaManager *)shareInstance;

//网络
-(void)startPlayAudioWithURL:(NSURL *)audioURL;

//本地
-(void)startPlayAudioWithPath:(NSString *)audioPath;

-(void)stopPlay;


@end
