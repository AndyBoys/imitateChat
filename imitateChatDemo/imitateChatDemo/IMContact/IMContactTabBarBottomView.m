//
//  IMContactTabBarBottomView.m
//  lesogo_tianGengiPhone
//
//  Created by Lesogo_A1 on 2017/6/26.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import "IMContactTabBarBottomView.h"
#import <AVFoundation/AVFoundation.h>
#import "IMContactEmotionView.h"
#import <MobileCoreServices/MobileCoreServices.h>


typedef void(^IMContactRecorderCompleteBlock)(NSString *aduioPath, NSURL *audioURL, CGFloat duration);//录音
typedef void(^IMContactSendMessageBlock)(NSString *contentMeaage);//文字和表情
typedef void(^IMContactSendImageBlock)(NSData  *imageData);//图片
typedef void(^IMContactSendVedio)(NSString *vedioPath, NSURL *vedioURL);//视频
typedef void(^IMContactSendRemoteRequestBlock)(BOOL flag);

typedef void(^IMcontactChangeFrameBlock)(CGRect frame);




//将数字转为
#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24)

@interface IMContactTabBarBottomView ()<UITextFieldDelegate,AVAudioRecorderDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CGFloat     currentOffY;
    CGRect      currentFrame;
    
    CGFloat     durationTime;
    
    NSTimer     *voiceTimer;
    NSInteger   timeLong;
    
    NSInteger   selectIndex;
}


@property (strong, nonatomic) UIView        *baseContentBackView;
@property (strong, nonatomic) UIView        *moreContentBackView;


@property (strong, nonatomic) UIButton          *voiceButton;
@property (strong, nonatomic) UIButton          *pressLongvoiceButton;


@property (strong, nonatomic) UITextField       *textMessage;

@property (strong, nonatomic) UIButton          *emotionButton;

@property (strong, nonatomic) UIButton          *moreOrSend;

@property (strong, nonatomic) UIButton          *maxRecorderBurron;
@property (strong, nonatomic) UIImageView          *fullvoiceImgView;
@property (strong, nonatomic) UIImageView       *recorderAnnotate;//录音动画

//录音
@property (strong, nonatomic) AVAudioSession            *session;
@property (strong, nonatomic) NSString                  *filePath;
@property (strong, nonatomic) NSURL                     *recordFileUrl;
@property (strong, nonatomic) NSDictionary              *recordSetting;
@property (strong, nonatomic) AVAudioRecorder           *recorder;

@property (strong, nonatomic) AVAudioPlayer             *player;

@property (strong, nonatomic) IMContactEmotionView      *emotionView;

@property (nonatomic) IMContactRecorderCompleteBlock            recorderBlock;
@property (nonatomic) IMContactSendMessageBlock                 messageBlock;
@property (nonatomic) IMContactSendImageBlock                   imageBlock;
@property (nonatomic) IMContactSendVedio                        vedioBlock;
@property (nonatomic) IMContactSendRemoteRequestBlock           remoteBlock;

@property (nonatomic) IMcontactChangeFrameBlock                 frameBlock;





@end




@implementation IMContactTabBarBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if(self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        currentOffY = 0;
        timeLong=0;
        selectIndex=-1;
        
//        [self setClipsToBounds:YES];
        [self addbackView];
        [self addBaseView];
        [self addItemsButton];
        [self addEmoview];
    }
    
    return self;
}

/*
 //获取数组
 NSArray *arrEmotion = [self defaultEmoticons];
 for (NSString *str in arrEmotion) {
 NSLog(@===%@,str);
 }
 **/
//获取默认表情数组
- (NSMutableArray *)defaultEmoticons {
    NSMutableArray *array = [NSMutableArray new];
    for (int i=0x1F600; i<=0x1F64F; i++) {
        if (i < 0x1F641 || i > 0x1F644) {
            int sym = EMOJI_CODE_TO_SYMBOL(i);
            NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
            [array addObject:emoT];
        }
    }
    return array;
}



-(void)addbackView
{
    _baseContentBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
    _baseContentBackView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_baseContentBackView];
    
    _moreContentBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 54, self.width, self.height-54)];
    _moreContentBackView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_moreContentBackView];
    
    
//    _moreContentBackView.hidden = YES;
}



-(void)addBaseView
{
    _voiceButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 34, 34)];
    [_voiceButton setImage:[UIImage imageNamed:@"IMVoice"] forState:(UIControlStateNormal)];
    [_voiceButton setImage:[UIImage imageNamed:@"IMVoice"] forState:(UIControlStateSelected)];
    [_voiceButton setTintColor:[UIColor clearColor]];
    [_voiceButton setBackgroundColor:[UIColor clearColor]];
    [_baseContentBackView addSubview:_voiceButton];
    [_voiceButton addTarget:self action:@selector(didSelectedvoiceButton:) forControlEvents:(UIControlEventTouchUpInside)];
    

    _moreOrSend = [[UIButton alloc] initWithFrame:CGRectMake(_baseContentBackView.width-44, 5, 34, 34)];
//    [_moreOrSend setImage:[UIImage imageNamed:@"IMMore"] forState:(UIControlStateNormal)];
//    [_moreOrSend setImage:[UIImage imageNamed:@"IMMore"] forState:(UIControlStateSelected)];
    
//    [_moreOrSend setBackgroundImage:[UIImage imageNamed:@"IMMore"] forState:(UIControlStateNormal)];
//    [_moreOrSend setBackgroundImage:[UIImage imageNamed:@"userHeader"] forState:(UIControlStateSelected)];
    _moreOrSend.titleLabel.font = [UIFont systemFontOfSize:13];
    [_moreOrSend setTitle:@"more" forState:UIControlStateNormal];
     [_moreOrSend setTitle:@"send" forState:UIControlStateSelected];
    [_moreOrSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_moreOrSend setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    
    [_moreOrSend setTintColor:[UIColor clearColor]];
    [_moreOrSend setBackgroundColor:[UIColor redColor]];
    [_baseContentBackView addSubview:_moreOrSend];
    [_moreOrSend addTarget:self action:@selector(didMoreOrSender:) forControlEvents:(UIControlEventTouchUpInside)];

    
    _emotionButton = [[UIButton alloc] initWithFrame:CGRectMake(_moreOrSend.left-44, 5, 34, 34)];
    [_emotionButton setImage:[UIImage imageNamed:@"IMEmotion"] forState:(UIControlStateNormal)];
    [_emotionButton setImage:[UIImage imageNamed:@"IMEmotion"] forState:(UIControlStateSelected)];
    [_emotionButton setTintColor:[UIColor clearColor]];
    [_emotionButton setBackgroundColor:[UIColor clearColor]];
    [_baseContentBackView addSubview:_emotionButton];
    [_emotionButton addTarget:self action:@selector(didEmotionButton:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    _textMessage = [[UITextField alloc] initWithFrame:CGRectMake(_voiceButton.right+10, 5, _baseContentBackView.width-_voiceButton.right-10- 98, 34)];
    _textMessage.delegate =self;
    _textMessage.font = [UIFont systemFontOfSize:15];
    _textMessage.textColor = [UIColor blackColor];
    [_textMessage.layer setMasksToBounds:YES];
    [_textMessage.layer setCornerRadius:5];
    [_textMessage.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.3] CGColor]];
    [_textMessage.layer setBorderWidth:1];
    [_baseContentBackView addSubview:_textMessage];
    
    
//    _maxRecorderBurron = [[UIButton alloc] initWithFrame:CGRectMake((LCDW-100)/2.0,(self.height-44-100)/2.0+44, 100, 100)];
     _maxRecorderBurron = [[UIButton alloc] initWithFrame:_textMessage.frame];
//    [_maxRecorderBurron setBackgroundImage:[UIImage imageNamed:@"userHeader"] forState:(UIControlStateNormal)];
//    [_maxRecorderBurron setBackgroundImage:[UIImage imageNamed:@"userHeader"] forState:(UIControlStateSelected)];
    [_maxRecorderBurron setTitle:@"按住录音" forState:(UIControlStateNormal)];
    [_maxRecorderBurron setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
    _maxRecorderBurron.hidden = YES;
    [_maxRecorderBurron addTarget:self action:@selector(didtouchUpinside:) forControlEvents:(UIControlEventTouchUpInside)];
    [_maxRecorderBurron addTarget:self action:@selector(didTouchDowm:) forControlEvents:(UIControlEventTouchDown)];
    [_maxRecorderBurron addTarget:self action:@selector(didOutsideRecorder:) forControlEvents:(UIControlEventTouchUpOutside)];
    [_maxRecorderBurron addTarget:self action:@selector(didCancel:) forControlEvents:(UIControlEventTouchCancel)];
    [_baseContentBackView addSubview:_maxRecorderBurron];
    
    
    
    NSArray *imges = @[[UIImage imageNamed:@"IMVoiceWave"],[UIImage imageNamed:@"IMVoice"]];
    _fullvoiceImgView =[[UIImageView alloc] initWithFrame:CGRectMake((LCDW-100)/2.0, (LCDH-100)/2.0, 100, 100)];
    [_fullvoiceImgView setTintColor:[UIColor clearColor]];
    [_fullvoiceImgView setBackgroundColor:[UIColor clearColor]];
    _fullvoiceImgView.animationImages = imges;
    _fullvoiceImgView.animationDuration=1;
    _fullvoiceImgView.animationRepeatCount=0;
    _fullvoiceImgView.hidden = YES;
    [[[UIApplication sharedApplication] keyWindow] addSubview:_fullvoiceImgView];
    
}








-(void)addItemsButton
{
    float space = (_moreContentBackView.width- 132)/4.0;
    NSArray *itemList = @[@"IMEmotion",@"IMPhoto",@"IMCamera"];
    for (int i=0; i<[itemList count]; i++) {
       UIButton * item = [[UIButton alloc] initWithFrame:CGRectMake(space+i*(44+space), 0, 44, 44)];
        [item setImage:[UIImage imageNamed:itemList[i]] forState:(UIControlStateNormal)];
        [item setImage:[UIImage imageNamed:itemList[i]] forState:(UIControlStateSelected)];
        
        [item setTintColor:[UIColor clearColor]];
        [item setBackgroundColor:[UIColor clearColor]];
        [item setTag:i];
        [_moreContentBackView addSubview:item];
        [item addTarget:self action:@selector(didSeletectedItem:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}




-(void)addEmoview
{
    if(!_emotionView)
    {
        _emotionView= [[IMContactEmotionView alloc] initWithFrame:CGRectMake(0, 49, self.width, self.height-49)];
        _emotionView.hidden = YES;
        _emotionView.backgroundColor = [UIColor whiteColor];
        [_emotionView setEmotionDatas:[self defaultEmoticons]];
        __weak typeof(self)weakself = self;
        [_emotionView didSelectedEmotionItem:^(NSString *emotion) {
            NSMutableString *info = [[NSMutableString alloc] initWithFormat:@"%@%@",weakself.textMessage.text,emotion];
            weakself.textMessage.text = info;
            weakself.moreOrSend.selected = YES;
        }];
        [self addSubview:_emotionView];
    }
}




#pragma mark - textfieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _moreOrSend.selected = NO;
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text length]==0)
    {
        _moreOrSend.selected = NO;
    }else
    {
        if([string isEqualToString:@""])
        {
            if([textField.text length]==1)
            {
             _moreOrSend.selected = NO;
            }else
            {
                _moreOrSend.selected = YES;
            }
        }else
        {
            _moreOrSend.selected = YES;
        }
    }
    return YES;
}




-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    if ([textField.text length]==0)
    {
        _moreOrSend.selected = NO;
    }else
    {
        _moreOrSend.selected = NO;
         [self sendMessage:textField.text];
        textField.text=nil;
    }
    return YES;
}



-(void)sendMessage:(NSString *)message
{
    _moreOrSend.selected = NO;
    _messageBlock(message);
    
}

#pragma mark - 事件处理
-(void)didSelectedvoiceButton:(UIButton *)voice
{
     [_textMessage resignFirstResponder];
    [self setFrame:CGRectMake(self.origin.x, LCDH-50, self.width, self.height)];
    selectIndex = 0;
    if(voice.selected)
    {
        voice.selected = NO;
        _textMessage.hidden = NO;
        _maxRecorderBurron.hidden = YES;
    }else
    {
        voice.selected = YES;
        _maxRecorderBurron.hidden = NO;
        _textMessage.hidden = YES;
        _textMessage.text = nil;
        
        _moreOrSend.selected = NO;
        _emotionButton.selected = NO;
         currentOffY = 0;
        
    }
}


-(void)didEmotionButton:(UIButton *)sender
{
    _emotionView.hidden = NO;
    _moreContentBackView.hidden = YES;
    _maxRecorderBurron.hidden = YES;
    _voiceButton.selected = NO;
    _moreOrSend.selected = NO;
    _textMessage.hidden = NO;
    
     [_textMessage resignFirstResponder];
    selectIndex=1;
    
    
    if(sender.selected)
    {
        sender.selected =NO;
        self.frame= currentFrame;
        currentOffY = 0;
        _frameBlock(self.frame);
    }else
    {
        sender.selected =YES;
        //显示更多
        if(currentOffY==0)
        {
            currentFrame = self.frame;
            self.frame = CGRectMake(self.origin.x, self.origin.y-(self.height-44), self.width, self.height);
            currentOffY = self.origin.y;
            _frameBlock(self.frame);
        }
//        else
//        {
//            self.frame= currentFrame;
//            currentOffY = 0;
//        }
    }
    
    
}



//touch up inside
-(void)didMoreOrSender:(UIButton *)sender
{
    if(sender.selected)
    {
        //发送消息
        [self sendMessage:_textMessage.text];
        _textMessage.text = nil;
//        self.frame= currentFrame;
//        currentOffY = 0;
    }else
    {
        
        _emotionView.hidden = YES;
        _moreContentBackView.hidden = NO;
        _maxRecorderBurron.hidden = YES;
        _voiceButton.selected = NO;
         _textMessage.hidden = NO;
        _emotionButton.selected = NO;
        
        //显示更多
         [_textMessage resignFirstResponder];
        if(currentOffY==0)
        {
            currentFrame = self.frame;
            self.frame = CGRectMake(self.origin.x, self.origin.y-(self.height-44), self.width, self.height);
            currentOffY = self.origin.y;
            _frameBlock(self.frame);
            
        }
        else
        {
            if(selectIndex==1)
            {
                selectIndex=2;
                _emotionView.hidden = YES;
                _moreContentBackView.hidden = NO;
            }else
            {
                self.frame= currentFrame;
                currentOffY = 0;
                _frameBlock(self.frame);
            }
            
        }
    }
}




    //按下录音按钮开始录音
-(void)didTouchDowm:(UIButton *)sender
{
    [self initializeSession];
    durationTime = 0;
    [self startRecoder];
    _fullvoiceImgView.hidden  =NO;
    [_fullvoiceImgView startAnimating];
}

-(void)didtouchUpinside:(UIButton *)sender
{
    durationTime =  [_recorder currentTime];
    [voiceTimer invalidate];
    voiceTimer = nil;
    [_fullvoiceImgView startAnimating];
    _fullvoiceImgView.hidden  =YES;
    
    [self stopPlayAudio];
}





//松开手指，停止录音 touch uo out side
-(void)didOutsideRecorder:(UIButton*)sender
{
    durationTime =  [_recorder currentTime];
    [voiceTimer invalidate];
    voiceTimer = nil;
    [_fullvoiceImgView startAnimating];
    _fullvoiceImgView.hidden  =YES;
    [self.recorder deleteRecording];
    self.recorder=nil;
//    [self stopPlayAudio];
}



-(void)didCancel:(UIButton *)sender
{
    durationTime =  [_recorder currentTime];
    [voiceTimer invalidate];
    voiceTimer = nil;
    [self stopPlayAudio];
}




-(void)didSeletectedItem:(UIButton *)item
{
    NSInteger tag = item.tag;
    switch (tag) {

        case 0://相册
        {
            _moreContentBackView.hidden = YES;
            _emotionView.hidden = NO;
            _emotionButton.selected = YES;
            
        }
            break;
        case 1://相机
        {
           [self showALbum];
        }
            break;
        case 2://远程请求
        {
             [self showCamera];
//            _remoteBlock(YES);
        }
            break;
        default:
            break;
    }
}



//
/*
 typedef void(^IMContactSendMessageBlock)(NSString *contentMeaage);//文字和表情
 typedef void(^IMContactSendImageBlock)(UIImage  *image);//图片
 typedef void(^IMContactSendVedio)(NSString *vedioPath, NSURL *vedioURL);//视频
 **/

-(void)didFinishedRecorder:(void (^)(NSString *aduioPath, NSURL *audioURL, CGFloat duration))recorderBlock
{
    _recorderBlock = recorderBlock;
}

-(void)didSendContentMessage:(void(^)(NSString *contentMeaage))messageBlock
{
    _messageBlock = messageBlock;
}

-(void)didSendImage:(void(^)(NSData  *imageData))imageBlock
{
    _imageBlock = imageBlock;
}


-(void)didSendVedio:(void(^)(NSString *vedioPath, NSURL *vedioURL))vedioBlock
{
    _vedioBlock = vedioBlock;
}


-(void)didSendRemoteRequest:(void (^)(BOOL flag))remoteBlock
{
    _remoteBlock = remoteBlock;
}

-(void)didChangeFrame:(void (^)(CGRect))frameBlock
{
    _frameBlock = frameBlock;
}



#pragma mark - 相机和相册
-(void)showCamera
{
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate =self;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
//        NSArray *mediatypes= @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
        NSArray *mediatypes= @[(NSString *)kUTTypeImage];
        imgPicker.mediaTypes = mediatypes;
        [imgPicker setCameraCaptureMode:UIImagePickerControllerCameraCaptureModePhoto];
//        [imgPicker setVideoMaximumDuration:60];
//        [imgPicker setVideoQuality:UIImagePickerControllerQualityType640x480];
    }
    else
    {
         [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
       
    }
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:imgPicker animated:YES completion:^{
        
    }];
    
}

-(void)showALbum
{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate =self;
    [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:imgPicker animated:YES completion:^{
        
    }];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    id  MediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([MediaType isEqualToString:@"public.movie"])
    {
        NSURL *url=[info objectForKey:UIImagePickerControllerMediaURL];//视频路径
        NSString *urlStr=[url path];
//         UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr );
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(urlStr)) {
            //保存视频到相簿，注意也可以使用ALAssetsLibrary来保存
            UISaveVideoAtPathToSavedPhotosAlbum(urlStr, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);//保存视频到相簿
             _vedioBlock(urlStr,url);
        }
        
         [picker dismissViewControllerAnimated:YES completion:nil];
        self.frame= currentFrame;
        currentOffY = 0;
       _frameBlock(self.frame);
    }else
    {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
//        UIImageWriteToSavedPhotosAlbum(image, self, @selector(didSaveImge), nil);
        _imageBlock(UIImageJPEGRepresentation(image, 1));
         [picker dismissViewControllerAnimated:YES completion:nil];
        self.frame= currentFrame;
        currentOffY = 0;
        _frameBlock(self.frame);
    }
   
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//视频保存后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
    }
}

-(void)didSaveImge
{
    
}



#pragma mark  -Recorder delegate
/* audioRecorderDidFinishRecording:successfully: is called when a recording has been finished or stopped. This method is NOT called if the recorder is stopped due to an interruption. */
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
   
    
    if(!flag)
    {
        [_recorder deleteRecording];
        _filePath = nil;
        _recordFileUrl = nil;
//        _recorderBlock(nil,nil,0);
    }else
    {
        if(durationTime >=1)
        {
            timeLong = 0;
             _recorderBlock(_filePath, _recordFileUrl,durationTime);
        }else
        {
            timeLong = 0;
            [SVProgressHUD showInfoWithStatus:@"时间太短了！"];
        }
    }
}



/* if an error occurs while encoding it will be reported to the delegate. */
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error{
    
//    [self removeRecoderFiled];
    [_recorder deleteRecording];
    _filePath = nil;
    _recordFileUrl = nil;
    timeLong = 0;
    durationTime=0;
//    _recorderBlock(nil,nil,0);
}



//中断出来
///* AVAudioRecorder INTERRUPTION NOTIFICATIONS ARE DEPRECATED - Use AVAudioSession instead. */
//
///* audioRecorderBeginInterruption: is called when the audio session has been interrupted while the recorder was recording. The recorded file will be closed. */
//- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder {
//
//}
//
///* audioRecorderEndInterruption:withOptions: is called when the audio session interruption has ended and this recorder had been interrupted while recording. */
///* Currently the only flag is AVAudioSessionInterruptionFlags_ShouldResume. */
//- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags {
//
//}
//
//- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withFlags:(NSUInteger)flags {
//
//}
//
///* audioRecorderEndInterruption: is called when the preferred method, audioRecorderEndInterruption:withFlags:, is not implemented. */
//- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder{
//
//}





#pragma mark  -外部调用 控制音频
- (void)stopPlayAudio
{
    NSLog(@"停止录音");
    [self.recorder stop];
}


//-(void)startPlayAudioWithURL:(NSURL *)audioURL
//{
//    if(audioURL)
//    {
//        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
//        [[AVAudioSession sharedInstance] setActive:YES error:nil];
//        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
//        [self.player prepareToPlay];
//        [self.player play];
//    }
//}
//
//
//
//-(void)startPlayAudioWithPath:(NSString *)audioPath
//{
//    if(audioPath)
//    {
//        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
//        [[AVAudioSession sharedInstance] setActive:YES error:nil];
//        NSData *data = [NSData dataWithContentsOfFile:audioPath];
//        self.player = [[AVAudioPlayer alloc] initWithData:data error:nil];
//        self.player.volume = 1;
////        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:audioPath] error:nil];
//        [self.player prepareToPlay];
//        [self.player play];
//    }
//}




-(void)initializeSession
{
    if(!_recordSetting)
    {
        //设置参数
//        _recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          //采样率  8000/11025/22050/44100/96000（影响音频的质量）
//                          [NSNumber numberWithFloat: 8000.0],AVSampleRateKey,
//                          // 音频格式
//                          [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
//                          //采样位数  8、16、24、32 默认为16
//                          [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
//                          // 音频通道数 1 或 2
//                          [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
//                          //录音质量
//                          [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
//                          [NSNumber numberWithInt:YES] ,AVLinearPCMIsFloatKey,
//                          nil];
        
        
        _recordSetting = @{AVFormatIDKey: @(kAudioFormatLinearPCM),
                                   AVSampleRateKey: @8000.00f,
                                   AVNumberOfChannelsKey: @1,
                                   AVLinearPCMBitDepthKey: @16,
                                   AVLinearPCMIsNonInterleaved: @NO,
                                   AVLinearPCMIsFloatKey: @NO,
                                   AVLinearPCMIsBigEndianKey: @NO,
                                    AVEncoderAudioQualityKey:@(AVAudioQualityMedium)
                           };
    }
}



//按下录音按钮
-(void)startRecoder
{
    NSTimeInterval timeNum = [[NSDate date] timeIntervalSince1970];
    //1.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    _filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld_IM.wav",(long)timeNum]];
    //2.获取文件路径
    _recordFileUrl = [NSURL fileURLWithPath:_filePath];

    
    NSError *error;
    BOOL success = [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:&error];
    if(error)
    {
        
        NSLog(@"不支持录音");
        return;
    }
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    if(error)
    {
        NSLog(@"%@", [error description]);
    }
    
    if(_recorder)
    {
        [_recorder stop];
        _recorder = nil;
    }
    
    voiceTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timertip:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:voiceTimer forMode:NSRunLoopCommonModes];
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:_recordFileUrl settings:_recordSetting error:&error];
    if (_recorder) {
        
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
        [_recorder setDelegate:self];
        [voiceTimer fire];
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
    }
}


-(void)timertip:(NSTimer *)timer
{
    ++timeLong;
    NSLog(@"timeLength:%d",timeLong);
    if( timeLong>60)
    {
        [voiceTimer invalidate];
        voiceTimer = nil;
        timeLong = 0;
    }
}



-(void)removeRecoderFiled
{
    //双重删除残余文件
    NSFileManager*filedManager = [NSFileManager defaultManager];
    if([filedManager fileExistsAtPath:_filePath])
    {
        NSError *error ;
        [filedManager removeItemAtPath:_filePath error:&error];
        if(error)
        {
            NSLog(@"删除当前录音文件出错");
        }
    }
    
    if([filedManager fileExistsAtPath:_filePath])
    {
        NSError *error ;
        [filedManager removeItemAtURL:_recordFileUrl error:&error];
    }
}


@end

