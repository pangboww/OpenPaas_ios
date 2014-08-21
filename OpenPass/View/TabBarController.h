//
//  TabBarController.h
//  OpenPass
//
//  Created by PangBo on 01/07/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPUser.h"

@interface TabBarController : UITabBarController

@property (strong, nonatomic)OPUser *user;
@property (strong, nonatomic)NSString *basePath;
@property (nonatomic)BOOL security;

@end
