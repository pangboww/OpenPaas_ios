//
//  OPUtility.m
//  OpenPass
//
//  Created by PangBo on 23/06/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import "OPUtility.h"

@implementation OPUtility


+ (NSString *) getContentFrom: (NSString *)string byHead: (NSString *)head andTail:(NSString *)tail{
    NSRange h = [string rangeOfString:head];
    NSInteger index = h.location+h.length;
    NSInteger length = [string rangeOfString:tail].location - index;
    NSRange range = {index,length};
    return [string substringWithRange:range];
}




@end
