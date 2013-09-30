//
//  PlayerViewController.h
//  HelloMusicPlayer
//
//  Created by 古田 貴久 on 2013/09/30.
//  Copyright (c) 2013年 古田 貴久. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface PlayerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *artWork;

@property (weak, nonatomic) IBOutlet UILabel *songTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic,retain) NSString* songTitle;
@property (nonatomic,retain) NSString* albumTitle;


@end
