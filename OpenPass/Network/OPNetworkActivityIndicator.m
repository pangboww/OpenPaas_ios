//
//  OPNetworkActivityIndicator.m
//  OpenPass
//
//  Created by PangBo on 26/06/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import "OPNetworkActivityIndicator.h"

@interface OPNetworkActivityIndicator()

@property (nonatomic) NSUInteger counter;

@end


@implementation OPNetworkActivityIndicator

+ (instancetype) sharedActivityIndicator
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    if ((self = [super init]))
    {
        self.counter = 0;
    }
    
    return self;
}

- (void)startActivity
{
    @synchronized(self)
    {
        self.counter++;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}

- (void)stopActivity
{
    @synchronized(self)
    {
        if (self.counter > 0 && --self.counter == 0)
        {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }
    }
}

- (void)stopAllActivity
{
    @synchronized(self)
    {
        self.counter = 0;
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

@end



