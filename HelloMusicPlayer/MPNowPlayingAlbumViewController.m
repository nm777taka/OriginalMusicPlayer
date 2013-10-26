//
//  NowPlayingAlbumViewController.m
//  HelloMusicPlayer
//
//  Created by 古田 貴久 on 2013/10/22.
//  Copyright (c) 2013年 古田 貴久. All rights reserved.
//

#import "MPNowPlayingAlbumViewController.h"

@interface MPNowPlayingAlbumViewController ()

@property NSMutableArray* dataArray;

@end

static NSString* const nBackViewController = @"backSlideView";

@implementation MPNowPlayingAlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray new];
    
    self.albumSongsTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.albumSongsTable];
    
    self.albumSongsTable.dataSource = self;
    
    NSLog(@"nowplyaing:%@",self.albumTitle);
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"nowplyaing:%@",self.albumTitle);

}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"nowplyaing:%@",self.albumTitle);

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}
@end
