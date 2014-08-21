//
//  OPUtility.h
//  OpenPass
//
//  Created by PangBo on 23/06/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPUtility : NSObject

+ (NSString *) getContentFrom: (NSString *)string byHead: (NSString *)head andTail:(NSString *)tail;

@end
