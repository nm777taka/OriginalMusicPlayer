//
//  AlbumViewController.m
//  HelloMusicPlayer
//
//  Created by 古田 貴久 on 2013/09/28.
//  Copyright (c) 2013年 古田 貴久. All rights reserved.
//

#import "ArtistListViewController.h"
#import "AlbumViewController.h"

@interface ArtistListViewController ()

@property UITableView* artistTable;
@property NSMutableArray* artistArray;

@property UINavigationController* navi;

@end

@implementation ArtistListViewController


#pragma mark ViewCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.artistTable = [[UITableView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.artistTable];
    self.artistTable.delegate = self;
    self.artistTable.dataSource = self;
    self.artistTable.rowHeight = 80;
    self.artistArray = [NSMutableArray new];
    
    [self getArtistData];    

}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"アーティスト";

}


- (void)viewDidAppear:(BOOL)animated{
}

#pragma  mark MP-function

- (void)getArtistData{
    MPMediaQuery* query = [MPMediaQuery artistsQuery];
    NSArray* queryArray = [query collections];
    
    for(MPMediaItemCollection* artist in queryArray){
        MPMediaItem* representItem = [artist representativeItem];
        NSString* artistName = [representItem valueForProperty:MPMediaItemPropertyArtist];
        [self.artistArray addObject:artistName];
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
    return self.artistArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifer = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    
    cell.textLabel.text = self.artistArray[indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* didSelectPath = self.artistArray[indexPath.row];
    AlbumViewController* vc = [[AlbumViewController alloc]init];
    vc.artistName = didSelectPath;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
}
@end
