//
//  OPLogin.h
//  OpenPass
//
//  Created by PangBo on 26/06/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPPostRequest.h"
#import "OPUser.h"

@interface OPLogin : NSObject

@property (nonatomic) BOOL security;
@property (strong, nonatomic) OPUser *user;


- (id)initWithUsername:(NSString *)username andPassword:(NSString *)password andBasePath:(NSString *)basePath;

- (void)start;
@end
