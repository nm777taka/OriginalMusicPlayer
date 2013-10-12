//
//  PlayerViewController.m
//  HelloMusicPlayer
//
//  Created by 古田 貴久 on 2013/09/30.
//  Copyright (c) 2013年 古田 貴久. All rights reserved.
//

#import "PlayerViewController.h"
#import "LEColorPicker.h"
@interface PlayerViewController (){
    BOOL stopFlag;
    MPMusicPlayerController* myPlayer;
    MPMediaItem* nowPlayingItem;
    NSTimeInterval currentPlaybackTime;
}

@end

@implementation PlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark ViewCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //button
    UIButton* playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(150, 490, 30, 30);
    [playBtn addTarget:self action:@selector(playControl:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage* stateNomalImg = [UIImage imageNamed:@"playButton.png"];
    UIImage* stateSelectedImg = [UIImage imageNamed:@"stopBtn.png"];
    
    [playBtn setImage:stateNomalImg forState:UIControlStateNormal];
    [playBtn setImage:stateSelectedImg forState:UIControlStateSelected];
    [self.view addSubview:playBtn];
    
    //アートワークを表示
    MPMediaPropertyPredicate* albumArt = [MPMediaPropertyPredicate predicateWithValue:self.albumTitle forProperty:MPMediaItemPropertyAlbumTitle];
    MPMediaQuery* artQuery = [[MPMediaQuery alloc]init];
    [artQuery addFilterPredicate:albumArt];
    
    NSArray* result = [artQuery items];
    MPMediaItem* songItem = result[0];
    
    MPMediaItemArtwork* songArtwork = [songItem valueForProperty:MPMediaItemPropertyArtwork];
    UIImage* artWorkImage = [songArtwork imageWithSize:self.artWork.bounds.size];
    if (artWorkImage) {
        self.artWork.image = artWorkImage;
    }
    
    //アートワーク解析→バックの色を変更
    LEColorPicker* colorPicker = [[LEColorPicker alloc]init];
    LEColorScheme* colorScheme = [colorPicker colorSchemeFromImage:artWorkImage];
    self.view.backgroundColor = colorScheme.backgroundColor;
    
    self.songTitleLabel.text = self.songTitle;
    self.detailLabel.text = self.albumTitle;
    
    //プレイヤーを初期化
    myPlayer = [MPMusicPlayerController applicationMusicPlayer];
    MPMediaQuery* requestQuery = [[MPMediaQuery alloc]init];
    [requestQuery addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:self.songTitle forProperty:MPMediaItemPropertyTitle]];
    
    [myPlayer setQueueWithQuery:requestQuery];

    //画面遷移完了時に再生を開始
    stopFlag = NO;
    playBtn.selected = YES;
    [myPlayer play];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playControl:(UIButton*)btn{
    
    if (btn.selected) {
        btn.selected = NO;
        stopFlag = YES;
        [self savePlayLog];
        [myPlayer stop];

    }else{
        btn.selected = YES;
        stopFlag = NO;
        
        myPlayer.nowPlayingItem = nowPlayingItem;
        myPlayer.currentPlaybackTime = currentPlaybackTime;
        [myPlayer play];
    }
}

- (void)savePlayLog{
    
    //再生アイテムと演奏時間を記憶
    nowPlayingItem = myPlayer.nowPlayingItem;
    currentPlaybackTime = myPlayer.currentPlaybackTime;
}

@end
