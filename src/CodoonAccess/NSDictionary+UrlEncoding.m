//
//  NSDictionary+UrlEncoding.m
//  CodoonAccess
//
//  Created by Alex on 13-11-11.
//  Copyright (c) 2013年 Alex. All rights reserved.
//

#import "NSDictionary+UrlEncoding.h"

@implementation NSDictionary (UrlEncoding)
-(NSString*)urlEncode:(NSStringEncoding)encoding{
    NSMutableArray* segments = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString* key in self) {
        NSString* segment = [[key stringByAppendingString:@"="] stringByAppendingString:
                             [[self objectForKey:key] stringByAddingPercentEscapesUsingEncoding:encoding]
                             ];
        [segments addObject:segment];
    }
    return [segments componentsJoinedByString:@"&"];
}
-(NSString*)urlEncode{
    return [self urlEncode:NSUTF8StringEncoding];
}
@end

