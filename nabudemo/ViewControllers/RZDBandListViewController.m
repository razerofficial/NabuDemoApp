//
//  RDZBandListViewController.m
//  nabudemo
//
//  Copyright (c) 2015 Razer. All rights reserved.
//

#import "RZDBandListViewController.h"
#import <NabuOpenSDK/NabuOpenSDK.h>

@interface RZDBandListViewController() <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayOfBands;


@end

@implementation RZDBandListViewController

static NSString *bandListReuseIdentifier = @"kBandListReuseIdentifier";

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self getAndLoadBandData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}


-(void)getAndLoadBandData
{
    [[NabuDataManager sharedDataManager] getNabuBandListWithCompletion:^(NSArray *arrayOfNabuBands, NSError *error) {
       dispatch_async(dispatch_get_main_queue(), ^{
           self.arrayOfBands = arrayOfNabuBands;
           [self.tableView reloadData];
       });
    }];
}

//-------------

#pragma mark - Table View Delegate and Data Source

//-------------

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RZDBandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bandListReuseIdentifier];
    
    NabuBandData *band = self.arrayOfBands[indexPath.row];
    NSString *bandName = band.name ? band.name : @"No Name";
    
    [cell.name setText:bandName];
    [cell.bandID setText:band.bandId];
    [cell.bandSerial setText:band.serialNumber];
    
    if ([band.model rangeOfString:@"NabuX"].location != NSNotFound) {
        //set X for Nabu X
        [cell.bandType setText:@"X"];
    }else{
        //set O for Original
        [cell.bandType setText:@"O"];
    }
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfBands.count;
}

@end

@implementation RZDBandTableViewCell

@end
