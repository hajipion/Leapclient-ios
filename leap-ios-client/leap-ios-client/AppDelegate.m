//
//  AppDelegate.m
//  leap-ios-client
//
//  Created by Yoko on 2014/02/15.
//  Copyright (c) 2014年 mariin. All rights reserved.
//

#import "AppDelegate.h"
#import "StringUtils.h"

#import <AudioToolbox/AudioToolbox.h>

@implementation AppDelegate{
    
    @public AVAudioPlayer *audio;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    // PUSH通知を登録
    /*[[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge|
      UIRemoteNotificationTypeSound|
      UIRemoteNotificationTypeAlert)];*/
    
    [application unregisterForRemoteNotifications];
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound|
     UIRemoteNotificationTypeNewsstandContentAvailability];
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    /*NSDictionary *userInfo
    = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo != nil) {
        NSLog(@"PUSH_COME__2");

    }*/

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



// デバイストークン発行成功
- (void)application:(UIApplication*)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)devToken{
   
    
  
    //NSUserDefaultsにすでにあるか
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic2 = [defaults2 persistentDomainForName:appDomain];
    
    //
    
    if(dic2!=nil){
        NSLog(@"defualts_aru:%@", dic2);
    }else{
        NSLog(@"nai");
        NSLog(@"deviceToken: %@", devToken);
        NSString *dat = [NSString stringWithFormat:@"%@", devToken];
        dat = [StringUtils replace:dat searchString:@" " replacement:@""];
        dat = [StringUtils replace:dat searchString:@"<" replacement:@""];
        dat = [StringUtils replace:dat searchString:@">" replacement:@""];
        
        NSLog(@"deviceToken: %@", dat);
        
        NSArray *array = @[dat];
        /*NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         [defaults setObject:array forKey:@"devicetoken"];*/
        
        
        
        NSString* url = @"http://smartwalk.hajipion.com/token";
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        // NSData *jsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error=nil;
        
        //NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingAllowFragments error:&error];
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:json_data
                                                                   options:NSJSONReadingAllowFragments error:&error];
        if (error != nil) {
            NSLog(@"failed to parse Json ");
            
        }
        //NSLog(@"json_relativePosition = %@", dic[@"token"]);
        NSString *str = dic[@"token"];
        
        NSLog(@"json_relativePosition = %@", str);
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        // NSStringの保存
        [defaults setObject:str forKey:@"token"];
        BOOL successful = [defaults synchronize];
        if (successful) {
            NSLog(@"%@", @"データの保存に成功しました。");
            
            //2回目のリクエスト
            // 空のリストを生成する
            NSURL   *url = [NSURL URLWithString:@"http://smartwalk.hajipion.com/register"];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPMethod:@"POST"];
            
            
            NSDictionary *second_req = @{
                                         @"token" :str,
                                         @"device_token" :dat,
                                         //@"longitude" : @1, // NSNumberで格納される
                                         };
            
            NSError *error = nil;
            NSData  *content = [NSJSONSerialization dataWithJSONObject:second_req options:NSJSONWritingPrettyPrinted error:&error];
            [request setValue:[NSString stringWithFormat:@"%u",(unsigned int)content.length] forHTTPHeaderField:@"Content-Length"];
            [request setHTTPBody:content];
            NSData *json_data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            
            
        }
        
        
       

        
        
    }
    
    
    
   
    // デバイストークンをサーバに送信し、登録する
}

// デバイストークン発行失敗
- (void)application:(UIApplication*)app didFailToRegisterForRemoteNotificationsWithError:(NSError*)err{
    NSLog(@"Errorinregistration.Error:%@",err);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"PUSH_COME");

    if (application.applicationState == UIApplicationStateActive)
    {
               // ここに処理
        
        NSLog(@"PUSH_COME");

       
    }else{
        NSLog(@"PUSH_COME");
    }
    
    

    
    NSLog(@"remote notification: %@",[userInfo description]);
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    
    NSString *alert = [apsInfo objectForKey:@"alert"];
    NSLog(@"Received Push Alert: %@", alert);
    
    NSString *sound = [apsInfo objectForKey:@"sound"];
    NSLog(@"Received Push Sound: %@", sound);
    if(sound!=nil){
        NSString *filename=[[sound lastPathComponent]stringByDeletingPathExtension];
        NSString *path=[[NSBundle mainBundle]pathForResource:filename ofType:@"mp4"];
        NSURL *url2 =[NSURL fileURLWithPath:path];
        
        audio =[[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:nil];
        audio.volume=1.0;
        audio.numberOfLoops=1;
        [audio prepareToPlay];
        [audio play];
    }
    
    

    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    NSString *badge = [apsInfo objectForKey:@"badge"];
    NSLog(@"Received Push Badge: %@", badge);
    application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
    
    
}






@end
