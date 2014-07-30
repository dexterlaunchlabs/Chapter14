//
//  BIDTinyPixView.h
//  TinyPix
//
//  Created by Dexter Launchlabs on 7/30/14.
//  Copyright (c) 2014 Dexter Launchlabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BIDTinyPixDocument.h"
@interface BIDTinyPixView : UIView

@property (strong, nonatomic) BIDTinyPixDocument *document; @property (strong, nonatomic) UIColor *highlightColor;
@end
