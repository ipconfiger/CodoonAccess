//
//  NSString+UrlEncoding.m
//  CodoonAccess
//
//  Created by Alex on 13-11-8.
//  Copyright (c) 2013年 Alex. All rights reserved.
//

#import "NSString+UrlEncoding.h"

@implementation NSString (UrlEncoding)
-(NSString*)urlEncode:(NSDictionary *)params{
    return [self urlEncode:params withEncoding:NSUTF8StringEncoding];
}
-(NSString*)urlEncode:(NSDictionary *)params withEncoding:(NSStringEncoding)encoding{
    NSMutableArray* segments = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString* key in params) {
        NSString* segment = [[key stringByAppendingString:@"="] stringByAppendingString:
            [[params objectForKey:key] stringByAddingPercentEscapesUsingEncoding:encoding]
         ];
        [segments addObject:segment];
    }
    return [segments componentsJoinedByString:@"&"];
}
@end
