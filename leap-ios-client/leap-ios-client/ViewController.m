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
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    //[webSocket send:@"{192.168.151.134}"];
}

/*- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@"didReceiveMessage: %@", [message description]);
}*/

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
        
        NSString *path=[[NSBundle mainBundle]pathForResource:@"o-magne" ofType:@"mp3"];
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
    
    
  
   
    
    /* NSURL *url2 = [NSURL URLWithString:[NSString stringWithFormat:@"ws://%@:8080/",hostTextField.text]];
    socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:url2]];
    socket.delegate = self;
    [socket open];*/
    
    
   

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
    
    SRWebSocket *web_socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://192.168.151.134:8080/"]]];
    
    [web_socket setDelegate:self];
    [web_socket open];

}
@end
