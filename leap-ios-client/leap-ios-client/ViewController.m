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

NSString* string;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //userdefault
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    string = [defaults stringForKey:@"token"];
    NSLog(@"token = %@", string);
    //


    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"完了"
                                                    message:@"SmartWalkを起動しました。歩きスマホをご堪能ください！"
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"閉じる", nil];
    alert.delegate       = self;
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
    
    // ナビゲーションが埋もれるのをなおす
    float iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    //iOS 7.0以上の場合
    if(iOSVersion <= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    // ナビゲーションの高さ
    
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
    lm.distanceFilter = 0.1;    // 1m移動するごとに取得
    //位置検出開始
    [lm startUpdatingLocation];
    
    //ラベルを変えるためのカウント初期化！
    changeLabelCount = 0;
    
    // ▼アニメーション▼
    /* 予備…
    NSArray *imagesArray = [NSArray arrayWithObjects:
                           [UIImage imageNamed:@"sw1.png"],
                           [UIImage imageNamed:@"sw2.png"],
                           [UIImage imageNamed:@"sw3.png"],
                           [UIImage imageNamed:@"sw4.png"],
                           nil];
    */
    //NSMutableArray *imagesArray = [NSMutableArray arrayWithObjects:nil];
    UIImage* imagesArray[18];
    
    // 配列に要素を挿入する
    for (int i = 0; i < 18; i++) {
        UIImage *source = [UIImage imageNamed:[NSString stringWithFormat:@"sw%d.png",i+1] ];
        imagesArray[i] = source;
        //[imagesArray insertObject:source atIndex:i];
    }
    self.smartWalker.animationImages = [NSArray arrayWithObjects:imagesArray count:18];
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
    changeLabelCount = changeLabelCount + 1;
    if (changeLabelCount % 2 == 1) {
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

    NSString *path=[[NSBundle mainBundle]pathForResource:@"migi" ofType:@"mp4"];
    NSURL *url2 =[NSURL fileURLWithPath:path];
    
    audio =[[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:nil];
    audio.volume=0.4;
    audio.numberOfLoops=5;
    [audio prepareToPlay];
    [audio play];

    
    
    
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
    
    
    
    
    
    
    
    // 空のリストを生成する
    NSURL   *url = [NSURL URLWithString:@"http://192.168.151.134:9292/location"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    
    NSDictionary *person = @{
                             @"token" :string,
                             @"latitude" :@1,
                             @"longitude" : @1, // NSNumberで格納される
                            };
    
    NSError *error = nil;
    NSData  *content = [NSJSONSerialization dataWithJSONObject:person options:NSJSONWritingPrettyPrinted error:&error];
    [request setHTTPBody:content];
    NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
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
    
    
    
    
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"ws://192.168.151.134:8080/"] ] ;
    [request addValue:string forHTTPHeaderField:@"X-TOKEN"];
    
                             
    //websocketを開く
    SRWebSocket *web_socket = [[SRWebSocket alloc] initWithURLRequest:request];
    
    [web_socket setDelegate:self];
    [web_socket open];
    
    
    
    

}
@end
