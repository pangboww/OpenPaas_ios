    //
//  MessageTableViewCell.m
//  OpenPass
//
//  Created by PangBo on 16/07/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import "WhatsupTableViewCell.h"

#define kLabelHorizontalInsets 15.0f
#define kLabelVerticalInsets   10.0f

@interface WhatsupTableViewCell()

@property (nonatomic, assign) BOOL didSetupConstraints;

@property (nonatomic, strong) UIButton *useful;
@property (nonatomic, strong) UIButton *comment;
@property (nonatomic, strong) UIButton *share;

@end

@implementation WhatsupTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.name = [UILabel newAutoLayoutView];
        [self.name setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.name setNumberOfLines:1];
        [self.name setTextAlignment:NSTextAlignmentCenter];
        [self.name setTextColor:
            [UIColor colorWithRed:0.27 green:0.55 blue:0.78 alpha:1.0]];
        self.name.backgroundColor = [UIColor clearColor];
        self.name.font =  [UIFont fontWithName:@"Arial-BoldMT" size:18];
        
        self.time = [UILabel newAutoLayoutView];
        [self.time setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.time setNumberOfLines:1];
        [self.time setTextAlignment:NSTextAlignmentLeft];
        [self.time setTextColor:[UIColor grayColor]];
        [self.time setFont:[UIFont systemFontOfSize:10]];
        self.time.backgroundColor = [UIColor clearColor];
        
        
        self.content = [UILabel newAutoLayoutView];
        [self.content setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.content setNumberOfLines:0];
        [self.content setTextAlignment:NSTextAlignmentLeft];
        [self.content setTextColor:[UIColor blackColor]];
        self.content.backgroundColor = [UIColor clearColor];

        self.profile = [UIImageView newAutoLayoutView];
        self.profile.image = [UIImage imageNamed:@"DefaultProfile"];

        self.numberOfComment = [UILabel newAutoLayoutView];
        [self.numberOfComment setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.numberOfComment setNumberOfLines:1];
        [self.numberOfComment setTextAlignment:NSTextAlignmentLeft];
        [self.numberOfComment setTextColor:[UIColor grayColor]];
        [self.numberOfComment setFont:[UIFont systemFontOfSize:10]];
        self.numberOfComment.backgroundColor = [UIColor clearColor];
        
        self.useful = [UIButton newAutoLayoutView];
        [self.useful setImage:[UIImage imageNamed:@"Useful"] 
                     forState:UIControlStateNormal];
        [self.useful setImageEdgeInsets:UIEdgeInsetsMake(8.5,20.5,8.5,60.5)];
        [self.useful setTitle:@"useful" 
                     forState:UIControlStateNormal];
        [self.useful setTitleColor:[UIColor blackColor] 
                          forState:UIControlStateNormal];
        [self.useful.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.useful setBackgroundColor:
            [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.000]];
        self.useful.layer.cornerRadius = 1;
        [self.useful.layer setShadowColor:[UIColor grayColor].CGColor];
        [self.useful.layer setShadowOpacity:0.4];
        [self.useful.layer setShadowRadius:2.0];
        [self.useful.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
        self.useful.userInteractionEnabled = YES;
        
        
        self.comment = [UIButton newAutoLayoutView];
        [self.comment setImage:[UIImage imageNamed:@"Comment"]
                      forState:UIControlStateNormal];
        [self.comment setImageEdgeInsets:UIEdgeInsetsMake(8.5,10.5,8.5,73.5)];
        [self.comment setTitle:@"comment"
                      forState:UIControlStateNormal];
        [self.comment setTitleColor:[UIColor blackColor]
                           forState:UIControlStateNormal];
        [self.comment.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.comment setBackgroundColor:
            [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.000]];
        [self.comment addTarget:self
                         action:@selector(didClickCommentButton:)
               forControlEvents:UIControlEventTouchUpInside];
        self.comment.layer.cornerRadius = 1;
        [self.comment.layer setShadowColor:[UIColor grayColor].CGColor];
        [self.comment.layer setShadowOpacity:0.4];
        [self.comment.layer setShadowRadius:2.0];
        [self.comment.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
        self.comment.userInteractionEnabled = YES;
        
        
        self.share = [UIButton newAutoLayoutView];
        [self.share setImage:[UIImage imageNamed:@"Share"]
                    forState:UIControlStateNormal];
        [self.share setImageEdgeInsets:UIEdgeInsetsMake(8.5,23.5,8.5,60.5)];
        [self.share setTitle:@"share"
                    forState:UIControlStateNormal];
        [self.share setTitleColor:[UIColor blackColor]
                         forState:UIControlStateNormal];
        [self.share.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.share setBackgroundColor:
            [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.000]];
        self.share.layer.cornerRadius = 1;
        [self.share.layer setShadowColor:[UIColor grayColor].CGColor];
        [self.share.layer setShadowOpacity:0.4];
        [self.share.layer setShadowRadius:2.0];
        [self.share.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
        self.share.userInteractionEnabled = YES;
        
        [self setBackgroundColor:
            [UIColor colorWithRed:0.87 green:0.88 blue:0.89 alpha:1.0]];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.time];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.profile];
        [self.contentView addSubview:self.useful];
        [self.contentView addSubview:self.comment];
        [self.contentView addSubview:self.share];
        [self.contentView addSubview:self.numberOfComment];
 
        
        self.didSetupConstraints = NO;
    }
    return self;
}

-(void)updateConstraints
{
    [super updateConstraints];
    if (self.didSetupConstraints) {
        return;
    }
    
    [self.profile autoSetDimensionsToSize:CGSizeMake(30.0f, 35.0f)];
    [self.profile autoPinEdgeToSuperviewEdge:ALEdgeTop
                                   withInset:kLabelVerticalInsets];
    [self.profile autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                   withInset:kLabelHorizontalInsets];
    
    [self.name autoPinEdgeToSuperviewEdge:ALEdgeTop
                                withInset:kLabelVerticalInsets];
    [self.name autoPinEdge:ALEdgeLeft
                    toEdge:ALEdgeRight
                    ofView:self.profile
                withOffset:kLabelHorizontalInsets];
    [self.name autoPinEdgeToSuperviewEdge:ALEdgeRight
                                withInset:kLabelHorizontalInsets
                                 relation:NSLayoutRelationGreaterThanOrEqual];

    [self.time autoPinEdge:ALEdgeLeft
                    toEdge:ALEdgeRight
                    ofView:self.profile
                withOffset:kLabelHorizontalInsets];
    [self.time autoPinEdge:ALEdgeTop
                    toEdge:ALEdgeBottom
                    ofView:self.name
                withOffset:0];
    [self.time autoPinEdgeToSuperviewEdge:ALEdgeRight
                                withInset:kLabelHorizontalInsets
                                 relation:NSLayoutRelationGreaterThanOrEqual];
    
    [self.content autoPinEdge:ALEdgeTop
                       toEdge:ALEdgeBottom
                       ofView:self.time
                   withOffset:kLabelVerticalInsets];
    [self.content autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                   withInset:kLabelHorizontalInsets];
    [self.content autoPinEdgeToSuperviewEdge:ALEdgeRight
                                   withInset:kLabelHorizontalInsets];
    
    [self.numberOfComment autoPinEdge:ALEdgeTop
                               toEdge:ALEdgeBottom
                               ofView:self.content
                           withOffset:kLabelVerticalInsets];
    [self.numberOfComment autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                   withInset:kLabelHorizontalInsets];
    [self.numberOfComment autoPinEdgeToSuperviewEdge:ALEdgeRight
                                   withInset:kLabelHorizontalInsets];

    
    
    NSArray *buttons = @[self.useful,self.comment,self.share];
    
    [self.useful autoPinEdge:ALEdgeTop
                      toEdge:ALEdgeBottom
                      ofView:self.numberOfComment
                  withOffset:kLabelVerticalInsets];
    [self.useful autoPinEdgeToSuperviewEdge:ALEdgeBottom
                                  withInset:0];
    [buttons autoDistributeViewsAlongAxis:ALAxisHorizontal
                         withFixedSpacing:1
                             insetSpacing:0
                                alignment:NSLayoutFormatAlignAllCenterY];
    
    
    [self.comment autoPinEdge:ALEdgeTop
                       toEdge:ALEdgeTop
                       ofView:self.useful
                   withOffset:0];
    [self.comment autoPinEdge:ALEdgeBottom
                       toEdge:ALEdgeBottom
                       ofView:self.useful
                   withOffset:0];
    [self.share autoPinEdge:ALEdgeTop
                     toEdge:ALEdgeTop
                     ofView:self.useful
                 withOffset:0];
    [self.share autoPinEdge:ALEdgeBottom
                     toEdge:ALEdgeBottom 
                     ofView:self.useful
                 withOffset:0];

    self.didSetupConstraints = YES;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    
    CGRect frame = self.contentView.frame;
    frame.origin.x += 11;
    frame.size.width -= 22;
    frame.origin.y += 7;
    frame.size.height -= 14;

    self.contentView.frame = frame;
    [self.contentView.layer setCornerRadius:3.0f];
    
    [self.contentView.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.contentView.layer setShadowOpacity:0.4];
    [self.contentView.layer setShadowRadius:2.0];
    [self.contentView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    
    
    self.content.preferredMaxLayoutWidth = CGRectGetWidth(self.content.frame);
    
    
}

- (void)didClickCommentButton:(id)sender
{
    self.delegate.numberOfMessageWillBePushed = self.number;
    [self.delegate pushToCommentView];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
