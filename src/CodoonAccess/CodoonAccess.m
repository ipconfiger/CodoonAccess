//
//  CodoonAccess.m
//  featureView
//
//  Created by Alex on 13-11-8.
//  Copyright (c) 2013年 Alex. All rights reserved.
//

#import "CodoonAccess.h"
#import "NSDictionary+UrlEncoding.h"
#import "Base64.h"

static NSString* access_token;
static NSString* access_secret;
static NSString* expire_in;
const NSString* urlBase = @"http://api.codoon.com/api/";

int saveToken(NSString* tokenString){
    NSError* error;
    NSDictionary* tokenData = [NSJSONSerialization JSONObjectWithData:[tokenString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if(error!=nil){
        return NO;
    }
    access_token = [tokenData objectForKey:@"access_token"];
    access_secret = [tokenData objectForKey:@"refresh_token"];
    expire_in = [tokenData objectForKey:@"expire_in"];
    return YES;
}

NSDictionary* formatError(NSString *txtResponse){
    NSError* error;
    NSDictionary* tokenData = [NSJSONSerialization JSONObjectWithData:[txtResponse dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if(error!=nil){
        return @{@"error":@"network error",@"error_code":@-1,@"error_description":@"http server unreachable"};
    }else{
        return tokenData;
    }
    
}

@implementation CodoonAccess
+(void) initWithToken:(NSString *)accessToken AndSecret:(NSString*)secret AndExpin:(NSString*)expIn{
    access_token=accessToken;
    access_secret=secret;
    expire_in=expIn;
}

+(void) initWithCode:(NSString*)accessCode AndClientID:(NSString*)clientId AndSecret:(NSString*)secret AndScope:(NSString*)scope onComplete:(void (^)(BOOL,NSDictionary*))handler{
    NSDictionary *params = @{
                             @"grant_type":@"authorization_code",
                             @"client_id":clientId,
                             @"code":accessCode,
                             @"redirect_uri":@"http://localhost",
                             @"scope":scope
                             };
    NSURL *uri = [NSURL URLWithString:[@"http://api.codoon.com/token?" stringByAppendingString:[params urlEncode]]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:uri];
    [request setHTTPMethod:@"GET"];
    NSString* authToken = [@"basic " stringByAppendingString:[ [@[clientId,secret] componentsJoinedByString:@":"] base64EncodedString]];
    [request setValue:authToken forHTTPHeaderField:@"Authorization"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *txtResponse = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
         if(error!=nil){
             handler(false,formatError(txtResponse));
             return;
         }
         if (saveToken(txtResponse)){
             handler(true,@{});
         }else{
             handler(false,@{@"error":@"error response",@"error_code":@-2,@"error_description":@"wrong server format"});
         }
     }];
}

+(void) initWithClientID:(NSString*)clientId AndToken:(NSString*)token AndSecret:(NSString*)secret AndExpin:(NSString*)expIn AndUserId:(NSString*)userId AndSource:(NSString*)source AndCatalog:(NSString*)catalog AndDevice:(NSString*)deviceToken onComplete:(void (^)(BOOL succes,NSDictionary* error))handler{
    NSDictionary* params = @{
                             @"client_id":clientId,
                             @"token":token,
                             @"secret":secret,
                             @"external_user_id":userId,
                             @"source":source,
                             @"expire_in":expIn,
                             @"catalog":catalog,
                             @"device_token":deviceToken
                             };
    NSURL *uri = [NSURL URLWithString:[@"http://api.codoon.com/external_token?" stringByAppendingString:[params urlEncode]]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:uri];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *txtResponse = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
         if(error!=nil){
             handler(false,formatError(txtResponse));
             return;
         }
         if (saveToken(txtResponse)){
             handler(true,@{});
         }else{
             handler(false,@{@"error":@"error response",@"error_code":@-2,@"error_description":@"wrong server format"});
         }
     }];
}

-(NSDictionary*) getToken{
    return @{@"token":access_token,@"secret":access_secret,@"expire_in":expire_in};
}

-(void)postTo:(NSString *)methodName with:(NSDictionary *)params
           on:(void (^)(BOOL, NSDictionary*))handler{
    //prepare url and request options
    NSURL* uri = [NSURL URLWithString:[urlBase stringByAppendingString:methodName]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:uri];
    [request setHTTPMethod:@"POST"];
    
    NSError* error;
    NSData* postData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    [request setHTTPBody:postData];
    if (error!=NULL){
        @throw [NSException exceptionWithName:@"Invalid prameters"
                                       reason:@"bad data" userInfo:params];
    }
    NSString* postDataLengthString = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)[postData length]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postDataLengthString forHTTPHeaderField:@"Content-Length"];
    [request setValue:[@"Bearer " stringByAppendingString:access_token] forHTTPHeaderField:@"Authorization"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         
         NSDictionary* jsonData = [self formatJson:data];
         if([jsonData objectForKey:@"error"]!=nil){
             handler(false, jsonData);
         }else{
             handler(true, jsonData);
         }
     }];
    
}

-(void)getUri:(NSString *)methodName with:(NSDictionary *)params
           on:(void (^)(BOOL, NSDictionary*))handler{
    NSURL* uri;
    if (params!=NULL){
        uri = [NSURL URLWithString:[[[urlBase stringByAppendingString:methodName] stringByAppendingString:@"?"] stringByAppendingString:[params urlEncode]]]; //build url
    }else{
        uri = [NSURL URLWithString:[urlBase stringByAppendingString:methodName]];
    }
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:uri];
    [request setHTTPMethod:@"GET"];
    [request setValue:[@"Bearer " stringByAppendingString:access_token] forHTTPHeaderField:@"Authorization"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSDictionary* jsonData = [self formatJson:data];
         if([jsonData objectForKey:@"error"]!=nil){
             handler(false, jsonData);
         }else{
             handler(true, jsonData);
         }
     }];
    
}

-(void)getUri:(NSString *)methodName on:(void (^)(BOOL, NSDictionary*))handler{
    [self getUri:methodName with:NULL on:handler];
}

-(NSDictionary*) formatJson:(NSData*)data{
    NSString *txtResponse = [[NSString alloc] initWithData:data
                                                  encoding:NSUTF8StringEncoding];
    NSError* error;
    NSDictionary* dict_data = [NSJSONSerialization JSONObjectWithData:[txtResponse dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if(error!=nil){
        return @{@"error":@"error response",@"error_code":@-2,@"error_description":@"wrong server format"};
    }
    return dict_data;
}

-(void) verify_credentials:(void (^)(BOOL, NSDictionary*))handler{
    [self getUri:@"verify_credentials" on:^(BOOL success, NSDictionary *data) {
        handler(success, data);
    }];
}

-(void) update_profile_withHight:(NSNumber*)height andWeight:(NSNumber*)weight andGender:(NSNumber*)gender andNick:(NSString*)nick andHobby:(NSString*)hobby andImgdata:(NSData*)image_data andImgname:(NSString*)img_name andDescription:(NSString*)description onComplete:(void (^)(BOOL, NSDictionary*))handler{
    NSDictionary* dataParams = nil;
    if(image_data!=nil&&img_name!=nil){
        dataParams = @{
                       @"height":height,
                       @"weight":weight,
                       @"gender":gender,
                       @"nick":nick,
                       @"hobby":hobby,
                       @"img_data":image_data,
                       @"img_name":img_name,
                       @"descroption":description
                       };
    }else{
        dataParams = @{
                       @"height":height,
                       @"weight":weight,
                       @"gender":gender,
                       @"nick":nick,
                       @"hobby":hobby,
                       @"descroption":description
                       };
    }
    [self postTo:@"update_profile" with:dataParams on:^(BOOL success, NSDictionary *data) {
        handler(success, data);
    }];
}

-(void) update_profile_withHight:(NSNumber*)height andWeight:(NSNumber*)weight andGender:(NSNumber*)gender andNick:(NSString*)nick andHobby:(NSString*)hobby andDescription:(NSString*)description onComplete:(void (^)(BOOL, NSDictionary*))handler{
    [self update_profile_withHight:height andWeight:weight andGender:gender andNick:nick andHobby:hobby andDescription:description onComplete:^(BOOL success, NSDictionary *data) {
        handler(success, data);
    }];
}

-(void) get_tracker_goal:(void (^)(BOOL, NSDictionary*))handler{
    [self postTo:@"get_tracker_goal" with:@{} on:^(BOOL success, NSDictionary *data) {
        handler(success, data);
    }];
}

-(void) change_tracker_goal_withGoalType:(NSString*)goal_type andGoalvalue:(NSNumber*)goal_value onComplete:(void (^)(BOOL, NSDictionary*))handler{
    NSDictionary *dataParam = @{@"goal_type":goal_type,@"goal_value":goal_value};
    [self postTo:@"change_tracker_goal" with:dataParam on:^(BOOL success, NSDictionary *data) {
        handler(success, data);
    }];
    
}

-(void) get_body_log:(void (^)(BOOL, NSDictionary*))handler{
    [self postTo:@"get_body_log" with:@{} on:^(BOOL success, NSDictionary *data) {
        handler(success, data);
    }];
}

-(void) post_body_data_withItems:(NSDictionary*)items onComplete:(void (^)(BOOL, NSDictionary*))handler{
    [self postTo:@"post_body_data" with:items on:^(BOOL success, NSDictionary *data) {
        handler(success, data);
    }];
}

-(void) get_tracker_summary_withDateEnd:(NSString*)date_end andDays:(NSNumber*)days onComplete:(void (^)(BOOL, NSDictionary*))handler{
    NSDictionary* dataParam = @{@"date_end":date_end,@"days_back":days};
    [self postTo:@"get_tracker_summary" with:dataParam on:^(BOOL success, NSDictionary *data) {
        handler(success, data);
    }];
}

-(void) get_tracker_data_withDate:(NSString*)theDay onComplete:(void (^)(BOOL, NSDictionary*))handler{
    [self postTo:@"get_tracker_data" with:@{@"the_day":theDay} on:^(BOOL success, NSDictionary *data) {
        handler(success, data);
    }];
}

-(void) get_sleep_data_withDate:(NSString*)theDay onComplete:(void (^)(BOOL, NSDictionary*))handler{
    [self postTo:@"get_sleep_data" with:@{@"the_day":theDay} on:^(BOOL success, NSDictionary *data) {
        handler(success, data);
    }];
}

-(void) get_sport_complete_rate_withDate:(NSString*)theDay onComplete:(void (^)(BOOL, NSDictionary*))handler{
    [self postTo:@"get_sport_complete_rate" with:@{@"the_day":theDay} on:^(BOOL success, NSDictionary *data) {
        handler(success, data);
    }];
}

-(void) get_route_by_id:(NSString*)route_id onComplete:(void (^)(BOOL, NSDictionary*))handler{
    [self postTo:@"get_route_by_id" with:@{@"route_id":route_id} on:^(BOOL success, NSDictionary *data) {
        handler(success, data);
    }];
}
@end
