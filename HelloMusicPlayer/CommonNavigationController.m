//
//  CommonNavigationController.m
//  HelloMusicPlayer
//
//  Created by 古田 貴久 on 2013/10/18.
//  Copyright (c) 2013年 古田 貴久. All rights reserved.
//

#import "CommonNavigationController.h"

@interface CommonNavigationController ()

@end

@implementation CommonNavigationController


- (void)configureStatusBar
{
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configureStatusBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
