//
//  CodoonAccess.h
//  featureView
//
//  Created by Alex on 13-11-8.
//  Copyright (c) 2013年 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CodoonAccess : NSObject

//如果本地没有access token用这个来生成请求access code的url
+(NSString*) codeUrlWithClientId:(NSString*)clientId AndScope:(NSString*)scope;
//得到access code后用这个来初始化access token
+(void) initWithCode:(NSString*)accessCode AndClientID:(NSString*)clientId AndSecret:(NSString*)secret AndScope:(NSString*)scope onComplete:(void (^)(BOOL,CodoonAccess*,NSDictionary*))handler;

//如果在本地已经有了access token用这个初始化
-(id) initWithToken:(NSString *)accessToken AndSecret:(NSString*)secret AndExpin:(NSString*)expIn;
//获取access token的字典对象，包含access_token access_secret 和 exprie
-(NSDictionary*) getToken;
//post到接口的基础方法，公开出来是方便各位扩展
-(void) postTo:(NSString*)methodName with:(NSDictionary*)params on:(void (^)(BOOL, NSDictionary*))handler;
//get到接口的基础方法，公开出来是方便各位扩展
-(void) getUri:(NSString*)methodName with:(NSDictionary*)params on:(void (^)(BOOL, NSDictionary*))handler;
//带参数的get
-(void) getUri:(NSString*)methodName on:(void (^)(BOOL, NSDictionary*))handler;
//获取用户基本信息
-(void) verify_credentials:(void (^)(BOOL, NSDictionary*))handler;
//修改用户的各项属性
-(void) update_profile_withHight:(NSNumber*)height andWeight:(NSNumber*)weight andGender:(NSNumber*)gender andNick:(NSString*)nick andHobby:(NSString*)hobby andImgdata:(NSData*)image_data andImgname:(NSString*)img_name andDescription:(NSString*)description onComplete:(void (^)(BOOL, NSDictionary*))handler;
//不修改头像修改用户属性
-(void) update_profile_withHight:(NSNumber*)height andWeight:(NSNumber*)weight andGender:(NSNumber*)gender andNick:(NSString*)nick andHobby:(NSString*)hobby andDescription:(NSString*)description onComplete:(void (^)(BOOL, NSDictionary*))handler;
//获取运动目标
-(void) get_tracker_goal:(void (^)(BOOL, NSDictionary*))handler;
//修改运动目标
-(void) change_tracker_goal_withGoalType:(NSString*)goal_type andGoalvalue:(NSNumber*)goal_value onComplete:(void (^)(BOOL, NSDictionary*))handler;
//获取体重身高修改记录
-(void) get_body_log:(void (^)(BOOL, NSDictionary*))handler;
//修改体重身高数据
-(void) post_body_data_withItems:(NSDictionary*)items onComplete:(void (^)(BOOL, NSDictionary*))handler;
//获取开始结束时间范围内的按天汇总运动情况
-(void) get_tracker_summary_withDateEnd:(NSString*)date_end andDays:(NSNumber*)days onComplete:(void (^)(BOOL, NSDictionary*))handler;
//按天获取当天运动详情
-(void) get_tracker_data_withDate:(NSString*)theDay onComplete:(void (^)(BOOL, NSDictionary*))handler;
//按天获取当天睡眠数据详情
-(void) get_sleep_data_withDate:(NSString*)theDay onComplete:(void (^)(BOOL, NSDictionary*))handler;
//获取运动目标完成度
-(void) get_sport_complete_rate_withDate:(NSString*)theDay onComplete:(void (^)(BOOL, NSDictionary*))handler;
//根据线路ID获取线路详细信息
-(void) get_route_by_id:(NSString*)route_id onComplete:(void (^)(BOOL, NSDictionary*))handler;
@end
