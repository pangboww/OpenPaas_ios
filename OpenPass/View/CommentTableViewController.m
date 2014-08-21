//
//  CommentTableViewController.m
//  OpenPass
//
//  Created by PangBo on 18/07/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import "CommentTableViewController.h"

@interface CommentTableViewController ()

@property (strong, nonatomic) UIView *container;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) RDRStickyKeyboardView *contentWrapper;

@end

@implementation CommentTableViewController


#pragma mark - View lifecycle


- (void)loadView
{
    [super loadView];
    
    [self _setupSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self.tabBarController isKindOfClass:[TabBarController class]]) {
        self.user = ((TabBarController *)self.tabBarController).user;
        self.basePath = ((TabBarController *)self.tabBarController).basePath;
        self.security = ((TabBarController *)self.tabBarController).security;
    }
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.25 green:0.27 blue:0.32 alpha:1.000];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark - Private

- (void)_setupSubviews
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect.origin.y += self.navigationController.navigationBar.frame.size.height;
    rect.origin.y += [UIApplication sharedApplication].statusBarFrame.size.height;
    rect.size.height -= self.navigationController.navigationBar.frame.size.height;
    rect.size.height -= [UIApplication sharedApplication].statusBarFrame.size.height;
    self.container = [[UIView alloc] initWithFrame:rect];

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                  style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth
    |UIViewAutoresizingFlexibleHeight;
    [self.tableView registerClass:[CommentTableViewCell class]
           forCellReuseIdentifier:@"Comment"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsSelection = NO;
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.87 green:0.88 blue:0.89 alpha:1.0]];
    // Setup wrapper
    self.contentWrapper = [[RDRStickyKeyboardView alloc] initWithScrollView:self.tableView];
    self.contentWrapper.frame = self.container.bounds;

    self.contentWrapper.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.contentWrapper.tintColor = [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
    self.contentWrapper.inputView.backgroundColor = [UIColor colorWithRed:0.87 green:0.88 blue:0.91 alpha:1.000];
    
    self.contentWrapper.inputView.delegate = self;
    
    [self.container addSubview:self.contentWrapper];
    [self.view addSubview:self.container];
    

}

- (void)refreshTableView
{
    [self.tableView reloadData];
    [self.tableView updateConstraints];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + self.messageContent.replies.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Comment"
                                                            forIndexPath:indexPath];

    if (indexPath.row == 0) {
        cell.type = @"message";
        
        cell.name.text = self.messageContent.author;
        cell.time.text = [OPTimeTool convertDate:self.messageContent.date];
        cell.content.text = self.messageContent.content;
    }
    else {
        cell.type = @"comment";
        
        NSDictionary *author = self.messageContent.replies[indexPath.row - 1][@"author"];
        cell.name.text = [NSString stringWithFormat:@"%@ %@", author[@"firstname"], author[@"lastname"]];
        cell.time.text = [OPTimeTool convertDate:self.messageContent.replies[indexPath.row - 1][@"published"]];
        cell.content.text = self.messageContent.replies[indexPath.row - 1][@"content"];
    }

    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentTableViewCell *cell = [[CommentTableViewCell alloc]init];

    if (indexPath.row == 0) {
        cell.type = @"message";
        
        cell.name.text = self.messageContent.author;
        cell.time.text = [OPTimeTool convertDate:self.messageContent.date];
        cell.content.text = self.messageContent.content;
    }
    else {
        cell.type = @"comment";
        
        NSDictionary *author = self.messageContent.replies[indexPath.row - 1][@"author"];
        cell.name.text = [NSString stringWithFormat:@"%@ %@", author[@"firstname"], author[@"lastname"]];
        cell.time.text = [OPTimeTool convertDate:self.messageContent.replies[indexPath.row - 1][@"published"]];
        cell.content.text = self.messageContent.replies[indexPath.row - 1][@"content"];
    }

    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(tableView.bounds), CGRectGetHeight(cell.bounds));
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    height += 15;
    return height;
}


- (void)didClickSendButton
{
    if (self.contentWrapper.inputView.textView.text.length == 0) return;
    
    NSString *text = self.contentWrapper.inputView.textView.text;
    
    SBJson4Writer *writer = [[SBJson4Writer alloc] init];
    
    NSDictionary *command = @{
                              @"inReplyTo":@{@"objectType": @"whatsupmessage",
                                             @"_id": self.messageContent.messageID//whatsup uuid
                                            },
                              @"object": @{@"objectType": @"whatsup",
                                           @"description": text}
                              };
    NSString *jsonCommand = [writer stringWithObject:command];
    OPPostRequest *nr = [[OPPostRequest alloc] initWithBaseUrl:@"localhost:8080/api/messages" andSecurity:NO andName:@"newComment"];
    [nr setContent:jsonCommand];
    nr.isJsonType = YES;
    [nr request];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
