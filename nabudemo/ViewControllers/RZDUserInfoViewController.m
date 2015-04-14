//
//  RDZUserInfoViewController.m
//  nabudemo
//
//  Copyright (c) 2015 Razer. All rights reserved.
//

#import "RZDUserInfoViewController.h"
#import <NabuOpenSDK/NabuOpenSDK.h>

typedef enum : NSUInteger {
    kUserInfoOrderUsername,
    kUserInfoOrderGender,
    kUserInfoOrderDateOfBirth,
    kUserInfoOrderHeight,
    kUserInfoOrderWeight,
    kUserInfoOrderSize  //number of items
} kUserInfoOrder;

@interface RZDUserInfoViewController() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *userInfoTableView;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (nonatomic, strong) NabuUserProfile *user;

@end

@implementation RZDUserInfoViewController

static NSString *kProfileCellIdentifier = @"kUserInfoReuseIdentifier";

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchProfile];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

//-------------

#pragma mark - Populate Data

//-------------

-(void)fetchProfile
{
    [[NabuDataManager sharedDataManager] getUserProfileWithCompletion:^(NabuUserProfile *user, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.user = user;
            if([user.avatar isEqualToString:@"Not Available"])
            {
                [self.userProfileImage setBackgroundColor:[UIColor greenColor]];
            }else{
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSURL *url = [NSURL URLWithString:user.avatar];
                    NSData *imageData = [NSData dataWithContentsOfURL:url];
                   dispatch_async(dispatch_get_main_queue(), ^{
                       if (imageData) {
                           UIImage *image = [UIImage imageWithData:imageData];
                           [self.userProfileImage setImage:image];
                       }
                   });
                });
            }
            [self.userInfoTableView reloadData];
        });
    }];
}

//-------------

#pragma mark - Table View Delegate and Data Source

//-------------

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *userInfoCell = [tableView dequeueReusableCellWithIdentifier:kProfileCellIdentifier];
    
    switch (indexPath.row) {
        case kUserInfoOrderUsername:
                [userInfoCell.textLabel setText:[NSString stringWithFormat:@"Name: %@", self.user.nickName]];
            break;
        case kUserInfoOrderGender:
                [userInfoCell.textLabel setText:[NSString stringWithFormat:@"Gender: %@", self.user.gender]];
            break;
        case kUserInfoOrderHeight:
        {
            if ([self.user.unit rangeOfString:@"imperial"].location != NSNotFound) {
                NSInteger preformattedHeight = [self.user.height integerValue];
                NSInteger feet = floor(preformattedHeight/12);
                NSInteger inches = preformattedHeight%12;
                [userInfoCell.textLabel setText:[NSString stringWithFormat:@"Height: %li\' %li\"", feet, inches]];
            }else if([self.user.unit rangeOfString:@"metric"].location != NSNotFound) {
                NSInteger preformattedHeight = [self.user.height integerValue];
                NSInteger meters = floor(preformattedHeight/100);
                NSInteger cm = preformattedHeight%100;
                [userInfoCell.textLabel setText:[NSString stringWithFormat:@"Height: %li m %li cm", meters, cm]];
            }
            
        }
            break;
        case kUserInfoOrderWeight:
            if ([self.user.unit rangeOfString:@"imperial"].location != NSNotFound) {
                NSInteger preformattedWeight = [self.user.weight integerValue];
                [userInfoCell.textLabel setText:[NSString stringWithFormat:@"Weight: %li lbs", preformattedWeight]];
            }else if([self.user.unit rangeOfString:@"metric"].location != NSNotFound) {
                NSInteger preformattedWeight = [self.user.weight integerValue];
                [userInfoCell.textLabel setText:[NSString stringWithFormat:@"Height: %li kg", preformattedWeight]];
            }
            break;
        case kUserInfoOrderDateOfBirth:
                [userInfoCell.textLabel setText:[NSString stringWithFormat:@"Date of Birth: %@/%@/%@", self.user.birthDay, self.user.birthMonth, self.user.birthYear]];
            break;

        default:
            break;
    }
    
    [userInfoCell.textLabel setTextColor:[UIColor greenColor]];
    
    if ([userInfoCell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [userInfoCell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([userInfoCell respondsToSelector:@selector(setLayoutMargins:)]) {
        [userInfoCell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return userInfoCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kUserInfoOrderSize;
}

@end
