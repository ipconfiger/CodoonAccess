//
//  CodoonAccess.h
//  featureView
//
//  Created by Alex on 13-11-8.
//  Copyright (c) 2013年 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodoonAccess : NSObject
+(void) initWithToken:(NSString *)accessToken AndSecret:(NSString*)secret AndExpin:(NSString*)expIn;
+(void) initWithCode:(NSString*)accessCode AndClientID:(NSString*)clientId AndSecret:(NSString*)secret AndScope:(NSString*)scope onComplete:(void (^)(BOOL,NSDictionary*))handler;
+(void) initWithClientID:(NSString*)clientId AndToken:(NSString*)token AndSecret:(NSString*)secret AndExpin:(NSString*)expIn AndUserId:(NSString*)userId AndSource:(NSString*)source AndCatalog:(NSString*)catalog AndDevice:(NSString*)deviceToken onComplete:(void (^)(BOOL,NSDictionary*))handler;
-(NSDictionary*) getToken;
-(void) postTo:(NSString*)methodName with:(NSDictionary*)params on:(void (^)(BOOL, NSDictionary*))handler;
-(void) getUri:(NSString*)methodName with:(NSDictionary*)params on:(void (^)(BOOL, NSDictionary*))handler;
-(void) getUri:(NSString*)methodName on:(void (^)(BOOL, NSDictionary*))handler;
-(void) verify_credentials:(void (^)(BOOL, NSDictionary*))handler;
-(void) update_profile_withHight:(NSNumber*)height andWeight:(NSNumber*)weight andGender:(NSNumber*)gender andNick:(NSString*)nick andHobby:(NSString*)hobby andImgdata:(NSData*)image_data andImgname:(NSString*)img_name andDescription:(NSString*)description onComplete:(void (^)(BOOL, NSDictionary*))handler;
-(void) update_profile_withHight:(NSNumber*)height andWeight:(NSNumber*)weight andGender:(NSNumber*)gender andNick:(NSString*)nick andHobby:(NSString*)hobby andDescription:(NSString*)description onComplete:(void (^)(BOOL, NSDictionary*))handler;
-(void) get_tracker_goal:(void (^)(BOOL, NSDictionary*))handler;
-(void) change_tracker_goal_withGoalType:(NSString*)goal_type andGoalvalue:(NSNumber*)goal_value onComplete:(void (^)(BOOL, NSDictionary*))handler;
-(void) get_body_log:(void (^)(BOOL, NSDictionary*))handler;
-(void) post_body_data_withItems:(NSDictionary*)items onComplete:(void (^)(BOOL, NSDictionary*))handler;
-(void) get_tracker_summary_withDateEnd:(NSString*)date_end andDays:(NSNumber*)days onComplete:(void (^)(BOOL, NSDictionary*))handler;
-(void) get_tracker_data_withDate:(NSString*)theDay onComplete:(void (^)(BOOL, NSDictionary*))handler;
-(void) get_sleep_data_withDate:(NSString*)theDay onComplete:(void (^)(BOOL, NSDictionary*))handler;
-(void) get_sport_complete_rate_withDate:(NSString*)theDay onComplete:(void (^)(BOOL, NSDictionary*))handler;
-(void) get_route_by_id:(NSString*)route_id onComplete:(void (^)(BOOL, NSDictionary*))handler;
@end
