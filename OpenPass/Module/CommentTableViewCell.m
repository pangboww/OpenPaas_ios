//
//  CommentTableViewCell.m
//  OpenPass
//
//  Created by PangBo on 16/07/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import "CommentTableViewCell.h"

#define kLabelHorizontalInsets 15.0f
#define kLabelVerticalInsets   10.0f

@interface CommentTableViewCell()

@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation CommentTableViewCell

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
        
        [self setBackgroundColor:
         [UIColor colorWithRed:0.87 green:0.88 blue:0.89 alpha:1.0]];
        [self.contentView setBackgroundColor:[UIColor blackColor]];
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.time];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.profile];
    }
    return self;
}

-(void)updateConstraints
{
    [super updateConstraints];
    if (self.didSetupConstraints) {
        return;
    }
    
    
    
    if ([self.type isEqualToString:@"message"]) {
        [self.profile autoSetDimensionsToSize:CGSizeMake(35.0f, 40.5f)];
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
        [self.content autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];

        
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        

        [self.contentView.layer setCornerRadius:3.0f];

        [self.contentView.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.contentView.layer setShadowOpacity:0.4];
        [self.contentView.layer setShadowRadius:2.0];
        [self.contentView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];

        
    }
    else if ([self.type isEqualToString:@"comment"]) {
        [self.profile autoSetDimensionsToSize:CGSizeMake(35.0f, 40.5f)];
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
        self.name.font =  [UIFont fontWithName:@"Arial-BoldMT" size:14];

        [self.content autoPinEdge:ALEdgeTop
                           toEdge:ALEdgeBottom
                           ofView:self.name
                       withOffset:-8];
        [self.content autoPinEdge:ALEdgeLeft
                           toEdge:ALEdgeRight
                           ofView:self.profile
                       withOffset:kLabelHorizontalInsets];
        [self.content autoPinEdgeToSuperviewEdge:ALEdgeRight
                                       withInset:kLabelHorizontalInsets
                                        relation:NSLayoutRelationGreaterThanOrEqual];
        self.content.font =  [UIFont systemFontOfSize:14];
        
        [self.time autoPinEdge:ALEdgeLeft
                        toEdge:ALEdgeRight
                        ofView:self.profile
                    withOffset:kLabelHorizontalInsets];
        [self.time autoPinEdge:ALEdgeTop
                        toEdge:ALEdgeBottom
                        ofView:self.content
                    withOffset:-5];
        [self.time autoPinEdgeToSuperviewEdge:ALEdgeRight
                                    withInset:kLabelHorizontalInsets
                                     relation:NSLayoutRelationGreaterThanOrEqual];

        
        
        [self.time autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kLabelVerticalInsets];

        
        [self.contentView setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0]];
    }
    
    
    
    self.didSetupConstraints = YES;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    if ([self.type isEqualToString:@"message"]) {
        CGRect frame = self.contentView.frame;
        frame.origin.x += 11;
        frame.size.width -= 22;
        frame.origin.y += 15;
        frame.size.height -= 15;
        
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
    else if ([self.type isEqualToString:@"comment"]){
        CGRect frame = self.contentView.frame;
        frame.origin.x += 11;
        frame.size.width -= 22;
        frame.origin.y += 1;
        frame.size.height -= 1;
        
        self.contentView.frame = frame;
        [self.contentView.layer setCornerRadius:1.0f];
        
        [self.contentView.layer setShadowColor:[UIColor colorWithWhite:0.000 alpha:0.100].CGColor];
        [self.contentView.layer setShadowOpacity:0.4];
        [self.contentView.layer setShadowRadius:2.0];
        [self.contentView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        
        [self.contentView setNeedsLayout];
        [self.contentView layoutIfNeeded];
        
        self.content.preferredMaxLayoutWidth = CGRectGetWidth(self.content.frame);

    }
    
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
