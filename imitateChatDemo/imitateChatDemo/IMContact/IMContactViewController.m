//
//  IMContactViewController.m
//  lesogo_tianGengiPhone
//
//  Created by Lesogo_A1 on 2017/6/23.
//  Copyright © 2017年 Lesogo. All rights reserved.
//

#import "IMContactViewController.h"
#import "IMTextTableViewCell.h"
#import "IMVedioTableViewCell.h"
#import "IMSymbolTableViewCell.h"
#import "IMVoiceTableViewCell.h"
#import "IMImageTableViewCell.h"

#import "IMContactMessageModel.h"
#import <MediaPlayer/MediaPlayer.h>

#import "IMContactTabBarBottomView.h"

#import "IMPlayerMediaManager.h"




static NSString *type_text = @"TextTableViewCell";
static NSString *type_image = @"ImageTableViewCell";
static NSString *type_voice = @"VoiceTableViewCell";
static NSString *type_vedio = @"VedioTableViewCell";
static NSString *type_symbol = @"SymbolTableViewCell";



typedef NS_ENUM(NSInteger,NSIMMessageType)
{
    NSIMMessageTypeText     =0,//文字
    NSIMMessageTypeVoice    =1,//声音
    NSIMMessageTypeImage    =2,//图片
    NSIMMessageTypeVedio    =3,//视频
    NSIMMessageTypeUnknown  =4//不识别类型
};




@interface IMContactViewController () <UITableViewDelegate,UITableViewDataSource>
{
    CGRect tabBarViewRect;
    
    
}


@property (strong, nonatomic) UITableView       *IMContactListView;

@property (strong, nonatomic) NSMutableArray<IMContactMessageModel*>    *IMListData;

@property (nonatomic)NSIMMessageType           IMMessageType;

@property (strong, nonatomic) MPMoviePlayerViewController   *moviePlayer;

@property (strong, nonatomic) NSString  *userId;

@property (strong, nonatomic) IMContactTabBarBottomView     *tabBarView;

@property (strong, nonatomic) IMVoiceTableViewCell    *voiceItemPlayerCell;

@end





@implementation IMContactViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"某某";
    [self testData];
    [self addIMListView];
    [self addTarBarView];
    [self addRemoteService];
    [self.IMContactListView setContentOffset:CGPointMake(0, self.IMContactListView.contentSize.height - self.IMContactListView.height) animated:NO];
   
    
}


-(void)addNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thekeyWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(theKeyWillHiden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerDidfinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerDidfinished:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    
}

-(void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
}



-(void)thekeyWillShow:(NSNotification *)notification
{
    if(tabBarViewRect.origin.y==0)
    {
        tabBarViewRect = _tabBarView.frame;
        
        CGRect keyFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        _tabBarView.frame = CGRectMake(0, (LCDH-50)-keyFrame.size.height, tabBarViewRect.size.width, tabBarViewRect.size.height);
        CGRect IMListViewFrame = _IMContactListView.frame;
        IMListViewFrame.size.height -= keyFrame.size.height;
        _IMContactListView.frame =IMListViewFrame;
        
    }
}




-(void)theKeyWillHiden:(NSNotification *)notification
{
    
    if(tabBarViewRect.origin.y>0)
    {
        _tabBarView.frame  = tabBarViewRect;
        
        CGRect IMListViewFrame = _IMContactListView.frame;
        IMListViewFrame.size.height = LCDH-124;
        _IMContactListView.frame =IMListViewFrame;
        tabBarViewRect= CGRectZero;
    }
 
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
     [self addNotifications];;
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self removeNotifications];
    [super viewWillDisappear:animated];
}


-(IMContactMessageType)getmessageType:(NSInteger)tag
{
    IMContactMessageType mesageType;
    switch (tag) {
        case 0:
        {
            mesageType=IMContactMessageTypeText;
        }
            break;
        case 1:
        {
            mesageType=IMContactMessageTypeText;
        }
            break;
        case 2:
        {
            mesageType=IMContactMessageTypeImage;
        }
            break;
        case 3:
        {
            mesageType=IMContactMessageTypeVoice;
        }
            break;
        case 4:
        {
//            mesageType=IMContactMessageTypeVedio;
        }
//            break;
        case 5:
        {
            mesageType=IMContactMessageTypeEmotion;
        }
            break;
        case 6:
        {
            mesageType=IMContactMessageTypePromptInformation;
        }
            break;
        case 7:
        {
            mesageType=IMContactMessageTypeRomote;
        }
            break;
        default:
            break;
    }
    return mesageType;
}

-(void)testData
{
    if(!_IMListData)
        _IMListData = [[NSMutableArray alloc] init];
    else
        [_IMListData removeAllObjects];
    _userId = @"1";
    NSString *message = @"新《种子法》和相关配套法规相续出台实施，省农作物品种盛鼎委员会一定要认真研究...";
    for (int i =0; i<15; i++) {
        IMContactMessageModel *model = [[IMContactMessageModel alloc] init];
        model.userId = [NSString stringWithFormat:@"%d",arc4random()%2+1];
        model.userName = @"测试用户用例";
        model.userHeaderImagePath = @"";
        if([model.userId isEqualToString:@"1"])
        {
            model.userRole = IMContactUserRoleReceiver;
        }else
        {
            model.userRole = IMContactUserRoleSender;
        }
        
        model.isPlayStream = NO;
        
        model.messageContent = message;
        model.messageType = [self getmessageType:arc4random()%6];
        model.messageDate = @"2017-6-28";
       
        model.pictureUrlPath = @"";
        model.voiceUrlPath = @"";
        model.vedioUrlPath = @"";
        model.duration = 15;
        model.currentState = IMContactLineStateOnLine;
        [_IMListData addObject:model];
    }
}



-(void)senderMessage
{
    NSString *message = @"插入新的消息，新《种子法》和相关配套法规相续出台实施，省农作物品种盛鼎委员会一定要认真研究...";
    IMContactMessageModel *model = [[IMContactMessageModel alloc] init];
    model.userId = @"1";
    model.userName = @"测试用户用例";
    model.userHeaderImagePath = @"";
    model.userRole = IMContactUserRoleReceiver;
 
    model.isPlayStream = NO;
    model.messageContent = message;
    model.messageType = IMContactMessageTypeVoice;
    model.messageDate = @"2017-6-28";
    
    model.pictureUrlPath = @"";
    model.voiceUrlPath = @"";
    model.vedioUrlPath = @"";
    model.duration = 15;
    model.currentState = IMContactLineStateOnLine;
    [_IMListData addObject:model];
}




-(void)RecieveMessage
{
    NSString *message = @"接收插入新的消息，新《种子法》和相关配套法规相续出台实施，省农作物品种盛鼎委员会一定要认真研究...";
    IMContactMessageModel *model = [[IMContactMessageModel alloc] init];
    model.userId = @"2";
    model.userName = @"测试用户用例";
    model.userHeaderImagePath = @"";
    model.userRole = IMContactUserRoleSender;
    model.isPlayStream = NO;
    model.messageContent = message;
    model.messageType = IMContactMessageTypeVoice;
    model.messageDate = @"2017-6-28";
    
    model.pictureUrlPath = @"";
    model.voiceUrlPath = @"";
    model.vedioUrlPath = @"";
    model.duration = 15;
    model.currentState = IMContactLineStateOnLine;
    [_IMListData addObject:model];
}



-(void)addRemoteService
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-54, 20, 44, 44)];
    [button setImage:[UIImage imageNamed:@"IMRemote"] forState:(UIControlStateNormal)];
    [button setTintColor:[UIColor clearColor]];
    [button setContentMode:(UIViewContentModeScaleAspectFit)];
    button.backgroundColor = [UIColor clearColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(didRemote:) forControlEvents:(UIControlEventTouchUpInside)];
}




-(void)didRemote:(UIButton *)sender
{

}





-(void)addTarBarView
{
    __weak typeof(self)weakseslf = self;
    _tabBarView = [[IMContactTabBarBottomView alloc] initWithFrame:CGRectMake(0, LCDH-44, LCDW, 150)];
    //音频
    [_tabBarView didFinishedRecorder:^(NSString *aduioPath, NSURL *audioURL, CGFloat duration) {
        NSString *message = @"接收插入新的消息，新《种子法》和相关配套法规相续出台实施，省农作物品种盛鼎委员会一定要认真研究...";
        IMContactMessageModel *model = [[IMContactMessageModel alloc] init];
        model.userId = @"2";
        model.userName = @"测试用户用例";
        model.userHeaderImagePath = @"";
        model.userRole = IMContactUserRoleReceiver;
        model.isPlayStream = NO;
        model.messageContent = message;
        model.messageType = IMContactMessageTypeVoice;
        model.messageDate = @"2017-6-28";
        
        model.pictureUrlPath = @"";
        model.voiceUrlPath = aduioPath?aduioPath:@"";
        model.vedioUrlPath = @"";
        model.duration = duration;
        model.currentState = IMContactLineStateOnLine;
        [weakseslf.IMListData addObject:model];
        
        /*
         出于平台兼容和网络优化的考虑，iOS 在语音消息录制的时候使用 WAV 格式录制，由 WAV 数据生成 RCVoiceMessage。 RCVoiceMessage 中的音频会转为 AMR-NB 格式的音频并进行 base64 编码后进行传输。
         
         您可以使用以下参数（单声道、采样率为 8000Hz、位宽为 16 位）录制语音。
         **/
        
        
//        NSData *voiceData = [NSData dataWithContentsOfFile:aduioPath];
//        RCVoiceMessage *voicMessage = [RCVoiceMessage messageWithAudio:voiceData duration:duration];
//        
//        [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE targetId:[[UserManage share] userToken] content:voicMessage pushContent:@"语音消息" pushData:@"test" success:^(long messageId) {
//            NSLog(@"messageId:%ld",messageId);
//        } error:^(RCErrorCode nErrorCode, long messageId) {
//             NSLog(@"nErrorCode:%d",nErrorCode);
//        }];
        
        
//        [[RCIMClient sharedRCIMClient] sendMediaMessage:ConversationType_PRIVATE targetId:[[UserManage share] userToken] content:voicMessage pushContent:@"" pushData:voiceData progress:^(int progress, long messageId) {
//            NSLog(@"progress:%d",progress);
//        } success:^(long messageId) {
//             NSLog(@"messageId:%ld",messageId);
//        } error:^(RCErrorCode errorCode, long messageId) {
//             NSLog(@"messageId:%d",errorCode);
//        } cancel:^(long messageId) {
//            NSLog(@"messageId:%ld",messageId);
//        }];
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakseslf.IMContactListView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[weakseslf.IMListData count]-1 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
            [weakseslf.IMContactListView setContentOffset:CGPointMake(0, weakseslf.IMContactListView.contentSize.height+60 - weakseslf.IMContactListView.height) animated:NO];
            

        });
       }];
        //文字
        [_tabBarView didSendContentMessage:^(NSString *contentMeaage) {
            IMContactMessageModel *model = [[IMContactMessageModel alloc] init];
            model.userId = @"2";
            model.userName = @"测试用户用例";
            model.userHeaderImagePath = @"";
            model.userRole = IMContactUserRoleReceiver;
            model.messageContent = contentMeaage;
            model.messageType = IMContactMessageTypeText;
            model.messageDate = @"2017-6-28";
            model.currentState = IMContactLineStateOnLine;
            [weakseslf.IMListData addObject:model];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakseslf.IMContactListView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[weakseslf.IMListData count]-1 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
                CGSize size =  [Tool getHeightWithMessage:model.messageContent size:CGSizeMake(LCDW-20-140, 100000) font:[UIFont systemFontOfSize:15]];
                if(size.height<30)
                    [weakseslf.IMContactListView setContentOffset:CGPointMake(0, weakseslf.IMContactListView.contentSize.height+60 - weakseslf.IMContactListView.height) animated:NO];
                else [weakseslf.IMContactListView setContentOffset:CGPointMake(0, weakseslf.IMContactListView.contentSize.height + size.height+30 - weakseslf.IMContactListView.height) animated:NO];
            });
        }];
        
        //图片
        [_tabBarView didSendImage:^(NSData  *imageData) {
            
            IMContactMessageModel *model = [[IMContactMessageModel alloc] init];
            model.userId = @"2";
            model.userName = @"测试用户用例";
            model.userHeaderImagePath = @"";
            model.userRole = IMContactUserRoleReceiver;
            model.messageType = IMContactMessageTypeImage;
            model.imageData = imageData;
            model.messageDate = @"2017-6-28";
            model.currentState = IMContactLineStateOnLine;
            [weakseslf.IMListData addObject:model];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakseslf.IMContactListView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[weakseslf.IMListData count]-1 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
                [weakseslf.IMContactListView setContentOffset:CGPointMake(0, weakseslf.IMContactListView.contentSize.height+LCDW/2.0-70 - weakseslf.IMContactListView.height) animated:NO];
            });
        }];
        //视频
        [_tabBarView didSendVedio:^(NSString *vedioPath, NSURL *vedioURL) {
            IMContactMessageModel *model = [[IMContactMessageModel alloc] init];
            model.userId = @"2";
            model.userName = @"测试用户用例";
            model.userHeaderImagePath = @"";
            model.userRole = IMContactUserRoleReceiver;
            model.messageType = IMContactMessageTypeVedio;
            model.vedioUrlPath = vedioPath;
            model.messageDate = @"2017-6-28";
            model.currentState = IMContactLineStateOnLine;
            [weakseslf.IMListData addObject:model];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakseslf.IMContactListView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:[weakseslf.IMListData count]-1 inSection:0]] withRowAnimation:(UITableViewRowAnimationFade)];
                [weakseslf.IMContactListView setContentOffset:CGPointMake(0, weakseslf.IMContactListView.contentSize.height+LCDW/2.0-70 - weakseslf.IMContactListView.height) animated:NO];
            });
        }];
    
        [_tabBarView didSendRemoteRequest:^(BOOL flag) {
            
        }];
    [_tabBarView didChangeFrame:^(CGRect frame) {
       
        CGRect IMListViewFrame = weakseslf.IMContactListView.frame;
        if(frame.origin.y < LCDH-50)
        {
            IMListViewFrame.size.height = LCDH-74 - frame.size.height;
        }else{
            IMListViewFrame.size.height = LCDH-74 - 50;
        }
        
        weakseslf.IMContactListView.frame =IMListViewFrame;
        [weakseslf.IMContactListView setContentOffset:CGPointMake(weakseslf.IMContactListView.contentOffset.x, weakseslf.IMContactListView.contentSize.height-IMListViewFrame.size.height)];
    }];
            
   
    [self.view addSubview:_tabBarView];
}




-(void)addIMListView
{
    if(!_IMContactListView)
    {
        _IMContactListView = [[UITableView alloc] initWithFrame:CGRectMake(10, 74, LCDW-20, LCDH-74-50)];
        _IMContactListView.backgroundColor = [UIColor whiteColor];
        _IMContactListView.delegate = self;
        _IMContactListView.dataSource = self;
        _IMContactListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_IMContactListView setTableFooterView:[[UIView alloc] init]];
        [self.view addSubview:_IMContactListView];
        
        [_IMContactListView registerClass:[IMTextTableViewCell class] forCellReuseIdentifier:type_text];
        [_IMContactListView registerClass:[IMImageTableViewCell class] forCellReuseIdentifier:type_image];
        [_IMContactListView registerClass:[IMVoiceTableViewCell class] forCellReuseIdentifier:type_voice];
        [_IMContactListView registerClass:[IMVedioTableViewCell class] forCellReuseIdentifier:type_vedio];
        [_IMContactListView registerClass:[IMSymbolTableViewCell class] forCellReuseIdentifier:type_symbol];
    }
}


#pragma mark - IMListView delegate and dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_IMListData count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    IMContactMessageModel *model = [_IMListData objectAtIndex:indexPath.row];
    switch (model.messageType) {
        case IMContactMessageTypeEmotion:
        case IMContactMessageTypeText:
        {
            CGSize size =  [Tool getHeightWithMessage:model.messageContent size:CGSizeMake(LCDW-20-140, 100000) font:[UIFont systemFontOfSize:15]];
            if(size.height<30) return 60;
            else return size.height+30;
        }
            break;
        case IMContactMessageTypeImage:
        {
           
            return LCDW/2.0-70;
            
        }
            break;
        case IMContactMessageTypeVoice:
        {
            
            return 60;
            
        }
            break;
        case IMContactMessageTypeVedio:
        {
            
            return LCDW/2.0-70;
            
        }
            break;
            default:
        break;
    
    }
            return 64;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakself = self;
    IMContactMessageModel *model = [_IMListData objectAtIndex:indexPath.row];
    NSLog(@"messageType:%ld",model.messageType);
    
    switch (model.messageType) {
        case IMContactMessageTypeEmotion:
        case IMContactMessageTypeText:
        {
            IMTextTableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:type_text forIndexPath:indexPath];
            [textCell updateMessage:model headerBlock:^(NSString *userId) {
                NSLog(@"userId");
                 [weakself showExpertIntrduceWithRole:model];
            }];
            return textCell;
        }
            break;
        case IMContactMessageTypeImage:
        {
            IMImageTableViewCell *imageCell = [tableView dequeueReusableCellWithIdentifier:type_image forIndexPath:indexPath];
            [imageCell updateMessage:model imageBlock:^(NSString *imagePath) {
                NSLog(@"图片点击回调");
            } headerBlock:^(NSString *userId) {
                 NSLog(@"头像点击回调");
                [weakself showExpertIntrduceWithRole:model];
            }];
            return imageCell;
        }
            break;
        case IMContactMessageTypeVoice:
        {
            IMVoiceTableViewCell *voiceCell = [tableView dequeueReusableCellWithIdentifier:type_voice forIndexPath:indexPath];
            [voiceCell updateMessage:model voiceBlock:^(BOOL isPlay) {
                 NSLog(@"语音播放点击回调");
               if(weakself.voiceItemPlayerCell)
               {
                   [weakself.voiceItemPlayerCell stopPlayVoice];
               }
                weakself.voiceItemPlayerCell = voiceCell;
                [[IMPlayerMediaManager shareInstance] stopPlay];
                [[IMPlayerMediaManager shareInstance] startPlayAudioWithPath:model.voiceUrlPath];
                
            } headerBlock:^(NSString *userId) {
                NSLog(@"头像点击回调");
                 [weakself showExpertIntrduceWithRole:model];
            }];
            
            return voiceCell;
        }
            break;
        case IMContactMessageTypeVedio:
        {
            IMVedioTableViewCell *vedioCell = [tableView dequeueReusableCellWithIdentifier:type_vedio forIndexPath:indexPath];
            [vedioCell updateMessage:model completeBlock:^(NSString *vedioUrl) {
                NSLog(@"视频播放点击回调");
                 [weakself showMPMoviePlayerWithURLPath:model.vedioUrlPath];
            } headerBlock:^(NSString *userId) {
                NSLog(@"头像点击回调");
                 [weakself showExpertIntrduceWithRole:model];
            }];
            return vedioCell;
        }
            break;
        case IMContactMessageTypePromptInformation:
        case IMContactMessageTypeRomote:
        {
            IMSymbolTableViewCell *symCell = [tableView dequeueReusableCellWithIdentifier:type_symbol forIndexPath:indexPath];
            [symCell updateMessage:model];
            return symCell;
        }
            break;
        
        default:
            break;
    }
    
    
    
    return nil;
}


-(void)showExpertIntrduceWithRole:(IMContactMessageModel *)model
{
    
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击消息ITEM");
//    [self showMPMoviePlayerWithURLPath:@" "];
}





-(void)showMPMoviePlayerWithURLPath:(NSString *)URLPath
{
    if(!_moviePlayer)
    {
        _moviePlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:URLPath]];
        _moviePlayer.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
        _moviePlayer.moviePlayer.shouldAutoplay = YES;
        _moviePlayer.moviePlayer.scalingMode=MPMovieScalingModeAspectFit;
        [_moviePlayer.moviePlayer prepareToPlay];
        [_moviePlayer.moviePlayer play];
        [self presentMoviePlayerViewControllerAnimated:_moviePlayer];
        
    }
}


-(void)moviePlayerDidfinished:(NSNotification *)notification
{
    [_moviePlayer dismissMoviePlayerViewControllerAnimated];
    _moviePlayer = nil;
}


-(void)moviePlayerStateDidChange:(NSNotification *)notification
{
    NSLog(@"状态变化");
}


@end
