//
//  CommentTableViewCell.h
//  OpenPass
//
//  Created by PangBo on 16/07/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PureLayout.h"

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *profile;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) NSString *type;


@end
