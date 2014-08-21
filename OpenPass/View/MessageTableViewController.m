//
//  TableViewController.m
//  OpenPass
//
//  Created by PangBo on 11/07/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import "MessageTableViewController.h"

@interface MessageTableViewController ()


@property (strong, nonatomic) NSString *uuid;
@property (strong, nonatomic) OPMessageMapping *messageController;
@property (strong, nonatomic) NSMutableArray *messageData;

@property (nonatomic) CGFloat previousScrollViewYOffset;

@end

@implementation MessageTableViewController



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[WhatsupTableViewCell class] forCellReuseIdentifier:@"Whatsup"];

    [self.tableView addFooterWithTarget:self action:@selector(requestMoreMessages)];
    [self.tableView addHeaderWithTarget:self action:@selector(startRequestMessages)];
    if ([self.tabBarController isKindOfClass:[TabBarController class]]) {
        self.user = ((TabBarController *)self.tabBarController).user;
        self.basePath = ((TabBarController *)self.tabBarController).basePath;
        self.security = ((TabBarController *)self.tabBarController).security;
    }

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.25 green:0.27 blue:0.32 alpha:1.000];

    
    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:0.87 green:0.88 blue:0.91 alpha:1.000];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.allowsSelection = NO;
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.87 green:0.88 blue:0.89 alpha:1.0]];
    
    [self requestUUID];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveUUID:)
                                                 name:@"uuid"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUI:)
                                                 name:@"messageUpdated"
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)requestUUID
{
    OPGetRequest *requestUUID = [[OPGetRequest alloc] initWithBaseUrl:[[self.basePath stringByAppendingString:@"/api/domains/"] stringByAppendingString:self.user.domainId] andSecurity:self.security andName:@"uuid"];
    [requestUUID request];
}

- (void)didReceiveUUID:(NSNotification *)notification
{
    if ([notification.name  isEqualToString:@"uuid"]) {
        NSDictionary *recieveData = notification.userInfo;
        NSString *propertyWillUpdate = [[recieveData allKeys] firstObject];
        
        if ([propertyWillUpdate isEqualToString:@"responseContent"]) {
            
            NSError *jerror = nil;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:recieveData[@"responseContent"][@"data"]
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&jerror];
            
            self.uuid = dic[@"activity_stream"][@"uuid"];
            
            [self startRequestMessages];
            
        }
    }
}

- (void)startRequestMessages
{
    self.messageController = [[OPMessageMapping alloc] initWithBasePath:self.basePath andUUID:self.uuid];
    self.messageController.security = self.security;
    [self.messageController.data removeAllObjects];
    [self.messageData removeAllObjects];
    [self.messageController requestMoreMessage];
}

- (void)requestMoreMessages
{
    [self.messageController requestMoreMessage];
}


- (BOOL)fetchMessageData
{
    if ([self.messageData count]<[self.messageController.data count]) {
        for (NSInteger index = [self.messageData count]; index < [self.messageController.data count]; index++) {
            OPMessageContent *message = [[OPMessageContent alloc] init];
            
            message.messageID = self.messageController.data[index][@"_id"];
            message.author = [NSString stringWithFormat:@"%@ %@",self.messageController.data[index][@"author"][@"firstname"],self.messageController.data[index][@"author"][@"lastname"]];
            message.content = self.messageController.data[index][@"content"];
            message.date = self.messageController.data[index][@"published"];
            message.replies = self.messageController.data[index][@"responses"];
            
            [self.messageData addObject:message];
        }
        return YES;
    }
    else return NO;
}

- (void)updateUI:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"messageUpdated"]) {
        if ([self fetchMessageData]) {
            
            self.tableView.dataSource = self;
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            [self.tableView reloadData];
        }
        
    }
}


#pragma mark -
#pragma mark NewMessage


- (IBAction)newMessage:(UIBarButtonItem *)sender {
    YIPopupTextView* popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:@"New Whatsup..." maxCount:100 buttonStyle:YIPopupTextViewButtonStyleRightDone];
    popupTextView.delegate = self;
    popupTextView.caretShiftGestureEnabled = YES;   // default = NO
    //    popupTextView.text = self.textView.text;
    //popupTextView.editable = NO;                  // set editable=NO to show without keyboard
    
    //[popupTextView showInView:self.view];
    [popupTextView showInViewController:self]; // recommended, especially for iOS7
}

- (void)popupTextView:(YIPopupTextView*)textView willDismissWithText:(NSString*)text cancelled:(BOOL)cancelled{
    if (!cancelled) {
        SBJson4Writer *writer = [[SBJson4Writer alloc] init];
        NSDictionary *command = @{
                                  @"targets": @[
                                          @{
                                              @"objectType": @"activitystream",
                                              @"id": self.uuid
                                              }
                                          ],
                                  @"object": @{@"objectType": @"whatsupmessage",
                                               @"description": text}
                                  };
        NSString *jsonCommand = [writer stringWithObject:command];
        OPPostRequest *nr = [[OPPostRequest alloc] initWithBaseUrl:@"localhost:8080/api/messages" andSecurity:NO andName:@"newWhatsUp"];
        [nr setContent:jsonCommand];
        nr.isJsonType = YES;
        [nr request];
    }
}



#pragma mark - Table view data source

- (NSMutableArray *)messageData
{
    if (!_messageData) {
        _messageData = [[NSMutableArray alloc] init];
    }
    return _messageData;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageData.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WhatsupTableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"Whatsup"
                                    forIndexPath:indexPath];
    OPMessageContent *message = self.messageData[indexPath.row];
    cell.messageID = message.messageID;
    cell.name.text = message.author;
    cell.time.text = [OPTimeTool convertDate:message.date];
    cell.content.text = message.content;
    cell.number = indexPath.row;
    
    NSUInteger n = message.replies.count;
    if (n == 1) {
        cell.numberOfComment.text = @"1 comment";
    }
    else if (n > 1) {
        cell.numberOfComment.text = [NSString stringWithFormat:@"%lu comments", (unsigned long)n];
    }
    else {
        cell.numberOfComment.text = @"0 comment";
    }
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    cell.delegate = self;
    return cell;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WhatsupTableViewCell *cell = [[WhatsupTableViewCell alloc]init];

    OPMessageContent *message = self.messageData[indexPath.row];
    cell.messageID = message.messageID;
    cell.name.text = message.author;
    cell.time.text = [OPTimeTool convertDate:message.date];
    cell.content.text = message.content;
    
    NSUInteger n = message.replies.count;
    if (n == 1) {
        cell.numberOfComment.text = @"1 comment";
    }
    else if (n > 1) {
        cell.numberOfComment.text = [NSString stringWithFormat:@"%lu comments", (unsigned long)n];
    }
    else {
        cell.numberOfComment.text = @"0 comment";
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)pushToCommentView
{
    [self performSegueWithIdentifier:@"ShowComment" sender:self];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (![segue.identifier isEqualToString:@"ShowComment"]){
        return;
    }
    if (![segue.destinationViewController isKindOfClass:[CommentTableViewController class]]) {
        return;
    }
    CommentTableViewController *ctvc = segue.destinationViewController;
    ctvc.messageContent = self.messageData[self.numberOfMessageWillBePushed];
}

#pragma mark - NavigationBar

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGRect frame = self.navigationController.navigationBar.frame;
//    CGFloat size = frame.size.height - 21;
//    CGFloat framePercentageHidden = ((20 - frame.origin.y) / (frame.size.height - 1));
//    CGFloat scrollOffset = scrollView.contentOffset.y;
//    CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
//    CGFloat scrollHeight = scrollView.frame.size.height;
//    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
//    
//    if (scrollOffset <= -scrollView.contentInset.top) {
//        frame.origin.y = 20;
//    } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
//        frame.origin.y = -size;
//    } else {
//        frame.origin.y = MIN(20, MAX(-size, frame.origin.y - scrollDiff));
//    }
//    
//    [self.navigationController.navigationBar setFrame:frame];
//    [self updateBarButtonItems:(1 - framePercentageHidden)];
//    self.previousScrollViewYOffset = scrollOffset;
//}


- (void)stoppedScrolling
{
    CGRect frame = self.navigationController.navigationBar.frame;
    if (frame.origin.y < 20) {
        [self animateNavBarTo:-(frame.size.height - 21)];
    }
}

- (void)updateBarButtonItems:(CGFloat)alpha
{
    [self.navigationController.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        
        item.customView.alpha = alpha;
    }];

    [self.navigationController.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        
        item.customView.alpha = alpha;
    }];
    self.navigationController.navigationItem.titleView.alpha = alpha;
    self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
}

- (void)animateNavBarTo:(CGFloat)y
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.navigationController.navigationBar.frame;
        CGFloat alpha = (frame.origin.y >= y ? 0 : 1);
        frame.origin.y = y;
        [self.navigationController.navigationBar setFrame:frame];
        [self updateBarButtonItems:alpha];
    }];
}


@end
