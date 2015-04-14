//
//  RDZPulseAndHandshakeViewController.m
//  nabudemo
//
//  Copyright (c) 2015 Razer. All rights reserved.
//

#import "RZDPulseAndHandshakeViewController.h"
#import <NabuOpenSDK/NabuOpenSDK.h>

@interface RZDPulseAndHandshakeViewController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *pulseTableView;
@property (weak, nonatomic) IBOutlet UITableView *handshakeTableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, strong) NSArray *arrayOfPulses;
@property (nonatomic, strong) NSArray *arrayOfHandshakes;

@end

@implementation RZDPulseAndHandshakeViewController

static NSString *pulseReuseIdentifier = @"pulseReuseIdentifier";
static NSString *handshakeReuseIdentifier = @"handshakeReuseIdentifier";

-(void)dealloc
{
    _arrayOfHandshakes = nil;
    _arrayOfPulses = nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

//-------------

#pragma mark - Update Table View

//-------------

-(void)reloadTableView
{
    NSDate *currentDate = self.datePicker.date;
    NSTimeInterval oneWeekBefore = currentDate.timeIntervalSince1970 - (60 * 60 * 24 * 7);
    
    [[NabuDataManager sharedDataManager] getHandshakeDataWithStartTime:oneWeekBefore endTime:currentDate.timeIntervalSince1970 withCompletion:^(NSArray *arrayOfHandshakes, NSError *error) {
        self.arrayOfHandshakes = arrayOfHandshakes;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.handshakeTableView reloadData];
        });
    }];
    
    [[NabuDataManager sharedDataManager] getPulseDataWithStartTime:oneWeekBefore endTime:currentDate.timeIntervalSince1970 withCompletion:^(NSArray *arrayOfPulses, NSError *error) {
        self.arrayOfPulses = arrayOfPulses;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pulseTableView reloadData];
        });
    }];
}

- (IBAction)didChangeDAte:(id)sender {
    [self reloadTableView];
}

//-------------

#pragma mark - Table View Delegate and Data Source

//-------------

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = nil;
    if (tableView == self.handshakeTableView) {
        tableCell = [tableView dequeueReusableCellWithIdentifier:handshakeReuseIdentifier];
        NSDictionary *currentItem = self.arrayOfHandshakes[indexPath.row];
        [tableCell.textLabel setText:currentItem[@"OpenID"]];
    }else if(tableView == self.pulseTableView) {
        tableCell = [tableView dequeueReusableCellWithIdentifier:pulseReuseIdentifier];
        NSDictionary *currentItem = self.arrayOfPulses[indexPath.row];
        NSArray *arrayOfOpenIDsinPulse = currentItem[@"OpenID"];
        [tableCell.textLabel setText:[arrayOfOpenIDsinPulse firstObject]];
    }
    
    if ([tableCell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [tableCell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([tableCell respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableCell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [tableCell.textLabel setTextColor: [UIColor greenColor]];
    [tableCell.textLabel setFont:[UIFont systemFontOfSize:9]];
    return tableCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.pulseTableView) {
        return self.arrayOfPulses.count;
    }else if(tableView == self.handshakeTableView){
        return self.arrayOfHandshakes.count;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.pulseTableView) {
        NSDictionary *currentItem = self.arrayOfPulses[indexPath.row];
        NSArray *arrayOfOpenIDsinPulse = currentItem[@"OpenID"];
        NSString *itemSelected = [arrayOfOpenIDsinPulse firstObject];
        
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:itemSelected];
        
    }else if (tableView == self.handshakeTableView)
    {
        NSDictionary *currentItem = self.arrayOfHandshakes[indexPath.row];
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:currentItem[@"OpenID"]];
    }
    
    UIAlertView *copyAlert = [[UIAlertView alloc] initWithTitle:@"Copied to Clipboard" message:@"OpenID has been copied to clipboard" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [copyAlert show];
}

@end
