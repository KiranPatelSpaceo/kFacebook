//
//  kFacebook.h
//  kFacebook
//
//  Created by macmini17 on 20/05/14.
//  Copyright (c) 2014 macmini17. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetConnection.h"

typedef NS_OPTIONS(NSUInteger, TwitterAccountSelection) {
    kLastAccount  = 0,//Last Account from Setting
    kFirstAccount = 1,//First Account from Setting
    kAllAccount   = 2 //All Acounts from Setting
};
@interface kFacebook : NSObject
{
    TwitterAccountSelection *accountSelection;
}
/*   //////  Login ///////////
 
 Responce NSDictionary *dictonary,BOOL success
 dictonary - User Basic info
 success   - Login Suceess return YES other wise return NO
 
 */
+(void)FacebookLogin:(void (^)(NSDictionary *dictonary,BOOL success))completion;


/*  //////  Logout ///////////
 
 Responce BOOL success
 success   - Logout Suceess return YES other wise return NO
 Active Session Close token will become nill
 
 */
+(void)FacebookLogOut:(void (^)(BOOL success))completion;


/*  //////  Post Text and Image on your wall ///////////
 
 Responce BOOL success
 success   - Post Suceess return YES other wise return NO
 User can pass both UIImage and text or either any one
 
 */
+(void)FacebookPost_Text:(NSString*)text image:(UIImage*)image :(void (^)(BOOL success))completion;


/*  //////  Post Text,Image,Link on Friend's wall ///////////
 
 Responce BOOL success
 success   - Post Suceess return YES other wise return NO
 Pass Parameters in Dictionary
  Value               Key
 1)Name             name
 2)Caption          caption
 3)Description      description
 4)Link             link
 5)Image            picture
 6)Friend'ID        id

 */

+(void)FacebookPostOnFriendWall:(NSDictionary*)parameters :(void(^)( BOOL suceess))completion;


/*  //////  Post Text on Public Facebook Page ///////////
 
 Responce BOOL success,NSDictionary *responce
 success   - Post Suceess return YES other wise return NO
 responce  - Return post id
 
 Pass Parameters in Dictionary (like name,image etc...)
 Page id compulsory to pass
 
 */

+(void)FacebookPostOnFacebookPage:(NSDictionary*)parameters page_id:(NSString*)pageid :(void(^)(NSDictionary *responce ,BOOL success))completion;


/*  //////  Send Request to Your Friends ///////////
 
 Responce BOOL success,NSString *requestId
 success   - Post Suceess return YES other wise return NO
 requestId  - Return request id
 
 
 Pass Parameters 
 1)Your Friends Ids  pass in NSArray. (optional)
 if you pass nil, all friends list will be display
 2)Message (Requierd)
 
 */
+(void)FacebookSendRequestToFriends:(NSArray*)TargetFriends Message:(NSString*)message :(void(^)(NSString *requestId ,BOOL success))completion;


/*  //////  Get Your Facebook Friends List ///////////
 
 Responce BOOL success,NSDictionary *dictonary
 success   - Post Suceess return YES other wise return NO
 dictonary  - Return all data of your friends

 */
+(void)FacebookGetFriendsList:(void (^)(NSDictionary *dictonary,BOOL success))completion;


/*   //////  Login ///////////
 
 Responce NSArray *TwitterData,BOOL success
 TwitterData - User Basic info
 success   - Login Suceess return YES other wise return NO
 
 Parameter
  TwitterAccountSelection 0   =  Last twitter Account From Setting
  TwitterAccountSelection 1   =  First twitter Account From Setting
  TwitterAccountSelection 2   =  All twitter Accounts From Setting
 */
+(void)FacebookAllAlbumsList:(void (^)(NSDictionary *dictonary,BOOL success))completion;


+(void)TwitterLogin_Whichone:(TwitterAccountSelection)AccountSelection :(void (^)(NSArray *TwitterData,BOOL success))completion;


/*   //////  Get Friends List ///////////
 
 Responce NSArray *arrayFriendsList,BOOL success
 TwitterData - User Basic info
 success   - Login Suceess return YES other wise return NO
 
 Parameter
 AccountIndex    = you have to pass index regarding your setting 's twitter accounts.
 if multiple account in setting then pass index otherwise pass index = 0
 
 */
+(void)TwitterGetFriendslist_WithAccountIndex:(NSInteger)AccountIndex :(void (^)(NSArray *arrayFriendsList,BOOL success))completion;
@end


@class NetConnection;

@interface GlobalSharedClass : NSObject
{
    
}
+(GlobalSharedClass *)sharedInstance;
-(BOOL)isNetworkReachable;

@end
