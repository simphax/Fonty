//
//  SHXAppDelegate.m
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXAppDelegate.h"
#import <DropboxOSX/DropboxOSX.h>

@interface SHXAppDelegate () <DBRestClientDelegate>

- (DBRestClient *)restClient;

@property (nonatomic, retain) NSString *requestToken;

@end

@implementation SHXAppDelegate

@synthesize window = _window;
@synthesize linkButton = _linkButton;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *appKey = @"rqqi1wm1z7shm5h";
    NSString *appSecret = @"0zls4gzhj708w6u";
    NSString *root = kDBRootAppFolder; // Should be either kDBRootDropbox or kDBRootAppFolder
    DBSession *session = [[DBSession alloc] initWithAppKey:appKey appSecret:appSecret root:root];
    [DBSession setSharedSession:session];
    
    NSDictionary *plist = [[NSBundle mainBundle] infoDictionary];
    NSString *actualScheme = [[[[plist objectForKey:@"CFBundleURLTypes"] objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] objectAtIndex:0];
    NSString *desiredScheme = [NSString stringWithFormat:@"db-%@", appKey];
    NSString *alertText = nil;
    if ([appKey isEqual:@"APP_KEY"] || [appSecret isEqual:@"APP_SECRET"] || root == nil) {
        alertText = @"Fill in appKey, appSecret, and root in AppDelegate.m to use this app";
    } else if (![actualScheme isEqual:desiredScheme]) {
        alertText = [NSString stringWithFormat:@"Set the url scheme to %@ for the OAuth authorize page to work correctly", desiredScheme];
    }
    
    if (alertText) {
        NSAlert *alert = [NSAlert alertWithMessageText:nil defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", alertText];
        [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authHelperStateChangedNotification:) name:DBAuthHelperOSXStateChangedNotification object:[DBAuthHelperOSX sharedHelper]];
    [self updateLinkButton];
    
    NSAppleEventManager *em = [NSAppleEventManager sharedAppleEventManager];
    [em setEventHandler:self andSelector:@selector(getUrl:withReplyEvent:)
          forEventClass:kInternetEventClass andEventID:kAEGetURL];
    
}

- (void)getUrl:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
    // This gets called when the user clicks Show "App name". You don't need to do anything for Dropbox here
}

- (IBAction)didPressLinkDropbox:(id)sender {
    if ([[DBSession sharedSession] isLinked]) {
        // The link button turns into an unlink button when you're linked
        [[DBSession sharedSession] unlinkAll];
        restClient = nil;
        [self updateLinkButton];
    } else {
        [[DBAuthHelperOSX sharedHelper] authenticate];
    }
}

- (void)updateLinkButton {
    if ([[DBSession sharedSession] isLinked]) {
        self.linkButton.title = @"Unlink Dropbox";
    } else {
        self.linkButton.title = @"Link Dropbox";
        self.linkButton.state = [[DBAuthHelperOSX sharedHelper] isLoading] ? NSOffState : NSOnState;
    }
}

#pragma mark private methods

- (void)authHelperStateChangedNotification:(NSNotification *)notification {
    [self updateLinkButton];
    NSLog(@"state changed, is linked: %d",[[DBSession sharedSession] isLinked]);
}

- (DBRestClient *)restClient {
    if (!restClient) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

@end
