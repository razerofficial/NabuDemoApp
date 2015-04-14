//
//  RDZNotificationTestViewController.m
//  nabudemo
//
//  Copyright (c) 2015 Razer. All rights reserved.
//

#import "RZDNotificationTestViewController.h"
#import <NabuOpenSDK/NabuOpenSDK.h>

@interface RZDNotificationTestViewController()

@property (weak, nonatomic) IBOutlet UITextField *notificationMessageField;

@end

@implementation RZDNotificationTestViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

//-------------

#pragma mark - Actions

//-------------

- (IBAction)sendNabuTest:(id)sender {
    NabuNotification *testNotification = [NabuNotification notificationWithMessage:self.notificationMessageField.text andIconResID:@"smiley"];
    [[NabuDataManager sharedDataManager] sendNotificationToBand:testNotification withCompletion:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Test Notification Sent Successfully" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [success show];
            }
        });
    }];
}

- (IBAction)sendLocalNotification:(id)sender {
    UILocalNotification *test = [UILocalNotification new];
    test.alertBody = self.notificationMessageField.text;
    test.alertTitle = @"Nabu Notification Test";
    [[UIApplication sharedApplication] scheduleLocalNotification:test];
    
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Nabu Notification Test" message:self.notificationMessageField.text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [success show];
}
@end
