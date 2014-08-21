//
//  MessageTableViewCell.h
//  OpenPass
//
//  Created by PangBo on 16/07/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PureLayout.h"

@protocol pushToCommentViewDelegate <NSObject>

@required
@property (nonatomic) NSInteger numberOfMessageWillBePushed;
- (void)pushToCommentView;

@end


@interface WhatsupTableViewCell : UITableViewCell

@property (nonatomic) NSInteger number;
@property (nonatomic, strong) NSString *messageID;
@property (nonatomic, strong) UIImageView *profile;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *numberOfComment;
@property (nonatomic, strong) id<pushToCommentViewDelegate> delegate;

@end
