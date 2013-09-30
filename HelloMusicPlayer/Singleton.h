//
//  Singleton.h
//  HelloMusicPlayer
//
//  Created by 古田 貴久 on 2013/09/29.
//  Copyright (c) 2013年 古田 貴久. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject

@property (nonatomic,retain)NSMutableArray* ArtistAlbumList;
@property (nonatomic,retain)NSMutableArray* ArtistAlbumSongs;

+ (Singleton*)sharedSingleton;

@end
