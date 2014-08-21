//
//  OPPostRequest.m
//  OpenPass
//
//  Created by PangBo on 25/06/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import "OPPostRequest.h"

@interface OPPostRequest()

@property (strong, nonatomic) NSString *basePath;
@property (weak, nonatomic) NSData *requestData;



@end


@implementation OPPostRequest

- (void)request{
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.basePath]
                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                        timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lul", (unsigned long)[self.requestData length]] forHTTPHeaderField:@"Content-Length"];
    if (self.isJsonType) {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    }
    [request setHTTPBody:self.requestData];
    
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
    self.requestData = nil;
    if (parameters) {
        NSMutableString *parameterString = [[NSMutableString alloc] init];
        for (id key in [parameters allKeys]) {
            id value = parameters[key];
            if ([key isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]){
                [parameterString appendString:key];
                [parameterString appendString:@"="];
                [parameterString appendString:value];
                [parameterString appendString:@"&"];
            }
        }
        self.requestData = [parameterString dataUsingEncoding:NSUTF8StringEncoding];
    }
}

- (void)setContent:(NSString *)content
{
    self.requestData = [content dataUsingEncoding:NSUTF8StringEncoding];
}






@end
