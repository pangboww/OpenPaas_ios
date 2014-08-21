//
//  OPMessageContent.h
//  OpenPass
//
//  Created by PangBo on 03/07/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPMessageContent : NSObject

@property (strong, nonatomic) NSString *messageID;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSArray *replies;

@end
