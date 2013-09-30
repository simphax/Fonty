//
//  SHXApplication.m
//  Fonty
//
//  Created by Simon on 2013-09-29.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXApplication.h"
#import "SHXStatusView.h"
#import "SHXSyncingManager.h"
#import "SHXLocalFolderCatalog.h"
#import "NSFileManager+DirectoryLocations.h"
#import "LaunchAtLoginController.h"

@interface SHXApplication() <SHXISyncingManagerDelegate, NSUserNotificationCenterDelegate>
{
    @private
    SHXStatusView *_statusView;
    id <SHXISyncingManager> _fontManager;
    //unsigned long _totalAddedFonts;
}
@end

@implementation SHXApplication

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setupLaunchAtLogin];
    
    SHXLocalFolderCatalog *local = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Library/Fonts"]];
    SHXLocalFolderCatalog *remote = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Library/Mobile Documents/8F732M5KXK~com~simphax~Fonty"]];

    _fontManager = [[SHXSyncingManager alloc] initWithCatalog:local andCatalog:remote withDelegate:self asFirstTime:[self isFirstTime]];
    
    _statusView = [[SHXStatusView alloc] init];
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
}

-(void)setupLaunchAtLogin
{
    LaunchAtLoginController *launchController = [[LaunchAtLoginController alloc] init];
    [launchController setLaunchAtLogin:YES];
}

-(BOOL)isFirstTime
{
    NSString *applicationSupportDirectory = [[NSFileManager defaultManager] applicationSupportDirectory];
    NSString *myPlistPath = [applicationSupportDirectory stringByAppendingPathComponent:@"settings.plist"];
    NSMutableDictionary *plist;
    if([[NSFileManager defaultManager] fileExistsAtPath:myPlistPath])
    {
        plist = [[NSMutableDictionary alloc] initWithContentsOfFile:myPlistPath];
    }
    if(!plist)
    {
        plist = [[NSMutableDictionary alloc] init];
    }
    
    BOOL firstTime = ![[plist objectForKey:@"Activated"] boolValue];
    [plist setObject:@"YES" forKey: @"Activated"];
    [plist writeToFile:myPlistPath atomically:YES];
    return firstTime;
}

#pragma mark SHXISyncingManagerDelegate

-(void) fontSyncingBegin:(id)sender
{
    
}

-(void) fontSyncingEnd:(id)sender
{
    
}

-(void) removedFonts:(NSArray *)fonts sender:(id)sender
{
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Fonty";
    
    NSString *message;
    if([fonts count] == 1)
    {
        message = [NSString stringWithFormat:@"Moved %lu Font to the Trash", (unsigned long)[fonts count]];
    }
    else
    {
        message = [NSString stringWithFormat:@"Moved %lu Fonts to the Trash", (unsigned long)[fonts count]];
    }
    
    notification.informativeText = message;
    notification.soundName = nil;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

-(void) changedFonts:(NSArray *)fonts sender:(id)sender
{
    /*
    if([[[NSUserNotificationCenter defaultUserNotificationCenter] deliveredNotifications] count])
    {
        _totalAddedFonts += (unsigned long)[fonts count];
    }
    else
    {
        _totalAddedFonts = 0;
        _totalAddedFonts += (unsigned long)[fonts count];
    }
     */
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Fonty";
    
    NSString *message;
    if([fonts count] == 1)
    {
        message = [NSString stringWithFormat:@"Synced %lu Font with iCloud", (unsigned long)[fonts count]];
    }
    else
    {
        message = [NSString stringWithFormat:@"Synced %lu Fonts with iCloud", (unsigned long)[fonts count]];
    }
    
    notification.informativeText = message;
    notification.soundName = nil;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

#pragma mark NSUserNotificationCenterDelegate
-(BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

@end
