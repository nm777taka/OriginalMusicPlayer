//
//  AlbumSongViewController.m
//  HelloMusicPlayer
//
//  Created by 古田 貴久 on 2013/09/29.
//  Copyright (c) 2013年 古田 貴久. All rights reserved.
//

#import "MPAlbumSongViewController.h"

@interface MPAlbumSongViewController ()

@property (nonatomic,retain) NSMutableArray* songsList;

@property UITableView* songTable;

@property NSString* didSelectTitle;

@end

static NSString* const nSongDetail = @"detail";

@implementation MPAlbumSongViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark ViewCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"曲";
    self.songTable = [[UITableView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:self.songTable];
    self.songTable.delegate = self;
    self.songTable.dataSource = self;
    
    self.songsList = [NSMutableArray new];
    
    //選択したアルバムの曲を検索、表示
    MPMediaQuery* query = [[MPMediaQuery alloc]init];
    [query addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:self.albumName forProperty:MPMediaItemPropertyAlbumTitle]];
    NSArray* resultArray = [query items];
    
    for(MPMediaItem* song in resultArray){
        NSString* songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
        [self.songsList addObject:songTitle];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.songsList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdetifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdetifier];
    }
    
    cell.textLabel.text = self.songsList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.didSelectTitle = self.songsList[indexPath.row];
    
    NSDictionary* userInfo = @{@"name": self.didSelectTitle,@"album":self.albumName};
    [[NSNotificationCenter defaultCenter]postNotificationName:nSongDetail object:self userInfo:userInfo];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
