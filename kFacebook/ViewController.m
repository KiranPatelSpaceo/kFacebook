//
//  ViewController.m
//  kFacebook
//
//  Created by macmini17 on 13/05/14.
//  Copyright (c) 2014 macmini17. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)FbLoginPressed:(id)sender {
    [kFacebook FacebookLogin:^(NSDictionary *dictonary, BOOL success) {
        if (success) {
            NSLog(@"SuccessfullyLogin");
        }else
            NSLog(@"Login Fail");
    }]; 
}
- (IBAction)btnPostTextImagePressed:(id)sender {
    
    [kFacebook FacebookPost_Text:@"This is kfacebook Test" image:[UIImage imageNamed:@"22.jpg"] :^(BOOL success) {
        if (success) {
            NSLog(@"Successfully posted");
        }else
            NSLog(@"Fail");
    }];
}
- (IBAction)btnGetFriendlistPressed:(id)sender {
    [kFacebook FacebookGetFriendsList:^(NSDictionary *dictonary, BOOL success) {
        if (success) {
            NSArray *arryData=[dictonary valueForKey:@"data"];
            NSLog(@"Friends list Count   =======  %lu",(unsigned long)arryData.count);
        }else
            NSLog(@"Fail");
    }];
}
- (IBAction)btnPostOnFriendWallPressed:(id)sender {
    
    NSMutableDictionary *parmaDic = [[NSMutableDictionary alloc]init];
    [parmaDic setObject:@"kFacebookTest" forKey:@"name"];
    [parmaDic setObject:@"yourfacebookfriendid" forKey:@"id"];//Pass facebook id of your friend.
    [parmaDic setObject:@"Build great social apps and get more installs." forKey:@"caption"];
    [parmaDic setObject:@"Please download App." forKey:@"description"];
    [parmaDic setObject:@"https://github.com/kiran5232/KDropDownMultipleSelection.git" forKey:@"link"];
    [parmaDic setObject:@"https://raw.github.com/fbsamples/ios-3.x-howtos/master/Images/iossdk_logo.png" forKey:@"picture"];
   [kFacebook FacebookPostOnFriendWall:parmaDic :^(BOOL success) {
       if (success) {
           NSLog(@"Successfully posted");
       }else
           NSLog(@"Fail");

   }];
}

- (IBAction)btnLogoutPressed:(id)sender {
    
   
    [kFacebook FacebookLogOut:^(BOOL success) {
         NSLog(@"Successfully Logout.");
    }];
}
- (IBAction)btnGetAlbumListPressed:(id)sender {
    [kFacebook FacebookAllAlbumsList:^(NSDictionary *dictonary, BOOL success) {
        if (success) {
            NSLog(@"%@",dictonary);
        }else
            NSLog(@"Fail");
    }];
}

- (IBAction)btnPostOnPagePressed:(id)sender {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"This is a kFacebookTest", @"message",
                            nil
                            ];
    NSString *strPageId=@"facebookpageid";//Change your Page Id;
    [kFacebook FacebookPostOnFacebookPage:params page_id:strPageId :^(NSDictionary *responce, BOOL success) {
        if (success) {
          //  NSLog(@"Responce ===== %@",responce);
            NSLog(@"Successfully posted");
        }else
            NSLog(@"Fail");
    }];
}
- (IBAction)btnSendRequestToFriend:(id)sender {
    NSArray *arryFriends=@[@"facebookFriend1_id",@"facebookFriend2_id"];//You can send to selected friends. you can pass also nil.
    [kFacebook FacebookSendRequestToFriends:nil Message:@"kFacebook Testing." :^(NSString *requestId, BOOL success) {
        if (success) {
              NSLog(@"RequestId ===== %@",requestId);
            NSLog(@"Successfully posted");
        }else
            NSLog(@"Fail");
    }];
}
- (IBAction)BtnTwitterLoginPressed:(id)sender {
    
    /*  0  =  Last Twitter Account from Setting
        1  =  First Twitter Account from Setting
        2 =  All Twitter Accounts from Setting
     */
    [kFacebook TwitterLogin_Whichone:1 :^(NSArray *TwitterData, BOOL success) {
        if (success) {
            NSLog(@"Successfully Login");
            NSLog(@"%@",TwitterData);
        }else
            NSLog(@"Fail");
    }];
}
- (IBAction)btnTwitterFriendList:(id)sender {
    
    
    [kFacebook TwitterGetFriendslist_WithAccountIndex:0  :^(NSArray *arrayFriendsList, BOOL success) {
       
        if (success) {
            NSLog(@"Successfully Login");
            NSLog(@"%@",arrayFriendsList);
        }else
            NSLog(@"Fail");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
