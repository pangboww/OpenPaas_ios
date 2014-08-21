//
//  OPNetworkActivityIndicator.h
//  OpenPass
//
//  Created by PangBo on 26/06/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPNetworkActivityIndicator : NSObject

+ (id)sharedActivityIndicator;
- (void)startActivity;
- (void)stopActivity;
- (void)stopAllActivity;

@end
