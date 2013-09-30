//
//  ViewController.m
//  HelloMusicPlayer
//
//  Created by 古田 貴久 on 2013/09/26.
//  Copyright (c) 2013年 古田 貴久. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    Singleton* singleton;
    NSString* didSelectArtist;
}

@property NSMutableArray* artistList;

@property MPMusicPlayerController* player;

@property (nonatomic,retain)UITableView* tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#pragma mark もっとも簡単なミュージックプレイヤー
    
//    //ミュージックプレイヤーをインスタンス化する
//    MPMusicPlayerController *myPlayer = [MPMusicPlayerController applicationMusicPlayer];
//    
//    //デバイス上の全てのメディアアイテムを含む再生キューを割り当てる
//    [myPlayer setQueueWithQuery:[MPMediaQuery songsQuery]];
//    
//    //キューの先頭から再生を開始する
//    [myPlayer play];
    
#pragma mark メディアアイテムピッカーの表示
//    MPMediaPickerController *picker = [[MPMediaPickerController alloc]initWithMediaTypes:MPMediaTypeAnyAudio];
//    
//    [picker setDelegate:self];
//    [picker setAllowsPickingMultipleItems:YES];
//    picker.prompt = NSLocalizedString(@"Add songs to play", "Prompt in media item picker");
//    
//    [self presentViewController:picker animated:YES completion:nil];
    
#pragma mark メディアクエリの作成と使用
    //全ての曲を取得
//    MPMediaQuery* everything = [[MPMediaQuery alloc]init];
//    
//    NSLog(@"Logging items form a generic query...");
//    NSArray* itemsFromGenericQuery = [everything items];
//    for (MPMediaItem *song in itemsFromGenericQuery){
//        NSString* songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
//        NSLog(@"%@",songTitle);
//    }
//    
#pragma makr 特定のアーティストの曲を取得
//    
//    if ([MPMediaItem canFilterByProperty:MPMediaItemPropertyArtist]) {
//        MPMediaPropertyPredicate *artistNamePredicate =
//        [MPMediaPropertyPredicate predicateWithValue:@"μ's" forProperty:MPMediaItemPropertyArtist];
//        
//        MPMediaQuery *myArtistQuery = [[MPMediaQuery alloc]init];
//        [myArtistQuery addFilterPredicate:artistNamePredicate];
//        
//        NSArray* itemsFormArtistQuery = [myArtistQuery items];
//        
//        for(MPMediaItem *song in itemsFormArtistQuery){
//            NSString *title = [song valueForProperty:MPMediaItemPropertyTitle];
//            NSLog(@"%@",title);
//        }
//
//    }
    
#pragma mark 特定のアーティストの全ての曲を、アルバムごとに整理して取得
//    
//    NSLog(@"aaaaa");
//    
//    MPMediaQuery* query = [[MPMediaQuery alloc]init];
//    [query addFilterPredicate:[MPMediaPropertyPredicate predicateWithValue:@"水樹奈々" forProperty:MPMediaItemPropertyArtist]];
//    
//    //メディアクエリのグルーピングタイプを設定
//    [query setGroupingType:MPMediaGroupingAlbum];
//    
//    NSArray* albums = [query collections];
//    
//    for(MPMediaItemCollection *album in albums){
//        MPMediaItem* representativeItem = [album representativeItem];
//        NSString* artistName = [representativeItem valueForKey:MPMediaItemPropertyArtist];
//        NSString* albumName = [representativeItem valueForKey:MPMediaItemPropertyAlbumTitle];
//        NSLog(@"%@ by %@",albumName,artistName);
//        
//        NSArray* songs = [album items];
//        for(MPMediaItem *song in songs){
//            NSString* songTitle = [song valueForKey:MPMediaItemPropertyTitle];
//            
//            NSLog(@"\t\t%@",songTitle);
//        }
//    }
    
#pragma mark アートワークを取得、表示
//    
//    UIImageView* albumImage = [[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 200, 200)];
//    [self.view addSubview:albumImage];
//    
//    //メディアアイテムを取得
//    MPMediaPropertyPredicate* song = [MPMediaPropertyPredicate predicateWithValue:@"残光のガイア" forProperty:MPMediaItemPropertyTitle];
//    MPMediaQuery* artQuery = [[MPMediaQuery alloc]init];
//    [artQuery addFilterPredicate:song];
//    
//    NSArray* songs = [artQuery items];
//    
//    MPMediaItem* songItem = songs[0];
//    
//    MPMediaItemArtwork* songArtwork = [songItem valueForProperty:MPMediaItemPropertyArtwork];
//    
//    UIImage* artworkImage = [songArtwork imageWithSize:albumImage.bounds.size];
//    
//    if (artworkImage) {
//        albumImage.image = artworkImage;
//    }
    
#pragma mark TableViewを使った簡単なプレイヤー
    self.title = @"アーティスト";
    
    CGRect screenSize = [[UIScreen mainScreen]applicationFrame];//ステータスバーをnozoku
    self.tableView = [[UITableView alloc]initWithFrame:screenSize];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //配列の初期化
    self.artistList = [NSMutableArray new];
    [self getArtist];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MediaPickerDelegate

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    [self dismissViewControllerAnimated:YES completion:nil];
    //キューを更新
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.artistList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.artistList objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    didSelectArtist = self.artistList[indexPath.row];
    
    [self goToAlbumView];
}

- (void)getArtist{
    MPMediaQuery* everyArtist = [[MPMediaQuery alloc]init];
    
    [everyArtist setGroupingType:MPMediaGroupingArtist];
    NSArray* myCollections = [everyArtist collections];
    
    for(MPMediaItemCollection *artist in myCollections){
        MPMediaItem* representativeItem = [artist representativeItem];
        NSString* artistName = [representativeItem valueForProperty:MPMediaItemPropertyArtist];
        [self.artistList addObject:artistName];
    }
}

#pragma mark segue
- (void)goToAlbumView{
    AlbumViewController* vc = [[AlbumViewController alloc]init];
    vc.artistName = didSelectArtist;
    
    [self.navigationController pushViewController:vc
                                         animated:YES]; 
}

@end
