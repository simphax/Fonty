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
    id <SHXISyncingManager> _fontSyncingManager;
    id <SHXISyncingManager> _fontCollectionsSyncingManager;
    //unsigned long _totalAddedFiles;
}
@end

@implementation SHXApplication

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setupLaunchAtLogin];
    
    BOOL isFirstTime = [self isFirstTime];
    
    //TODO Create iCloud folder
    
    //SHXLocalFolderCatalog *localFonts = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Library/Fonts"]];
    //SHXLocalFolderCatalog *remoteFonts = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Library/Mobile Documents/8F732M5KXK~com~simphax~Fonty/Fonts"]];
    
    SHXLocalFolderCatalog *localFonts = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/FilesLocal"]];
    SHXLocalFolderCatalog *remoteFonts = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/FilesRemote"]];
    
    _fontSyncingManager = [[SHXSyncingManager alloc] initWithCatalog:localFonts andCatalog:remoteFonts withDelegate:self asFirstTime:isFirstTime];

    //SHXLocalFolderCatalog *localFontCollections = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Library/FontCollections"]];
    //SHXLocalFolderCatalog *remoteFontCollections = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Library/Mobile Documents/8F732M5KXK~com~simphax~Fonty/FontCollections"]];
    //_fontCollectionsSyncingManager = [[SHXSyncingManager alloc] initWithCatalog:localFontCollections andCatalog:remoteFontCollections withDelegate:self asFirstTime:isFirstTime];
    
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

-(void) fileSyncingBegin:(id)sender
{
    
}

-(void) fileSyncingEnd:(id)sender
{
    
}

-(void) removedFiles:(NSArray *)files sender:(id)sender
{
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Fonty";
    
    NSString *message;
    if([files count] == 1)
    {
        message = [NSString stringWithFormat:@"Moved %lu File to the Trash", (unsigned long)[files count]];
    }
    else
    {
        message = [NSString stringWithFormat:@"Moved %lu Files to the Trash", (unsigned long)[files count]];
    }
    
    notification.informativeText = message;
    notification.soundName = nil;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

-(void) changedFiles:(NSArray *)files sender:(id)sender
{
    /*
    if([[[NSUserNotificationCenter defaultUserNotificationCenter] deliveredNotifications] count])
    {
        _totalAddedFiles += (unsigned long)[files count];
    }
    else
    {
        _totalAddedFiles = 0;
        _totalAddedFiles += (unsigned long)[files count];
    }
     */
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Fonty";
    
    NSString *message;
    if([files count] == 1)
    {
        message = [NSString stringWithFormat:@"Synced %lu File with iCloud", (unsigned long)[files count]];
    }
    else
    {
        message = [NSString stringWithFormat:@"Synced %lu Files with iCloud", (unsigned long)[files count]];
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
