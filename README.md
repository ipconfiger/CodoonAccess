CodoonAccess
============

codoon openapi sdk


    #import <Foundation/Foundation.h>
    #import "NSDictionary+UrlEncoding.h"
    #import "CodoonAccess.h"
    
    int main(int argc, const char * argv[])
    {
    
        @autoreleasepool {
    
            [CodoonAccess initWithClientID:@"xxxxxxxxxxxxxxxxx"
                               AndSecret:@"xxxxxxxxxxxxxxxxxxxx
                               AndUserName:@"xxxxxxxxxxxx
                               AndPassword:@"xxxxxxxx"
                               AndScope:@"user"
                               onComplete:^(BOOL success, NSDictionary *error) {
                                   NSLog(@"result:%@", error);
                                   CodoonAccess* acc = [[CodoonAccess alloc] init];
                                   [acc verify_credentials:^(BOOL success, NSDictionary* data){
                                       NSLog(@"rs=%hhd", success);
                                       NSLog(@"data=%@", data);
                                   }];
                               }
             ];
            
            
            char str[50] = {0};
            printf("Enter for exit:");
            scanf("%s",str);
    
        }
        return 0;
    }
