//
//  RDZSleepViewController.m
//  nabudemo
//
//  Copyright (c) 2015 Razer. All rights reserved.
//

#import <NabuOpenSDK/NabuOpenSDK.h>
#import "RZDSleepViewController.h"

@interface RZDSleepViewController()

@property (nonatomic, strong) NabuSleepHistoryData *sleepData;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *efficiency;
@property (weak, nonatomic) IBOutlet UILabel *deepSleep;
@property (weak, nonatomic) IBOutlet UILabel *lightSleep;

@end


@implementation RZDSleepViewController

-(void)dealloc
{
    _sleepData = nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.sleepData = [NabuSleepHistoryData new];
    [self fetchSleepData];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

//-------------

#pragma mark - Actions

//-------------

- (IBAction)segmentChanged:(id)sender {
    [self fetchSleepData];
}

- (IBAction)datePickerChanged:(id)sender {
    [self fetchSleepData];
}

//-------------

#pragma mark - Populate Data

//-------------

-(void)fetchSleepData
{
    NSTimeInterval start = self.datePicker.date.timeIntervalSince1970;
    NSTimeInterval end;
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            end = start + 60 * 60 * 24;
            break;
        case 1:
            end = start + 60 * 60 * 24 * 7;
            break;
        case 2:
            end = start + 60 * 60 * 24 * 7 * 4;
            break;
            
        default:
            break;
    }
    
    self.sleepData.deepSleep = 0;
    self.sleepData.lightSleep = 0;
    self.sleepData.sleepEfficiency = 0;
    
    [[NabuDataManager sharedDataManager] getSleepHistoryDataWithStartTime:start endTime:end withCompletion:^(NSArray *arrayOfNabuSleepHistoryDataObjects, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for(NabuSleepHistoryData *currentObject in arrayOfNabuSleepHistoryDataObjects)
            {
                self.sleepData.deepSleep += currentObject.deepSleep;
                self.sleepData.lightSleep += currentObject.lightSleep;
                self.sleepData.sleepEfficiency += currentObject.sleepEfficiency;
            }
            
            [self.deepSleep setText:[NSString stringWithFormat:@"%li", self.sleepData.deepSleep]];
            [self.lightSleep setText:[NSString stringWithFormat:@"%li", self.sleepData.lightSleep]];
            [self.efficiency setText:[NSString stringWithFormat:@"%li", self.sleepData.sleepEfficiency]];
        });
    }];
}

@end
