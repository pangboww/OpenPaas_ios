//
//  OPTimeTool.m
//  OpenPass
//
//  Created by PangBo on 17/07/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import "OPTimeTool.h"

@implementation OPTimeTool

+ (NSString *)convertDate:(NSString *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:sss.SSSZ"];
    NSDate *newDate = [dateFormatter dateFromString:date];
    NSString *ago = [newDate timeAgo];
    return ago;
}


@end
