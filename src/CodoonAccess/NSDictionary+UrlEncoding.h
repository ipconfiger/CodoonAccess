//
//  NSDictionary+UrlEncoding.h
//  CodoonAccess
//
//  Created by Alex on 13-11-11.
//  Copyright (c) 2013年 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (UrlEncoding)
-(NSString*) urlEncode;
-(NSString*) urlEncode:(NSStringEncoding)encoding;
@end

