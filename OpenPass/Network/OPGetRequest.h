//
//  OPGetRequest.h
//  OpenPass
//
//  Created by PangBo on 24/06/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPGetRequest :NSObject

@property (strong, nonatomic) NSString *name;

- (void)request;
- (instancetype)initWithBaseUrl:(NSString *)site andSecurity:(BOOL)security andName:(NSString *)name;
- (void)setParameters:(NSDictionary *)parameters;

@end
