//
//  ViewController.m
//  HelloMusicPlayer
//
//  Created by 古田 貴久 on 2013/09/26.
//  Copyright (c) 2013年 古田 貴久. All rights reserved.
//

#import "MPMainViewController.h"
#import "MPArtistListViewController.h"
#import "MPNowPlayingAlbumViewController.h"
#import "LEColorPicker.h"
#import <QuartzCore/QuartzCore.h>


@interface MPMainViewController ()

@property MPMusicPlayerController* player;

@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *playOrStopBtn;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;
@property (weak, nonatomic) IBOutlet UIImageView *albumColorImageVIew;

- (IBAction)pushedPlayOrStopButton:(id)sender;
- (IBAction)pushedNextButton:(id)sender;
- (IBAction)pushedPrevButton:(id)sender;
- (IBAction)pushedMoreButton:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *musicSlider;
@property (weak, nonatomic) IBOutlet UITableView *songDetailTable;

@property NSNotificationCenter *nCenter;
@property NSTimer* timer;

@property BOOL isPlaying;
@property BOOL isChangePlayBtnBg;

@property NSString* selectedSongTitle;
@property NSMutableArray* songDataArray;
@property UIColor* primaryColor;

@end

static  NSString* const nSongDetail = @"detail";
static  NSString* const nChangeKey = @"changed";
static  NSString* const nAlbumDetail = @"albumdata";

@implementation MPMainViewController

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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setSelectedTitle:) name:nSongDetail object:nil];
    
    [self.musicSlider addTarget:self action:@selector(slider_ValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    MPMediaItem* nowPlayingItem = [self.player nowPlayingItem];
    NSString* songTitle = [nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    NSString* artistName = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
    self.songTitleLabel.text = songTitle;
    self.artistNameLabel.text = artistName;
    self.isPlaying = NO;
    
    //tableviwe用配列の初期化
    self.songDataArray = [NSMutableArray new];
    self.songDetailTable.delegate = self;
    self.songDetailTable.dataSource = self;
    self.songDetailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewWillAppear:(BOOL)animated{
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
//    NSDictionary* albumInfo = @{@"name": self.selectAlbumTitile};
//    [[NSNotificationCenter defaultCenter]postNotificationName:nAlbumDetail object:self userInfo:albumInfo];
    
    [self.songDataArray removeAllObjects];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"didDisappear");
}

- (void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"didApper");
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
- (UIImage *)clipImage:(UIImage *)original resize:(CGSize)resize
{
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

- (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0, 0, self.artworkImageView.frame.size.width, self.artworkImageView.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage* image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Notification Handler

- (void)handle_NowPlayingItemChanged
{
    NSLog(@"NowPlayingItemChanged");
    
    MPMediaItem *nowPlayingItem = [self.player nowPlayingItem];
    NSString *artist = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtist];
    NSString *title = [nowPlayingItem valueForProperty:MPMediaItemPropertyTitle];
    NSString* albumTitile = [nowPlayingItem valueForProperty:MPMediaItemPropertyAlbumTitle];
    
    self.songTitleLabel.text = title;
    self.artistNameLabel.text = artist;
    
    if (albumTitile) {
        [self setSongDataToArray:albumTitile];
    }
    
    MPMediaItemArtwork *artwork = [nowPlayingItem valueForProperty:MPMediaItemPropertyArtwork];
    
    UIImage *resizedImage = [self clipImage:[artwork imageWithSize:CGSizeMake(600, 600)] resize:self.artworkImageView.frame.size];
    
    [self.artworkImageView setImage:resizedImage];
    
    //iTunescolor処理
    LEColorPicker* colorPicker = [[LEColorPicker alloc]init];
    LEColorScheme* colorScheme = [colorPicker colorSchemeFromImage:resizedImage];
    
    self.primaryColor = colorScheme.primaryTextColor;
    
    self.albumColorImageVIew.image = [self imageWithColor:[UIColor blackColor]];
    
    self.albumColorImageVIew.alpha = 0.2;
    
    self.songTitleLabel.textColor = colorScheme.primaryTextColor;
    self.artistNameLabel.textColor = colorScheme.secondaryTextColor;
    self.songDetailTable.backgroundColor = colorScheme.backgroundColor;
    self.navigationController.navigationBar.barTintColor = colorScheme.backgroundColor;
    self.navigationController.navigationBar.tintColor = colorScheme.primaryTextColor;
    
    //the total duration of the track...
    
    long totalPlaybackTime = [[[self.player nowPlayingItem]valueForProperty:@"playbackDuration"]longValue];
    int hours = (int)(totalPlaybackTime / 3600);
    int min = (int)((totalPlaybackTime/60) - hours*60);
    int sec = (totalPlaybackTime % 60);
    
    NSLog(@"%i:%02d:%02d",hours,min,sec);
    
    self.musicSlider.minimumValue = 0;
    self.musicSlider.maximumValue = [[[self.player nowPlayingItem]valueForProperty:@"playbackDuration"]longValue];
    
}

- (void)handle_VolumeChanged
{
    NSLog(@"VolumeChanged");
}

#pragma makr - TimerMethod

- (void)onTimer:(NSTimer *)timer
{
    
    self.musicSlider.value = [self.player currentPlaybackTime];
    
    long currentPlaybackTime = self.player.currentPlaybackTime;
    int min = currentPlaybackTime/60;
    int sec = currentPlaybackTime - (min*60);
    NSLog(@"%02d:%02d",min,sec);
    
}

- (void)setSelectedTitle:(NSNotification *)notification
{
    
    NSDictionary* userInfo = [notification userInfo];
    
    self.selectedSongTitle = userInfo[@"name"];
    self.selectAlbumTitile = userInfo[@"album"];
    [self playSelectedMusic];
    
}

#pragma mark - MusicControl

- (void)handle_PlaybackStateChanged
{
    NSLog(@"PlaybackStateChanged");
    
    if (self.isPlaying) {
        NSLog(@"playing");
        [self.playOrStopBtn setBackgroundImage:[UIImage imageNamed:@"MainView_stopBtn.png"] forState:UIControlStateNormal];
        self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
    } else {
        NSLog(@"stop");
        [self.playOrStopBtn setBackgroundImage:[UIImage imageNamed:@"MainView_playBtn.png"] forState:UIControlStateNormal];
        [self.timer invalidate];
    }
}


- (void)pushedNextButton
{
    [self.player skipToNextItem];
}

- (void)pushedPlayOrStopButton
{
    }


- (void)pushedPrevButton
{
    [self.player skipToPreviousItem];
}

- (void)playSelectedMusic
{
    //初期化
    MPMusicPlayerController* player = [MPMusicPlayerController iPodMusicPlayer];
    self.player =player;
    MPMediaQuery* requestQuery = [[MPMediaQuery alloc]init];
    [requestQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:self.selectedSongTitle forProperty:MPMediaItemPropertyTitle]];
    [self.player setQueueWithQuery:requestQuery];
    
    [self.timer invalidate];
    self.isPlaying = YES;
    [self.player play];
    [self handle_PlaybackStateChanged];
}


- (void)showNowPlayingAlbum
{
    NSLog(@"tap");
}

#pragma makr - Slider_Method

- (void)slider_ValueChanged:(id)sender
{
    
    UISlider* slider = sender;
    [self.player setCurrentPlaybackTime:[slider value]];
}

#pragma mark - Action


- (IBAction)pushedPlayOrStopButton:(id)sender
{
    
    if (self.isPlaying == NO) {
        [self.player play];
        self.isPlaying = YES;
        [self handle_PlaybackStateChanged];
    } else {
        [self.player pause];
        self.isPlaying = NO;
        [self handle_PlaybackStateChanged];
    }

}

- (IBAction)pushedNextButton:(id)sender
{
    
}

- (IBAction)pushedPrevButton:(id)sender
{
    
}

- (IBAction)pushedMoreButton:(id)sender
{
    MPArtistListViewController* secondView = [[MPArtistListViewController alloc]init];
    [self.navigationController pushViewController:secondView animated:YES];

}

#pragma  mark - tagbleviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.songDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text =self.songDataArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)setSongDataToArray:(NSString *)albumTitile
{
    MPMediaQuery* query = [[MPMediaQuery alloc]init];
    [query addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:albumTitile forProperty:MPMediaItemPropertyAlbumTitle]];
    NSArray* resultArray = [query items];
    
    for (MPMediaItem* song in resultArray) {
        NSString* songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
        [self.songDataArray addObject:songTitle];
    }
    
    [self.songDetailTable reloadData];
}

@end
