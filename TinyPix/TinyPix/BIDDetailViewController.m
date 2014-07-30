//
//  BIDDetailViewController.m
//  TinyPix
//
//  Created by Dexter Launchlabs on 7/30/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "BIDDetailViewController.h"

@interface BIDDetailViewController ()
@property (assign, nonatomic) NSUInteger selectedColorIndex;
- (void)configureView;
@end

@implementation BIDDetailViewController
@synthesize pixView = _pixView;
@synthesize selectedColorIndex;
- (void)setSelectedColorIndex:(NSUInteger)i { if (selectedColorIndex == i) return;
    selectedColorIndex = i; switch (selectedColorIndex) {
        case 0:
            self.pixView.highlightColor = [UIColor blackColor]; break;
        case 1:
            self.pixView.highlightColor = [UIColor redColor]; break;
        case 2:
            self.pixView.highlightColor = [UIColor greenColor]; break;
        default:
            break;
    }
    [self.pixView setNeedsDisplay]; }
#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        //self.detailDescriptionLabel.text = [self.detailItem description];
        self.pixView.document = self.detailItem;
        [self.pixView setNeedsDisplay];
    }
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.selectedColorIndex = [prefs integerForKey:@"selectedColorIndex"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}
- (void)viewDidUnload {
    [self setPixView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view. // e.g. self.myOutlet = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)chooseColor:(id)sender {
    NSInteger selectedColorIndex = [(UISegmentedControl *)sender
                                    selectedSegmentIndex]; NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:selectedColorIndex forKey:@"selectedColorIndex"]; }
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated]; UIDocument *doc = self.detailItem; [doc closeWithCompletionHandler:nil];
}
@end
