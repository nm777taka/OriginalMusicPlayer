//
//  NowPlayingAlbumViewController.h
//  HelloMusicPlayer
//
//  Created by 古田 貴久 on 2013/10/22.
//  Copyright (c) 2013年 古田 貴久. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPNowPlayingAlbumViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)UITableView *albumSongsTable;
@property (nonatomic,retain)NSString* albumTitle;



@end
