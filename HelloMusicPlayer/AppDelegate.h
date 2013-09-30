//
//  AppDelegate.h
//  HelloMusicPlayer
//
//  Created by 古田 貴久 on 2013/09/26.
//  Copyright (c) 2013年 古田 貴久. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    UINavigationController* naviController;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong,nonatomic) ViewController* viewController;

@end
