//
//  BIDMasterViewController.h
//  TinyPix
//
//  Created by Dexter Launchlabs on 7/30/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BIDMasterViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *colorControl; - (IBAction)chooseColor:(id)sender;
@end
