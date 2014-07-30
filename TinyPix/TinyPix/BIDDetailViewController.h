//
//  BIDDetailViewController.h
//  TinyPix
//
//  Created by Dexter Launchlabs on 7/30/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIDTinyPixView.h"
@interface BIDDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet BIDTinyPixView *pixView;
@end
