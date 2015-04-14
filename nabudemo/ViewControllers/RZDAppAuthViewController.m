//
//  RDZAppAuthViewController.m
//  nabudemo
//
//  Copyright (c) 2015 Razer. All rights reserved.
//

#import "RZDAppAuthViewController.h"
#import <NabuOpenSDK/NabuOpenSDK.h>

@interface RZDAppAuthViewController()

@property (weak, nonatomic) IBOutlet UILabel *authStatusLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation RZDAppAuthViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshStatus:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

//-------------

#pragma mark - Actions

//-------------

- (IBAction)refreshStatus:(id)sender {
    [[NabuDataManager sharedDataManager] checkAppAuthorizationStatusWithCompletion:^(AuthenticationStatus status, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case kAuthenticationStatusFailure:
                        [self.authStatusLabel setText:[NSString stringWithFormat:@"Authentication Failed: %@", error.localizedDescription]];
                    break;
                case kAuthenticationStatusSuccess:
                        [self.authStatusLabel setText:@"Authenticated Successfully"];
                    break;
                case kAuthenticationStatusPermissionDeined:
                        [self.authStatusLabel setText:@"Permission Revoked"];
                    break;
                    
                default:
                    break;
            }
            [self updateTextView];
        });
    }];
}

//-------------

#pragma mark - Populate Data

//-------------

-(void)updateTextView
{
    BOOL isUtilityInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"rznabu"]];
    NSString *utilityStatusString = isUtilityInstalled ? @"YES": @"NO";
    NSString *textViewMessage = [NSString stringWithFormat:@"Utility Installed: %@", utilityStatusString];
    [self.textView setText:textViewMessage];
}

@end
