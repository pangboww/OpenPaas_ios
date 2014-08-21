//
//  OPLogin.m
//  OpenPass
//
//  Created by PangBo on 26/06/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import "OPLogin.h"

@interface OPLogin()

@property (strong, nonatomic) NSString *basePath;

@end

@implementation OPLogin

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(checkResult:) name:@"loginRequest"
                                                   object:nil];
    }
    return self;
}


- (void)start
{
    OPPostRequest *loginRequest = [[OPPostRequest alloc] initWithBaseUrl:[OPLogin completeUrlWithBaseUrl:self.basePath] andSecurity:self.security andName:@"loginRequest"];
    NSDictionary *loginInformation = @{@"username" : self.user.username,
                                       @"password" : self.user.password};
    [loginRequest setParameters:loginInformation];
    [loginRequest request];
}


- (void)checkResult:(NSNotification *)notification
{
    if([notification.name isEqualToString:@"loginRequest"]){
        NSDictionary *recieveData = notification.userInfo;
        NSString *result = [[recieveData allKeys] firstObject];
        
        if ([result isEqualToString:@"responseContent"]) {
            
            NSError *jerror = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:recieveData[@"responseContent"][@"data"]
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&jerror];
            if ([[dic allKeys] containsObject:@"error"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginResponse"
                                                                    object:nil
                                                                  userInfo:[NSDictionary dictionaryWithObject:@"failed" forKey:@"loginResponse"]];
            }
            else if ([[dic allKeys] containsObject:@"login"]) {
                self.user.firstName = dic[@"firstname"];
                self.user.lastName = dic[@"lastname"];
                self.user.email = dic[@"email"];
                self.user.domainId = dic[@"domains"][0][@"domain_id"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"loginResponse"
                                                                    object:nil
                                                                  userInfo:[NSDictionary dictionaryWithObject:@"successful" forKey:@"loginResponse"]];
            }
            
        }
    }
}

- (instancetype)initWithUsername:(NSString *)username andPassword:(NSString *)password andBasePath:(NSString *)basePath
{
    self = [self init];
    if (self) {
        self.user.username = username;
        self.user.password = password;
        self.basePath = basePath;
    }
    return self;
}

- (void)setUsername:(NSString *)username andPassword:(NSString *)password andBasePath:(NSString *)basePath
{
    if (self) {
        self.user.username = username;
        self.user.password = password;
        self.basePath = basePath;
    }
}


- (OPUser *)user
{
    if (!_user) {
        _user = [[OPUser alloc] init];
    }
    return _user;
}

+ (NSString *)completeUrlWithBaseUrl:(NSString *)basePath
{
    NSString *newUrl = [basePath stringByAppendingString:@"/api/login"];
    return newUrl;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
