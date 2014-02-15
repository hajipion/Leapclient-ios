//
//  ViewController.m
//  neopa_app2
//
//  Created by Yoko on 2014/01/30.
//  Copyright (c) 2014年 y. All rights reserved.
//

#import "ViewController.h"



// 再生したいソース内にて下記をインポートします。
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController (){
@public AVAudioPlayer *audio;
    
}
@end

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"完了"
                                                    message:@"SmartWalkを起動しました。歩きスマホをご堪能ください！"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"閉じる", nil];
    alert.delegate       = self;
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
    
    // ナビゲーションバーの色
    self.navigationController.navigationBar.tintColor =
    [UIColor colorWithRed:191/255.0 green:255/255.0 blue:207/255.0 alpha:1];
    
    // ナビゲーションバーのタイトル
    self.navigationItem.title = @"SmartWalk";
    
    //緯度経度
    lm = [[CLLocationManager alloc] init];
    lm.delegate = self;
    // 取得精度の指定
    lm.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    // 取得頻度（指定したメートル移動したら再取得する）
    lm.distanceFilter = 1;    // 1m移動するごとに取得
    //位置検出開始
    [lm startUpdatingLocation];
    
   
    
    
    // ▼アニメーション▼
    /* 予備…
    NSArray *imagesArray = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"sw1.png"],
                           [UIImage imageNamed:@"sw2.png"],
                           [UIImage imageNamed:@"sw3.png"],
                           [UIImage imageNamed:@"sw4.png"],
                           nil];
    */
    NSMutableArray *imagesArray = [NSMutableArray arrayWithObjects:nil];
    
    // 配列に要素を挿入する
    for (int i = 1; i < 19; i++) {
        NSString *source = [NSString stringWithFormat:@"sw%i.png",i];
        [imagesArray insertObject:source atIndex:i];
    }
    self.smartWalker.animationImages = imagesArray;
    self.smartWalker.animationDuration = 0.5;
    self.smartWalker.animationRepeatCount = 0;
    [self.smartWalker startAnimating];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // 1秒ごとに更新処理を呼ぶ
    [[NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(changeLabel) userInfo:nil repeats:YES] fire];
}

- (void)changeLabel
{
    int x;
    x++;
    if (x % 2 == 1) {
        self.statusLabel.text = @"歩きスマホ中…";
    } else {
        self.statusLabel.text = @"歩きスマホ中　";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//websocketの送信
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    
  
    //[webSocket send:@"{192.168.151.134}"];
}

//websocketの受信
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@"%@", [message description]);
    
    
    //NSString *json = @"{\"relativePosition\":\"fkm\"}";
    NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingAllowFragments error:&error];
    if (error != nil) {
        NSLog(@"failed to parse Json ");
        return;
    }
    NSLog(@"json_relativePosition = %@", dic[@"relativePosition"]);
    NSString *str = dic[@"relativePosition"];
    
    // 文字列をNSIntegerに変換
    int i = str.intValue;
    
    [self myMethod:i];

    
    
    
    
}


/* 実装部 */
- (void)myMethod:(int)i
{
    // 処理
    NSLog(@"check %d",i);
    
   
   //int up = 0x01;
   //int down = 0x02;
   int left = 0x04;
   int right = 0x08;
    
    if(i&(left!=0)){
        NSLog(@"LEFT");
        
        NSString *path=[[NSBundle mainBundle]pathForResource:@"hidari" ofType:@"mp4"];
        NSURL *url =[NSURL fileURLWithPath:path];
        
        audio =[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        audio.volume=0.4;
        audio.numberOfLoops=1;
        [audio prepareToPlay];
        [audio play];
    }
    
    if(i&(right!=0)){
        NSLog(@"right");
    }
    
    
}



- (IBAction)Play:(id)sender {
    
 
}


- (void)startLocation {
    [lm startUpdatingLocation];
}

- (void)stopLocation {
    [lm stopUpdatingLocation];
}

// 現在地取得したら
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = newLocation.coordinate.latitude;
    coordinate.longitude = newLocation.coordinate.longitude;
    
    
    NSLog(@"位置取得%lf",coordinate.longitude);
    

    // この緯度経度で何かやる・・・
}

// 現在地取得に失敗したら
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [lm stopUpdatingLocation];
}


/**
 * アラート上のボタンがクリックされた時に発生します。
 *
 * @param alertView   アラート。
 * @param buttonIndex クリックされたボタンのインデックス。
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"start_scoket");
    
    
    //userdefault
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* string = [defaults stringForKey:@"token"];
    NSLog(@"token = %@", string);
    //
    
    
    
    
   /* NSURL *url = [NSURL URLWithString:@"ws://192.168.151.134:8080/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"ws://192.168.151.134:8080/" forHTTPHeaderField:@"Referer"];
    socket = [[SRWebSocket alloc] initWithURLRequest:[NSMutableURLRequest requestWithURL:request]];
    socket.delegate = self;
    [socket open];*/
    
    NSURL *jsonURL =[NSURL URLWithString:@"ws://192.168.151.134:8080/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:jsonURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
    [request setValue:@"Basic ...." forHTTPHeaderField:@"Authorization"];
    NSURLResponse *response;
    NSError * error  = nil;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    
    //websocketを開く
   SRWebSocket *web_socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://192.168.151.134:8080/"]]];
    
    [web_socket setDelegate:self];
    [web_socket open];
    
    NSString *path=[[NSBundle mainBundle]pathForResource:@"migi" ofType:@"mp4"];
    NSURL *url2 =[NSURL fileURLWithPath:path];
    
    audio =[[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:nil];
    audio.volume=0.4;
    audio.numberOfLoops=5;
    [audio prepareToPlay];
    [audio play];
    
    
    

}
@end
