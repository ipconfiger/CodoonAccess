//
//  NSString+UrlEncoding.h
//  CodoonAccess
//
//  Created by Alex on 13-11-8.
//  Copyright (c) 2013年 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UrlEncoding)
-(NSString*) urlEncode:(NSDictionary*)params;
-(NSString*) urlEncode:(NSDictionary*)params withEncoding:(NSStringEncoding)encoding;
@end
