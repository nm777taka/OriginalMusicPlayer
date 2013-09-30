//
//  AlbumViewController.h
//  HelloMusicPlayer
//
//  Created by 古田 貴久 on 2013/09/28.
//  Copyright (c) 2013年 古田 貴久. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Singleton.h"

@interface AlbumViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)NSString* artistName;

@end
