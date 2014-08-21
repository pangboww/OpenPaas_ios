//
//  OPUser.h
//  OpenPass
//
//  Created by PangBo on 24/06/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OPUser : NSObject

@property (strong, nonatomic)NSString *domainId;

@property (strong, nonatomic)NSString *username;
@property (strong, nonatomic)NSString *password;

@property (strong, nonatomic)NSString *email;
@property (strong, nonatomic)NSString *firstName;
@property (strong, nonatomic)NSString *lastName;
@property (strong, nonatomic)NSString *companyName;

@end
