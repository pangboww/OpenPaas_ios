//
//  LoginViewController.m
//  OpenPass
//
//  Created by PangBo on 23/06/14.
//  Copyright (c) 2014 LINAGORA. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *server;
@property (strong, nonatomic) IBOutlet UISwitch *security;
@property (strong, nonatomic) OPLogin *login;

@end

@implementation LoginViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(didReceiveLoginResponse:) name:@"loginResponse" object:nil];
}

- (void)didReceiveLoginResponse:(NSNotification *)notification
{
    
    if ([notification.name isEqualToString:@"loginResponse"]) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[OPNetworkActivityIndicator sharedActivityIndicator]stopActivity];
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        });
        NSString *result = notification.userInfo[@"loginResponse"];
        if ([result isEqualToString:@"successful"]) {
            
            [self didLoginSuccessful];
        }
        else if ([result isEqualToString:@"failed"]){
            [self didLoginFailed];
        }
    }
}

- (void)didLoginSuccessful
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"loginSuccessful" sender:self];
    });
}

- (void)didLoginFailed
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        UIAlertView *notPermitted = [[UIAlertView alloc] initWithTitle:@"Wrong!"
                                                               message:@"Please check your username or password to login again"
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
        [notPermitted show];
    });
    self.login = nil;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{    
    if ([segue.identifier isEqualToString:@"loginSuccessful"]) {
        if ([segue.destinationViewController isKindOfClass:[TabBarController class]]) {
            TabBarController *tbc = segue.destinationViewController;
            tbc.user = self.login.user;
            tbc.basePath = self.server.text;
            tbc.security = self.security.isOn;
        }
    }
}





- (IBAction)loginStart:(UIButton *)sender {
    
    [[OPNetworkActivityIndicator sharedActivityIndicator] startActivity];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.login = [[OPLogin alloc] initWithUsername:self.usernameTextField.text andPassword:self.passwordTextField.text andBasePath:self.server.text];
        self.login.security = self.security.isOn;
        [self.login start];
    });
}

-(void)dismissKeyboard {
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.server resignFirstResponder];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end


