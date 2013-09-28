//
//  SHXAppDelegate.h
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <DropboxOSX/DropboxOSX.h>

@interface SHXAppDelegate : NSObject <NSApplicationDelegate> {
    DBRestClient *restClient;
}

- (IBAction)didPressLinkDropbox:(id)sender;

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSButton *linkButton;

@end
