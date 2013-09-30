//
//  AlbumViewController.m
//  HelloMusicPlayer
//
//  Created by 古田 貴久 on 2013/09/28.
//  Copyright (c) 2013年 古田 貴久. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumSongViewController.h"

@interface AlbumViewController (){
    Singleton* singleton;
}

@property UITableView* albumTable;

@property NSMutableArray* albumArray;

@end

@implementation AlbumViewController

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
    self.title = @"アルバム";
    CGRect viewRect = [[UIScreen mainScreen]applicationFrame];
	self.albumTable = [[UITableView alloc]initWithFrame:viewRect];
    [self.view addSubview:self.albumTable];
    self.albumTable.delegate = self;
    self.albumTable.dataSource = self;
    
    self.albumArray = [NSMutableArray new];
    
    //選択したアーティストのアルバムを検索、表示
    MPMediaQuery* query = [[MPMediaQuery alloc]init];
    [query addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:self.artistName forProperty:MPMediaItemPropertyArtist]];
    [query setGroupingType:MPMediaGroupingAlbum];
    NSArray* resultArray = [query collections];
    
    for(MPMediaItemCollection *album in resultArray){
        MPMediaItem* representativeItem = [album representativeItem];
        NSString* albumName = [representativeItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        [self.albumArray addObject:albumName];
        
    }

    
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
    return self.albumArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifer = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    cell.textLabel.text = self.albumArray[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* didSelectPath = self.albumArray[indexPath.row];
    AlbumSongViewController* vc = [[AlbumSongViewController alloc]init];
    vc.albumName = didSelectPath;
    
    //segue
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
