kFacebook
=========

First Create Facebook App ID https://developers.facebook.com
You will get FacebookKeyID

You have to put in info.plist file.
1)URL Types->Item 0-> URL Schemes -> Item 0-> YourFacebookKey(with fb keyword)

2)FacebookAppID-> YourFacebookKey


Then Put Below Methods in AppDelgate.m file

        - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{

                         return [FBSession.activeSession handleOpenURL:url];
        }

        - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
   
                return YES;
        
        }


After That use KFacebook classses in your Project.


Facebook all methods are integratedlogin,logout,Fetch Friends list,Post Text and Image on FBWallPost Text and image to FB’ Friends’s wall,Twitter Login,Fetch Twitter friends's List

====================================================================================================
/*--------------Facebook Login-----------------------------*/



[kFacebook FacebookLogin:^(NSDictionary *dictonary, BOOL success) {

        if (success) {
        
            NSLog(@"SuccessfullyLogin");
        }else
            NSLog(@"Login Fail");
}]; 
    
====================================================================================================
/*----------------------Post Text and Image on Facebook Wall-------------------------*/

[kFacebook FacebookPost_Text:@"This is kfacebook Test" image:[UIImage imageNamed:@"22.jpg"] :^(BOOL success) {

        if (success) {
        
            NSLog(@"Successfully posted");
        }else
        
            NSLog(@"Fail");
 }];
    
====================================================================================================
/*---------------------------Get Friends list of Facebook-------------------------*/

  [kFacebook FacebookGetFriendsList:^(NSDictionary *dictonary, BOOL success) {

        if (success) {
        
            NSArray *arryData=[dictonary valueForKey:@"data"];
            NSLog(@"Friends list Count   =======  %lu",(unsigned long)arryData.count);
            
        }else
        
            NSLog(@"Fail");
  }];
  
====================================================================================================
/*-----------------------------Post Text and Image to Friend's wall--------------------*/

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
/*--------------------------------------Post Text on Facebook Page--------------------------*/

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
    
/*-------------------------------Facebook Logout-----------------------*/

        [kFacebook FacebookLogOut:^(BOOL success) {
  
         NSLog(@"Successfully Logout.");
         }];

====================================================================================================
/*-------------------------------Twitter Login-----------------------*/ 

/* 

        0  =  Last Twitter Account from Setting

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
   
====================================================================================================    
/*-----------------------------Fetch Friend list of Twitter-------------------*/


[kFacebook TwitterGetFriendslist_WithAccountIndex:0  :^(NSArray *arrayFriendsList, BOOL success) {
       
        if (success) {
        
            NSLog(@"Successfully Login");
            NSLog(@"%@",arrayFriendsList);
            
        }else
        
            NSLog(@"Fail");
            
 }];
  
