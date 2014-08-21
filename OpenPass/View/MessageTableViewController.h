//
//  TableViewController.h
//  OpenPass
//
//  Created by PangBo on 11/07/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TabBarController.h"

#import "OPUser.h"
#import "OPNetworkActivityIndicator.h"
#import "OPMessageMapping.h"
#import "OPPostRequest.h"
#import "OPMessageContent.h"
#import "MJRefresh.h"
#import "YIPopupTextView.h"
#import "SBJson4Writer.h"
#import "OPTimeTool.h"

#import "WhatsupTableViewCell.h"
#import "CommentTableViewCell.h"
#import "CommentTableViewController.h"






@interface MessageTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,YIPopupTextViewDelegate,pushToCommentViewDelegate>

@property (strong, nonatomic) OPUser *user;
@property (strong, nonatomic) NSString *basePath;
@property (nonatomic) BOOL security;
@property (nonatomic)NSInteger numberOfMessageWillBePushed;

@end
