//
//  OPMessageMapping.m
//  OpenPass
//
//  Created by PangBo on 30/06/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import "OPMessageMapping.h"


@interface OPMessageMapping()

@property (nonatomic, strong)NSString *basePath;
@property (nonatomic, strong)NSString *before;
@property (nonatomic, strong)NSString *uuid;


@end

@implementation OPMessageMapping

- (instancetype)initWithBasePath:(NSString *)basePath andUUID:(NSString *)uuid
{
    if (!self) {
        self = [super init];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveMessage:) name:@"requestMoreMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveMessageContent:) name:@"requestMessageContent" object:nil];
    self.basePath = basePath;
    self.before = nil;
    self.data = [[NSMutableArray alloc] init];
    self.uuid = uuid;
    self.isEnable = YES;
    return self;
}

-(void)requestMoreMessage
{
    if (self.isEnable) {
        OPGetRequest *urlRequest = [[OPGetRequest alloc] initWithBaseUrl:[[self.basePath stringByAppendingString:@"/api/activitystreams/"]stringByAppendingString:self.uuid] andSecurity:self.security andName:@"requestMoreMessage"];
        NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
        [parameters setObject:@"30" forKey:@"limit"];
        if (self.before != nil) {
            [parameters setObject:self.before forKey:@"before"];
        }
        [urlRequest setParameters:parameters];
        [urlRequest request];
        [[OPNetworkActivityIndicator sharedActivityIndicator] startActivity];
    }
    else{
        NSLog(@"\nNo more message!\n");
    }
}

-(void)didRecieveMessage:(NSNotification *)notification
{
    if([notification.name isEqualToString:@"requestMoreMessage"]){
        NSDictionary *recieveData = notification.userInfo;
        NSString *result = [[recieveData allKeys] firstObject];
        
        
        if ([result isEqualToString:@"responseContent"]) {
            [[OPNetworkActivityIndicator sharedActivityIndicator] stopActivity];
            NSError *jerror = nil;
            id dic = [NSJSONSerialization JSONObjectWithData:recieveData[@"responseContent"][@"data"]
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&jerror];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                NSLog(@"/n/nerror:%@",dic);
            }
            else if ([dic isKindOfClass:[NSArray class]]) {
                NSInteger j = OP_NUM_MESSAGE_SHOWN;
                
                if ([dic count]) {
                    for (int i = 0; i < [(NSArray *)dic count]; i++) {
                        NSDictionary *message = dic[i];
                        if (![[message allKeys] containsObject:@"inReplyTo"]){
                            
                            //request content of the message
                            
                            OPGetRequest *urlRequest = [[OPGetRequest alloc] initWithBaseUrl:[self.basePath stringByAppendingString:@"/api/messages"] andSecurity:self.security andName:@"requestMessageContent"];
                            NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                            [parameters setObject:message[@"object"][@"_id"] forKey:@"ids[]"];
                            [urlRequest setParameters:parameters];
                            [urlRequest request];
                            [[OPNetworkActivityIndicator sharedActivityIndicator] startActivity];
                            
                            //set self.before as message to indicate the last message we have read
                            self.before = message[@"_id"];
                            j--;
                        }
                        if (j == 0) {
                            break;
                        }
                    }
                }
                else {
                    self.isEnable = NO;
                }
                
            }
        }
    }
}

-(void)didRecieveMessageContent:(NSNotification *)notification
{
    if([notification.name isEqualToString:@"requestMessageContent"]){
        [[OPNetworkActivityIndicator sharedActivityIndicator] stopActivity];
        NSDictionary *recieveData = notification.userInfo;
        NSString *result = [[recieveData allKeys] firstObject];
        
        if ([result isEqualToString:@"responseContent"]){
            [[OPNetworkActivityIndicator sharedActivityIndicator] stopActivity];
            NSError *jerror = nil;
            id dic = [NSJSONSerialization JSONObjectWithData:recieveData[@"responseContent"][@"data"]
                                                     options:NSJSONReadingMutableContainers
                                                       error:&jerror];

            [self.data addObject:dic[0]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"messageUpdated" object:nil];
        }
    }
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
