//
//  ViewController.m
//  HelloMusicPlayer
//
//  Created by 古田 貴久 on 2013/09/26.
//  Copyright (c) 2013年 古田 貴久. All rights reserved.
//

#import "MainViewController.h"
#import "ArtistListViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface MainViewController ()

@property MPMusicPlayerController* player;

@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *playOrStopBtn;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
- (IBAction)pushedPlayOrStopButton:(id)sender;
- (IBAction)pushedNextButton:(id)sender;
- (IBAction)pushedPrevButton:(id)sender;
- (IBAction)pushedMoreButton:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *musicSlider;

@property NSNotificationCenter *nCenter;
@property NSTimer* timer;

@property BOOL isPlaying;
@property BOOL isChangePlayBtnBg;

@property NSString* selectedSongTitle;

@end

static  NSString* const songDetail = @"detail";
static  NSString* const changeKey = @"changed";

@implementation MainViewController

#pragma  mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //ミュージックプレイヤーをインスタンス化する
    self.player = [MPMusicPlayerController iPodMusicPlayer];
    
    [self setBGImage];
    
    //Notificationの設定
    self.nCenter = [NSNotificationCenter defaultCenter];
    [self.nCenter addObserver:self
                     selector:@selector(handle_NowPlayingItemChanged)
                         name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification
                       object:self.player];
    [self.nCenter addObserver:self
                     selector:@selector(handle_VolumeChanged)
                         name:MPMusicPlayerControllerVolumeDidChangeNotification
                       object:self.player];
    
    [self.player beginGeneratingPlaybackNotifications];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setSelectedTitle:) name:songDetail object:nil];
   // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handle_PlaybackStateChanged:) name:changeKey object:nil];
    
    [self.musicSlider addTarget:self action:@selector(slider_ValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    MPMediaItem* nowPlayingItem = [self.player nowPlayingItem];
    NSString* songTitle = [nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    NSString* artistName = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
    self.songTitleLabel.text = songTitle;
    self.artistNameLabel.text = artistName;
    
    self.isPlaying = NO;

}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewDidDisappear:(BOOL)animated{
}

- (void)viewDidAppear:(BOOL)animated{
}

- (void)setBGImage{
    if ([self.player nowPlayingItem]) {
        MPMediaItem* nowPlayingItem = [self.player nowPlayingItem];
        MPMediaItemArtwork* artImage = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtwork];
        UIImage* resizedImage = [self clipImage:[artImage imageWithSize:CGSizeMake(600, 600)] resize:self.artworkImageView.frame.size];
        self.artworkImageView.image = resizedImage;
        
    }

}

#pragma mark - UIImage
- (UIImage *)clipImage:(UIImage *)original resize:(CGSize)resize{
    //リサイズ画像のx,y,width,heightを算出
    float resized_x = 0.0;
    float resized_y = 0.0;
    float resized_width = resize.width;
    float resized_height = resize.height;
    float ratio_width = resize.width/original.size.width;
    float ratio_height = resize.height/original.size.height;
    
    //大きい方の倍率を採用
    if (ratio_width < ratio_height) {
        resized_width = original.size.width * ratio_height;
        resized_x = (resize.width - resized_width)/2;
    }else{
        resized_height = original.size.height * ratio_width;
        resized_y = (resize.height - resized_height)/2;
        
    }
    
    //リサイズとクリップ処理
    CGSize resized_size = CGSizeMake(resize.width, resize.height);
    UIGraphicsBeginImageContext(resized_size);
    //はみ出ている部分を切り落とす
    [original drawInRect:CGRectMake(resized_x, resized_y, resized_width, resized_height)];
    UIImage* resized_image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resized_image;
}

#pragma mark - Notification Handler

- (void)handle_NowPlayingItemChanged{
    NSLog(@"NowPlayingItemChanged");
    
    MPMediaItem *nowPlayingItem = [self.player nowPlayingItem];
    NSString *artist = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
    NSString *title = [nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    
    self.songTitleLabel.text = title;
    self.artistNameLabel.text = artist;
    
    MPMediaItemArtwork *artwork = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtwork];
    
    UIImage *resizedImage = [self clipImage:[artwork imageWithSize:CGSizeMake(600, 600)] resize:self.artworkImageView.frame.size];
    
    [self.artworkImageView setImage:resizedImage];
    
    //the total duration of the track...
    
    long totalPlaybackTime = [[[self.player nowPlayingItem]valueForProperty:@"playbackDuration"]longValue];
    int hours = (int)(totalPlaybackTime / 3600);
    int min = (int)((totalPlaybackTime/60) - hours*60);
    int sec = (totalPlaybackTime % 60);
    
    NSLog(@"%i:%02d:%02d",hours,min,sec);
    
    self.musicSlider.minimumValue = 0;
    self.musicSlider.maximumValue = [[[self.player nowPlayingItem]valueForProperty:@"playbackDuration"]longValue];

    
    
}

- (void)handle_VolumeChanged{
    NSLog(@"VolumeChanged");
}

#pragma makr - TimerMethod

- (void)onTimer:(NSTimer *)timer{
    
    self.musicSlider.value = [self.player currentPlaybackTime];
    
    long currentPlaybackTime = self.player.currentPlaybackTime;
    int min = currentPlaybackTime/60;
    int sec = currentPlaybackTime - (min*60);
    NSLog(@"%02d:%02d",min,sec);
    
}

- (void)setSelectedTitle:(NSNotification *)notification{
    
    NSDictionary* userInfo = [notification userInfo];
    
    self.selectedSongTitle = userInfo[@"name"];
    self.selectAlbumTitile = userInfo[@"album"];
    [self playSelectedMusic];
    
}

#pragma mark - MusicControl

- (void)handle_PlaybackStateChanged{
    NSLog(@"PlaybackStateChanged");
    
    if (self.isPlaying) {
        NSLog(@"playing");
        [self.playOrStopBtn setBackgroundImage:[UIImage imageNamed:@"MainView_stopBtn.png"] forState:UIControlStateNormal];
        self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    }else{
        NSLog(@"stop");
        [self.playOrStopBtn setBackgroundImage:[UIImage imageNamed:@"MainView_playBtn.png"] forState:UIControlStateNormal];
        [self.timer invalidate];
    }
}


- (void)pushedNextButton{
    [self.player skipToNextItem];
}

- (void)pushedPlayOrStopButton{
    }


- (void)pushedPrevButton{
    [self.player skipToPreviousItem];
}

- (void)playSelectedMusic{
    //初期化
    MPMusicPlayerController* player = [MPMusicPlayerController iPodMusicPlayer];
    self.player =player;
    MPMediaQuery* requestQuery = [[MPMediaQuery alloc]init];
    [requestQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:self.selectedSongTitle forProperty:MPMediaItemPropertyTitle]];
    [self.player setQueueWithQuery:requestQuery];
    
    [self pushedPlayOrStopButton:nil];
}


- (void)showNowPlayingAlbum{
    NSLog(@"tap");
}

#pragma makr - Slider_Method

- (void)slider_ValueChanged:(id)sender{
    
    UISlider* slider = sender;
    [self.player setCurrentPlaybackTime:[slider value]];
}

#pragma mark - Action


- (IBAction)pushedPlayOrStopButton:(id)sender {
    
    if (self.isPlaying == NO) {
        [self.player play];
        self.isPlaying = YES;
        [self handle_PlaybackStateChanged];
    }else{
        [self.player pause];
        self.isPlaying = NO;
        [self handle_PlaybackStateChanged];
    }

}

- (IBAction)pushedNextButton:(id)sender {
}

- (IBAction)pushedPrevButton:(id)sender {
}

- (IBAction)pushedMoreButton:(id)sender {
    ArtistListViewController* secondView = [[ArtistListViewController alloc]init];
    [self.navigationController pushViewController:secondView animated:YES];

}
@end
