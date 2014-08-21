//
//  CommentTableViewController.h
//  OpenPass
//
//  Created by PangBo on 18/07/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OPUser.h"
#import "TabBarController.h"
#import "CommentTableViewCell.h"
#import "OPMessageContent.h"
#import "OPTimeTool.h"
#import "RDRStickyKeyboardView.h"
#import "SBJson4Writer.h"
#import "OPPostRequest.h"

@interface CommentTableViewController : UIViewController<RDRKeyboardInputViewDelegate,UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) NSString *messageID;

@property (strong, nonatomic) OPUser *user;
@property (strong, nonatomic) NSString *basePath;
@property (nonatomic) BOOL security;
@property (nonatomic, strong) OPMessageContent *messageContent;

@end
