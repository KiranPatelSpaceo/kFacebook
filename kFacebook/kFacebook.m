//
//  kFacebook.m
//  kFacebook
//
//  Created by macmini17 on 20/05/14.
//  Copyright (c) 2014 macmini17. All rights reserved.
//

#import "kFacebook.h"

@implementation kFacebook

#pragma mark -
#pragma mark - Facebook
#pragma mark -

//TODO: Login/Logout Method
+(void)FacebookLogin:(void (^)(NSDictionary *dictonary,BOOL success))completion{
    if ([SharedObj isNetworkReachable]) {
        
        void(^SendRequestBlock)(void)=^{
            [FBRequestConnection startWithGraphPath:@"me" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
             {
                 
                 if(!error)
                 {
                     
                     completion(result,YES);
                 }
                 else{
                     completion(nil,NO);
                     DisplayAlertWithTitle(error.description, @"kFacebook");
                 }
                 
             }];
        };
        if (FBSession.activeSession.isOpen) {
            // login is integrated
            SendRequestBlock();
        } else {
            
            [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                if (error) {
                    DisplayAlertWithTitle(error.description, @"kFacebook");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion)
                            completion(nil,NO);
                    });
                    
                } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                    SendRequestBlock();
                }
            }];
            
        }
    }
    else{
        completion(nil,NO);
        DisplayAlertWithTitle(@"No internet connection", @"kFacebook");
    }
}

+(void)FacebookLogOut:(void (^)(BOOL success))completion{
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    completion(YES);
}
//TODO: Post Method
+(void)FacebookPost_Text:(NSString*)text image:(UIImage*)image :(void (^)(BOOL success))completion{
    
    if ([SharedObj isNetworkReachable]) {
        void(^SendRequestPostText)(void)=^{
            FBRequest *postRequest = nil;
            
            if ([text length] && !image) {
                NSDictionary *parameters = [NSDictionary dictionaryWithObject:text forKey:@"message"];
                postRequest = [FBRequest requestWithGraphPath:@"me/feed"
                                                   parameters:parameters
                                                   HTTPMethod:@"POST"];
            }
            else if ([text length] && image) {
                NSData *imageData = UIImagePNGRepresentation(image);
                NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                            text, @"message",
                                            imageData, @"image.png",
                                            nil];
                postRequest = [FBRequest requestWithGraphPath:@"me/photos"
                                                   parameters:parameters
                                                   HTTPMethod:@"POST"];
            }
            
            [postRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (error)
                    DisplayAlertWithTitle(error.description, @"kFacebook");
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completion)
                        completion(error == nil);
                });
            }];
        };
        
        if (FBSession.activeSession.isOpen) {
            // login is integrated
            SendRequestPostText();
            
        } else {
            
            NSLog(@"%@",[[FBSession activeSession] permissions]);
            
            [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"publish_stream",@"publish_actions", nil] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                if (error) {
                    DisplayAlertWithTitle(error.description, @"kFacebook");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion)
                            completion(NO);
                    });
                } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                    // send our requests if we successfully logged in
                    SendRequestPostText();
                }
            }];
            
        }
        
    }else{
        completion(NO);
        DisplayAlertWithTitle(@"No internet connection", @"kFacebook");
    }
    
}




+(void)FacebookPostOnFriendWall:(NSDictionary*)parameters :(void(^)( BOOL success))completion{
    if ([SharedObj isNetworkReachable]) {
        void(^PostRequest)(void)=^{
            [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                   parameters:parameters
                                                      handler:
             ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                 if (error) {
                     // Error launching the dialog or publishing a story.
                     NSLog(@"Error publishing story.");
                 } else {
                     if (result == FBWebDialogResultDialogCompleted) {
                         if ([[resultURL description] hasPrefix:@"fbconnect://success?"]) {
                             completion(YES);
                         }
                         else
                             completion(NO);
                     }
                     else
                         completion(NO);
                 }
             }];
        };
        if (FBSession.activeSession.isOpen) {
            // login is integrated
            if ([[[FBSession activeSession] permissions]indexOfObject:@"publish_actions"] == NSNotFound) {
                
                [[FBSession activeSession] requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions,publish_stream"] defaultAudience:FBSessionDefaultAudienceFriends
                                                      completionHandler:^(FBSession *session,NSError *error){
                                                          if (error) {
                                                              completion(NO);
                                                          }else {
                                                              PostRequest();
                                                          }
                                                      }];
            }
            else
                PostRequest();
            
        } else {
            
            
            [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"publish_stream",@"publish_actions", nil] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                if (error) {
                    DisplayAlertWithTitle(error.description, @"kFacebook");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion)
                            completion(NO);
                    });
                } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                    // send our requests if we successfully logged in
                    PostRequest();
                }
            }];
            
        }
    }else{
        completion(NO);
        DisplayAlertWithTitle(@"No internet connection", @"kFacebook");
    }
}

+(void)FacebookPostOnFacebookPage:(NSDictionary*)parameters page_id:(NSString*)pageid :(void(^)(NSDictionary *responce ,BOOL success))completion{
    
    if ([SharedObj isNetworkReachable]) {
        void(^PostRequestPage)(void)=^{
            
            NSString *strPath=[NSString stringWithFormat:@"/%@/feed",pageid];
            [FBRequestConnection startWithGraphPath:strPath
                                         parameters:parameters
                                         HTTPMethod:@"POST"
                                  completionHandler:^(
                                                      FBRequestConnection *connection,
                                                      id result,
                                                      NSError *error
                                                      ) {
                                      if (error) {
                                          completion(nil,NO);
                                      }
                                      else
                                          completion(result,YES);
                                  }];
        };
        
        if (FBSession.activeSession.isOpen) {
            // login is integrated
            if ([[[FBSession activeSession] permissions]indexOfObject:@"publish_actions"] == NSNotFound) {
                
                [[FBSession activeSession] requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions,publish_stream"] defaultAudience:FBSessionDefaultAudienceFriends
                                                      completionHandler:^(FBSession *session,NSError *error){
                                                          if (error) {
                                                              completion(nil,NO);
                                                          }else {
                                                              PostRequestPage();
                                                          }
                                                      }];
            }
            else
                PostRequestPage();
            
        } else {
            
            
            [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"publish_stream",@"publish_actions", nil] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                if (error) {
                    DisplayAlertWithTitle(error.description, @"kFacebook");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion)
                            completion(nil,NO);
                    });
                } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                    // send our requests if we successfully logged in
                    PostRequestPage();
                }
            }];
            
        }
    }
    else{
        completion(nil,NO);
        DisplayAlertWithTitle(@"No internet connection", @"kFacebook");
    }
}

+(void)FacebookSendRequestToFriends:(NSArray*)TargetFriends Message:(NSString*)message :(void(^)(NSString *requestId ,BOOL success))completion{
    
    if ([SharedObj isNetworkReachable]) {
        void(^SendRequestFriend)(void)=^{
            
            
            NSError *error;
            NSData *jsonData = [NSJSONSerialization
                                dataWithJSONObject:@{
                                                     @"social_karma": @"5",
                                                     @"badge_of_awesomeness": @"1"}
                                options:0
                                error:&error];
            if (!jsonData) {
                NSLog(@"JSON error: %@", error);
                return;
            }
            
            NSString *giftStr = [[NSString alloc]
                                 initWithData:jsonData
                                 encoding:NSUTF8StringEncoding];
            
            NSMutableDictionary* params = [@{@"data" : giftStr} mutableCopy];
            
            if (TargetFriends != nil && [TargetFriends count] > 0) {
                NSString *selectIDsStr = [TargetFriends componentsJoinedByString:@","];
                params[@"suggestions"] = selectIDsStr;
            }
            
            [FBWebDialogs
             presentRequestsDialogModallyWithSession:nil
             message:message
             title:nil
             parameters:params
             handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                 if (error) {
                     // Error launching the dialog or sending the request.
                     NSLog(@"Error sending request.");
                 } else {
                     if (result == FBWebDialogResultDialogNotCompleted) {
                         // User clicked the "x" icon
                         NSLog(@"User canceled request.");
                         completion(nil,NO);
                         
                     } else {
                         
                         NSArray *pairs = [[resultURL query] componentsSeparatedByString:@"&"];
                         NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                         for (NSString *pair in pairs) {
                             NSArray *kv = [pair componentsSeparatedByString:@"="];
                             NSString *val =
                             [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                             params[kv[0]] = val;
                         }
                         if (![params valueForKey:@"request"]) {
                             completion(nil,NO);
                         }
                         else{
                             NSString *requestID = [params valueForKey:@"request"];
                             NSLog(@"Request ID: %@", requestID);
                             completion(requestID,YES);
                         }
                         
                     }
                 }
             }];
            
        };
        
        if (FBSession.activeSession.isOpen) {
            if ([[[FBSession activeSession] permissions]indexOfObject:@"publish_actions"] == NSNotFound) {
                
                [[FBSession activeSession] requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions,publish_stream"] defaultAudience:FBSessionDefaultAudienceFriends
                                                      completionHandler:^(FBSession *session,NSError *error){
                                                          if (error) {
                                                              completion(nil,NO);
                                                          }else {
                                                              SendRequestFriend();
                                                          }
                                                      }];
            }
            else
                SendRequestFriend();
            
        } else {
            
            
            [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"publish_stream",@"publish_actions", nil] defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                if (error) {
                    DisplayAlertWithTitle(error.description, @"kFacebook");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion)
                            completion(nil,NO);
                    });
                } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                    // send our requests if we successfully logged in
                    SendRequestFriend();
                }
            }];
            
        }
    }
    else{
        completion(nil,NO);
        DisplayAlertWithTitle(@"No internet connection", @"kFacebook");
        
    }
}
//TODO: Get Method
+(void)FacebookGetFriendsList:(void (^)(NSDictionary *dictonary,BOOL success))completion{
    
    if ([SharedObj isNetworkReachable]) {
        
        void(^GetFriendsList)(void)=^{
            [FBRequestConnection startWithGraphPath:@"me/friends" parameters:[ NSDictionary dictionaryWithObjectsAndKeys:@"picture,id,name",@"fields",nil] HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
             {
                 if(!error)
                 {
                     completion(result,YES);
                     
                 }
                 else{
                     completion(nil,NO);
                     DisplayAlertWithTitle(error.description, @"kFacebook");
                 }
                 
             }];
            
        };
        
        if ([[FBSession activeSession] isOpen]) {
            NSLog(@"%@",[[FBSession activeSession] permissions]);
            if ([[[FBSession activeSession] permissions]indexOfObject:@"read_friendlists"] == NSNotFound) {
                [[FBSession activeSession] requestNewPublishPermissions:[NSArray arrayWithObject:@"read_friendlists"] defaultAudience:FBSessionDefaultAudienceFriends
                                                      completionHandler:^(FBSession *session,NSError *error){
                                                          
                                                          if (!error) {
                                                              GetFriendsList();
                                                          }
                                                          else {
                                                              completion(nil,NO);
                                                              DisplayAlertWithTitle(error.description, @"kFacebook");
                                                          }
                                                      }];
            }
            else
                GetFriendsList();
            
        }else{
            [FBSession openActiveSessionWithReadPermissions:[NSArray arrayWithObject:@"read_friendlists"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                if (error) {
                    DisplayAlertWithTitle(error.description, @"kFacebook");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion)
                            completion(nil,NO);
                    });
                } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                    // send our requests if we successfully logged in
                    GetFriendsList();
                }
                
            }];
            
            
        }
        
    }else{
        completion(nil,NO);
        DisplayAlertWithTitle(@"No internet connection", @"kFacebook");
    }
}
#pragma mark -
#pragma mark - Twitter
#pragma mark -

+(void)TwitterLogin_Whichone:(TwitterAccountSelection)AccountSelection :(void (^)(NSArray *TwitterData,BOOL success))completion{
    if ([SharedObj isNetworkReachable]) {
       
        void(^requestLogin)(void)=^{
            ACAccountStore *accountStore = [[ACAccountStore alloc] init];
            // Create an account type that ensures Twitter accounts are retrieved.
            ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            // let's request access and fetch the accounts
            
            [accountStore requestAccessToAccountsWithType:accountType options:nil
                                               completion:^(BOOL granted, NSError *error) {
                                                   if (granted && !error) {
                                                       
                                                     NSArray  *_accountsArray = [[accountStore accountsWithAccountType:accountType] copy];
                                                       if (_accountsArray.count>0)
                                                       {
                                                           if (AccountSelection==0) {
                                                               completion([_accountsArray lastObject],YES);
                                                           }
                                                           else if (AccountSelection==1){
                                                               completion([_accountsArray firstObject],YES);
                                                           }
                                                            else{
                                                                completion(_accountsArray,YES);
                                                            }
                                                       }
                                                       else{
                                                           completion(nil,NO);
                                                           DisplayAlertWithTitle(@"No Twitter account found at Setting", @"kFacebook")
                                                           
                                                       }
                                                       
                                                   }
                                                   else{
                                                        completion(nil,NO);
                                                   }
                                               }];
            
            
        
        };
        requestLogin();
    }
    else{
        completion(nil,NO);
        DisplayAlertWithTitle(@"No internet connection", @"kFacebook");
    }
    
}

+(void)TwitterGetFriendslist_WithAccountIndex:(NSInteger)AccountIndex :(void (^)(NSArray *arrayFriendsList,BOOL success))completion{
    
    if ([SharedObj isNetworkReachable]) {
        
        void(^requestLogin)(void)=^{
            ACAccountStore *accountStore = [[ACAccountStore alloc] init];
            // Create an account type that ensures Twitter accounts are retrieved.
            ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            // let's request access and fetch the accounts
            
            [accountStore requestAccessToAccountsWithType:accountType options:nil
                                               completion:^(BOOL granted, NSError *error) {
                                                   if (granted && !error) {
                                                       
                                                       NSArray  *accountsArray = [[accountStore accountsWithAccountType:accountType] copy];
                                                       if (accountsArray.count>0) {
                                                          
                                                           if (AccountIndex>=accountsArray.count) {
                                                               completion(nil,NO);
                                                           }
                                                           else{
                                                          ACAccount *twitterAccount=[accountsArray objectAtIndex:AccountIndex];
                                                           
                                                           // Runing on iOS 6
                                                           if (NSClassFromString(@"SLComposeViewController") && [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
                                                           {
                                                               
                                                               
                                                               SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:[NSURL URLWithString:@"https://api.twitter.com/1.1/friends/list.json"]                                      parameters:nil];
                                                               
                                                               [request setAccount:twitterAccount];
                                                               
                                                               dispatch_async(dispatch_get_main_queue(), ^
                                                                              {
                                                                                  
                                                                                  [NSURLConnection sendAsynchronousRequest:request.preparedURLRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response1, NSData *data, NSError *error)
                                                                                   {
                                                                                       dispatch_async(dispatch_get_main_queue(), ^
                                                                                                      {
                                                                                                          if (data)
                                                                                                          {
                                                                                                              if (error) {
                                                                                 
                                                                                                                  DisplayAlertWithTitle(@"try again", @"kTwitter");
                                                                                                              }else{
                                                                                                                  NSError* error;
                                                                                                                  NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions  error:&error];
                                                                                                                  
                                                                                                                  NSArray *arryfriendList=[json valueForKey:@"users"];
                                                                                                                  completion(arryfriendList,YES);

                                                                                                                  
                                                                                                                  
                                                                                                              }
                                                                                                          }
                                                                                                          else{
                                                                                                              
                                                                                                              completion(nil,NO);
                                                                                                          }
                                                                                                      });
                                                                                   }];
                                                                              });
                                                           }
                                                           else
                                                               completion(nil,NO);
                                                       }
                                                       }
                                                       else{
                                                           completion(nil,NO);
                                                           DisplayAlertWithTitle(@"No Twitter account found at Setting", @"kFacebook")
                                                           
                                                       }
                                                      
                                                   }
                                                   else{
                                                       completion(nil,NO);
                                                   }
                                               }];
            
            
            
        };
        requestLogin();
    }
    else{
        completion(nil,NO);
        DisplayAlertWithTitle(@"No internet connection", @"kFacebook");
    }

}
@end

static GlobalSharedClass *sharedClass = nil;

@implementation GlobalSharedClass

+(GlobalSharedClass *)sharedInstance
{
    @synchronized(self)
    {
        if (sharedClass == nil)
        {
            sharedClass = [[GlobalSharedClass alloc] init];
        }
    }
    
    return sharedClass;
}
#pragma mark- =========================Network============================

-(BOOL)isNetworkReachable
{
	[[NetConnection sharedReachability] setHostName:@"www.google.com"];
	NetworkStatus remoteHostStatus = [[NetConnection sharedReachability] internetConnectionStatus];
	if (remoteHostStatus == NotReachable)
		return NO;
	else if (remoteHostStatus == ReachableViaCarrierDataNetwork || remoteHostStatus == ReachableViaWiFiNetwork)
		return YES;
	return NO;
}
@end
