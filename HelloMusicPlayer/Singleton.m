//
//  Singleton.m
//  HelloMusicPlayer
//
//  Created by 古田 貴久 on 2013/09/29.
//  Copyright (c) 2013年 古田 貴久. All rights reserved.
//

#import "Singleton.h"

@implementation Singleton

@synthesize ArtistAlbumList;
@synthesize ArtistAlbumSongs;

static Singleton* sharedInstance = nil;

+ (Singleton*)sharedSingleton{
    @synchronized(self){
        if (sharedInstance == nil) {
            sharedInstance = [[Singleton alloc]init];
        }
    }
    return sharedInstance;
}

@end
