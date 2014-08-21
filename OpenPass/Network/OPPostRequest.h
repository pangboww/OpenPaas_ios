//
//  OPPostRequest.h
//  OpenPass
//
//  Created by PangBo on 25/06/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OPPostRequest : NSObject

@property (strong, nonatomic) NSString *name;
@property (nonatomic) BOOL isJsonType;


- (void)request;
- (instancetype)initWithBaseUrl:(NSString *)site andSecurity:(BOOL)security andName:(NSString *)name;
- (void)setParameters:(NSDictionary *)parameters;
- (void)setContent:(NSString *)content;

@end
