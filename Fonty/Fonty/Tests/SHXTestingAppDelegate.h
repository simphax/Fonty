//
//  SHXTestingAppDelegate.h
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHXICatalog.h"

@interface SHXTestingAppDelegate : NSObject <NSApplicationDelegate>

- (IBAction)didPressSync:(id)sender;

@property (assign) IBOutlet NSWindow *window;

@end
