//
//  OPMessageMapping.h
//  OpenPass
//
//  Created by PangBo on 30/06/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OPGetRequest.h"
#import "OPNetworkActivityIndicator.h"


#define OP_NUM_MESSAGE_SHOWN 5
@interface OPMessageMapping : NSObject

@property (nonatomic)BOOL security;
@property (nonatomic)BOOL isEnable;
@property (nonatomic, strong)NSMutableArray *data;

- (instancetype)initWithBasePath:(NSString *)basePath andUUID:(NSString *)uuid;

- (void)requestMoreMessage;

@end
