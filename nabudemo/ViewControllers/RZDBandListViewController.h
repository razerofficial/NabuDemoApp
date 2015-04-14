//
//  RDZBandListViewController.h
//  nabudemo
//
//  Copyright (c) 2015 Razer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RZDBandListViewController : UIViewController

@end

@interface RZDBandTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *bandID;
@property (nonatomic, weak) IBOutlet UILabel *bandSerial;
@property (nonatomic, weak) IBOutlet UILabel *bandType;

@end