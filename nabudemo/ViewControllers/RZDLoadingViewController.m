//
//  RZDLoadingViewController.m
//  nabudemo
//
//  Copyright (c) 2015 Razer. All rights reserved.
//

#import "RZDLoadingViewController.h"
#import <NabuOpenSDK/NabuOpenSDK.h>

@interface RZDLoadingViewController()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation RZDLoadingViewController

static NSString *key = @"872843df5d2266d413c749d1572a41f0a64b20be";

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self checkAndLoad];
}

-(void)checkAndLoad
{
    [self.activityIndicator startAnimating];
    [self.statusLabel setText:@"Authenticating"];
    [[NabuDataManager sharedDataManager] checkAppAuthorizationStatusWithCompletion:^(AuthenticationStatus status, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status != kAuthenticationStatusSuccess) {
                [self.statusLabel setText:@"Authentication Failed... Retrying Login"];
                NSURL *url = [[NabuDataManager sharedDataManager]
                              authorizationURLForAppID:key
                              andScope:@"fitness"
                              withAppURISchemeCallback:@"nabudemo"];
                if (url) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }else{
                [self successfullyLoadedAndAuthenticated];
            }
        });
    }];
}

//---------------

#pragma mark - Loading Options

//---------------

-(void)successfullyLoadedAndAuthenticated
{
    [self.activityIndicator stopAnimating];
    [self.statusLabel setText:@"Authentication Success"];
    
    [self performSegueWithIdentifier:@"showTableViewController" sender:nil];
}

-(void)failedToLoadAndAuthenticate
{
    UIAlertView *reloadAlert = [[UIAlertView alloc] initWithTitle:@"Failed to Authenticate"
                                                          message:@"Please reauthenticate with Nabu Utility"
                                                         delegate:self
                                                cancelButtonTitle:@"Re Authenticate"
                                                otherButtonTitles: nil];
    [reloadAlert show];
}

//---------------

#pragma mark - UIAlertView delegate methods

//---------------

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //we only have one option
    [self checkAndLoad];
}

@end
