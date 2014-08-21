//
//  OPGetRequest.m
//  OpenPass
//
//  Created by PangBo on 24/06/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import "OPGetRequest.h"

@interface OPGetRequest()

@property (strong, nonatomic) NSString *basePath;

@end


@implementation OPGetRequest


- (void)request{
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.basePath]
                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                        timeoutInterval:60.0];
    
    [request setHTTPMethod:@"GET"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSDictionary *responseWillBeSendByNitification = nil;
         if (!error) {
             responseWillBeSendByNitification = NSDictionaryOfVariableBindings(response, data);
         }else{
             responseWillBeSendByNitification = NSDictionaryOfVariableBindings(error);
         }
         [[NSNotificationCenter defaultCenter] postNotificationName:self.name object:nil userInfo:[NSDictionary dictionaryWithObject:responseWillBeSendByNitification forKey:@"responseContent"]];
     }];
}


- (instancetype)initWithBaseUrl:(NSString *)site andSecurity:(BOOL)security andName:(NSString *)name
{
    self = [super init];
    if (self) {
        self.name = name;
        if (security) {
            NSMutableString *newRul = [[NSMutableString alloc]initWithString:@"https://"];
            [newRul appendString:site];
            self.basePath = newRul;
        }
        else{
            NSMutableString *newRul = [[NSMutableString alloc]initWithString:@"http://"];
            [newRul appendString:site];
            self.basePath = newRul;
        }
    }
    return self;
}


- (void)setParameters:(NSDictionary *)parameters
{
    if (parameters) {
        self.basePath = [self.basePath stringByAppendingString:@"?"];

        for (id key in [parameters allKeys]) {
            id value = parameters[key];
            if ([key isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]])
            {
                self.basePath = [self.basePath stringByAppendingString:key];
                self.basePath = [self.basePath stringByAppendingString:@"="];
                self.basePath = [self.basePath stringByAppendingString:value];
                self.basePath = [self.basePath stringByAppendingString:@"&"];
            }
        }
    }
}



@end
