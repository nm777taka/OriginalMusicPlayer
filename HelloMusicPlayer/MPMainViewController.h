//
//  ViewController.h
//  HelloMusicPlayer
//
//  Created by 古田 貴久 on 2013/09/26.
//  Copyright (c) 2013年 古田 貴久. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MPAlbumSongViewController.h"


@interface MPMainViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)NSString* selectTitle;


@end

