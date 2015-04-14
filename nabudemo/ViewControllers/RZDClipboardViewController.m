//
//  RDZClipboardViewController.m
//  nabudemo
//
//  Copyright (c) 2015 Razer. All rights reserved.
//

#import "RZDClipboardViewController.h"
#import <NabuOpenSDK/NabuOpenSDK.h>
#import <NabuOpenSDK/NabuClipboardManager.h>

@interface RZDClipboardViewController()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *openID;

@end


@implementation RZDClipboardViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self writeDemoDatatoClipboard];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

//-------------

#pragma mark - Clipboard Functions

//-------------

-(void)writeDemoDatatoClipboard
{
    [NabuClipboardManager writePublicDictionary:@{@"Message" : @"Hello, Nabu World."} withPrivateDictionary:@{@"Secret Stash" : @"Shhhhh. Its a secret!"} toClipboardWithWriteMessage:@"Adding Demo Data" withCompletion:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!success) {
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:@"Unable to write demo data to clipboard"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }
        });
    }];
}

-(void)loadMyClipboard
{
    [NabuClipboardManager getClipboardForCurrentUserWithCompletion:^(NabuClipboardObject *clipboard, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
           if(!error)
           {
               NSDictionary *publicDict = [NSKeyedUnarchiver unarchiveObjectWithData:clipboard.publicData];
               NSDictionary *privateDict = [NSKeyedUnarchiver unarchiveObjectWithData:clipboard.privateData];
               [self.textView setText:[NSString stringWithFormat:@"Message: %@, \n\nPublic: %@, \n\nPrivate: %@", clipboard.message, publicDict, privateDict]];
           }
        });
    }];
}

-(void)loadUsersClipboardWithOpenID:(NSString *)openID
{
    [NabuClipboardManager getClipboardForUserWithOpenID:openID withCompletion:^(NabuClipboardObject *clipboard, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!error)
            {
                NSDictionary *publicDict = [NSKeyedUnarchiver unarchiveObjectWithData:clipboard.publicData];
                [self.textView setText:[NSString stringWithFormat:@"User's OpenID %@, \n\nPublic %@", clipboard.openID, publicDict]];
            }
        });
    }];
}

//-------------

#pragma mark - Actions

//-------------

- (IBAction)toggledSearch:(id)sender {
    UISegmentedControl *control = (UISegmentedControl *)sender;
    switch (control.selectedSegmentIndex) {
        case 0:
            //my clipboard
            [self loadMyClipboard];
            break;
        case 1:
            //users clipboard
            if ([self.openID.text isEqualToString:@""] || !self.openID.text) {
                control.selectedSegmentIndex = -1;
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:@"Need to input a openID to search for"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
            }else{
                [self loadUsersClipboardWithOpenID:self.openID.text];
            }
            
            break;
            
        default:
            break;
    }
}

@end
