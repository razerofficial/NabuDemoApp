//
//  RZDTableViewController.m
//  nabudemo
//
//  Copyright (c) 2015 Razer. All rights reserved.
//

#import "RZDTableViewController.h"

typedef enum : NSUInteger {
    kOrderFitness,
    kOrderSleep,
    kOrderNotification,
    kOrderPulsenHand,
    kOrderUserProfile,
    kOrderClipboard,
    kOrderAppAuth,
    kOrderBandList
} kOrder;

@interface RZDTableViewController() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *tableViewOptionsArray;
@property (nonatomic, strong) NSDictionary *tableViewOptionsDictionary;
@property (weak, nonatomic) IBOutlet UIImageView *poweredByImage;

@end

@implementation RZDTableViewController

-(void)dealloc
{
    _tableViewOptionsArray = nil;
    _tableViewOptionsDictionary = nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.poweredByImage setImage:[UIImage imageNamed:@"poweredByRazer"]];
    [self setupTableViewData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)setupTableViewData
{
    NSDictionary *tableViewOptionsDict = @{@(kOrderFitness) : @"Test Fitness Data",
                                           @(kOrderSleep) : @"Test Sleep Data",
                                           @(kOrderNotification) : @"Test Notification",
                                           @(kOrderPulsenHand) : @"Test Pulse and Handshake",
                                           @(kOrderUserProfile) : @"Test User Profile",
                                           @(kOrderClipboard) : @"Test Clipboard",
                                           @(kOrderAppAuth) : @"Test App Authentication",
                                           @(kOrderBandList) : @"Test Band List"};
    self.tableViewOptionsDictionary = tableViewOptionsDict;
    
    NSArray *orderArray = @[@(kOrderFitness),
                            @(kOrderSleep),
                            @(kOrderNotification),
                            @(kOrderPulsenHand),
                            @(kOrderUserProfile),
                            @(kOrderClipboard),
                            @(kOrderAppAuth),
                            @(kOrderBandList)];
    self.tableViewOptionsArray = orderArray;
    
    [self.tableView reloadData];
}

//-------------

#pragma mark - Table View Delegate and Data Source

//-------------

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *reusedCell = [tableView dequeueReusableCellWithIdentifier:@"kOptionsReuseIdentifier"];
    [reusedCell.textLabel setTextColor:[UIColor greenColor]];
    id currentItem = self.tableViewOptionsArray[indexPath.row];
    NSString *currentSelectedItem = self.tableViewOptionsDictionary[currentItem];
    [reusedCell.textLabel setText:currentSelectedItem];
    
    if ([reusedCell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [reusedCell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([reusedCell respondsToSelector:@selector(setLayoutMargins:)]) {
        [reusedCell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return reusedCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewOptionsArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int selectedItem = [self.tableViewOptionsArray[indexPath.row] intValue];
    switch (selectedItem) {
        case kOrderFitness:
                [self performSegueWithIdentifier:@"showFitnessView" sender:nil];
            break;
        case kOrderPulsenHand:
                [self performSegueWithIdentifier:@"showPulseHandshakeView" sender:nil];
            break;
        case kOrderUserProfile:
                [self performSegueWithIdentifier:@"showUserInfo" sender:nil];
            break;
        case kOrderNotification:
                [self performSegueWithIdentifier:@"showPostNotifications" sender:nil];
            break;
        case kOrderClipboard:
                [self performSegueWithIdentifier:@"showClipboardController" sender:nil];
            break;
        case kOrderBandList:
                [self performSegueWithIdentifier:@"showBandList" sender:nil];
            break;
        case kOrderAppAuth:
                [self performSegueWithIdentifier:@"showAppAuth" sender:nil];
            break;
        case kOrderSleep:
                 [self performSegueWithIdentifier:@"showSleepData" sender:nil];
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
