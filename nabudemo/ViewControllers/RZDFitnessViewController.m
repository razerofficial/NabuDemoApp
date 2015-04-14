//
//  RZDFitnessViewController.m
//  nabudemo
//
//  Copyright (c) 2015 Razer. All rights reserved.
//

#import "RZDFitnessViewController.h"
#import <NabuOpenSDK/NabuOpenSDK.h>

@interface RZDFitnessViewController()

@property (nonatomic, strong) NabuFitnessData *fitnessData;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegment;
@property (weak, nonatomic) IBOutlet UILabel *steps;
@property (weak, nonatomic) IBOutlet UILabel *calories;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@end

@implementation RZDFitnessViewController

-(void)dealloc
{
    _fitnessData = nil;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.fitnessData = [NabuFitnessData new];
    [self fetchFitnessData];
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
    [self fetchFitnessData];
}

- (IBAction)dateChanged:(id)sender {
    [self fetchFitnessData];
}

//-------------

#pragma mark - Populate Data

//-------------

-(void)fetchFitnessData
{
    NSTimeInterval start = self.datePicker.date.timeIntervalSince1970;
    NSTimeInterval end;
    
    switch (self.typeSegment.selectedSegmentIndex) {
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
    
    self.fitnessData.steps = 0;
    self.fitnessData.distanceWalked = 0;
    self.fitnessData.calories = 0;
    self.fitnessData.floorClimbed = 0;

    [[NabuDataManager sharedDataManager] getFitnessDataWithStartTime:start endTime:end withCompletion:^(NSArray *arrayOfNabuFitnessData, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for(NabuFitnessData *currentObject in arrayOfNabuFitnessData)
            {
                self.fitnessData.steps += currentObject.steps;
                self.fitnessData.distanceWalked += currentObject.distanceWalked;
                self.fitnessData.calories += currentObject.calories;
                self.fitnessData.floorClimbed += currentObject.floorClimbed;
            }
            
            [self.steps setText:[NSString stringWithFormat:@"%li", self.fitnessData.steps]];
            [self.distance setText:[NSString stringWithFormat:@"%li", self.fitnessData.distanceWalked]];
            [self.calories setText:[NSString stringWithFormat:@"%li", self.fitnessData.calories]];
        });
    }];
}

@end
