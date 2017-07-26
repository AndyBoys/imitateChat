//
//  IMPlayerMediaManager.m
//  lesogo_tianGengiPhone
//
//  Created by Lesogo_A1 on 2017/7/5.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import "IMPlayerMediaManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

static IMPlayerMediaManager *mediaManager = nil;

@interface IMPlayerMediaManager ()
@property (strong, nonatomic) AVAudioPlayer             *player;



@end

@implementation IMPlayerMediaManager

+(IMPlayerMediaManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediaManager = [[[self class] alloc] init];
    });
    
    return mediaManager;
}


-(id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return self;
}


-(void)stopPlay
{
    if(self.player)
    {
        [self.player stop];
    }
}


-(void)startPlayAudioWithURL:(NSURL *)audioURL
{
    if(audioURL)
    {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
        [self.player prepareToPlay];
        [self.player play];
    }
}



-(void)startPlayAudioWithPath:(NSString *)audioPath
{
    if(audioPath)
    {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
       
        if([audioPath hasPrefix:@"/var/mobile"])
        {
            NSData *data = [NSData dataWithContentsOfFile:audioPath];
            self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
        }else
        {
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:audioPath] error:nil];
        }
        self.player.volume = 1;
        [self.player prepareToPlay];
        [self.player play];
    }
}



@end
