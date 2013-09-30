//
//  AlbumSongViewController.h
//  HelloMusicPlayer
//
//  Created by 古田 貴久 on 2013/09/29.
//  Copyright (c) 2013年 古田 貴久. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface AlbumSongViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain) NSString* albumName;

@end
