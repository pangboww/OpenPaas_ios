//
//  OpenPassTests.m
//  OpenPassTests
//
//  Created by PangBo on 17/06/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OPUtility.h"
#import "OPGetRequest.h"
#import "OPLogin.h"
#import "OPMessageMapping.h"
#import "NSDate+TimeAgo.h"

@interface OpenPassTests : XCTestCase

@end

@implementation OpenPassTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    //XCTAssertEqualObjects([OPUtility getContentFrom:@"12345678" byHead:@"12" andTail:@"56"], @"34");
}
@end
