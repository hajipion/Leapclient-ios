//
//  ViewController.h
//  neopa_app2
//
//  Created by Yoko on 2014/01/30.
//  Copyright (c) 2014年 y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SRWebSocket.h"
@interface ViewController : UIViewController <SRWebSocketDelegate> {

    AVPlayer *avPlayer;
    SRWebSocket *socket;
    IBOutlet UITextField *hostTextField;
}
@property (nonatomic, retain) AVPlayer *avPlayer;
- (IBAction)Play:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *smartWalker;

@end
