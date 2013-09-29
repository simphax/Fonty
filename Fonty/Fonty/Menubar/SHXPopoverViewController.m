//
//  SHXPopoverViewController.m
//  Fonty
//
//  Created by Simon on 2013-09-29.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXPopoverViewController.h"

@interface SHXPopoverViewController ()

@end

@implementation SHXPopoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (IBAction)didPressQuitButton:(id)sender
{
    [[NSApplication sharedApplication] terminate:nil];
}

@end
