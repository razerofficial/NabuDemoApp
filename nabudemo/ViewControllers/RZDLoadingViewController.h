//
//  RZDLoadingViewController.h
//  nabudemo
//
//  Copyright (c) 2015 Razer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RZDLoadingViewController : UIViewController

-(void)successfullyLoadedAndAuthenticated;
-(void)failedToLoadAndAuthenticate;

@end
