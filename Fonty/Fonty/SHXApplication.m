//
//  SHXApplication.m
//  Fonty
//
//  Created by Simon on 2013-09-29.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXApplication.h"
#import "SHXStatusView.h"
#import "SHXFontManager.h"
#import "SHXFolderFontCatalog.h"

@interface SHXApplication() <SHXIFontManagerDelegate, NSUserNotificationCenterDelegate>
{
    @private
    SHXStatusView *_statusView;
    id <SHXIFontManager> _fontManager;
    //unsigned long _totalAddedFonts;
}
@end

@implementation SHXApplication

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    SHXFolderFontCatalog *local = [[SHXFolderFontCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Library/Fonts"]];
    SHXFolderFontCatalog *remote = [[SHXFolderFontCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Library/Mobile Documents/8F732M5KXK~com~simphax~Fonty"]];
    
    _fontManager = [[SHXFontManager alloc] initWithCatalog:local andCatalog:remote withDelegate:self asFirstTime:YES];
    
    _statusView = [[SHXStatusView alloc] init];
}

-(void) fontSyncingBegin:(id)sender
{
    
}

-(void) fontSyncingEnd:(id)sender
{
    
}

-(void) deletedFonts:(NSArray *)fonts sender:(id)sender
{
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Fonty";
    notification.informativeText = [NSString stringWithFormat:@"Deleted %lu fonts", (unsigned long)[fonts count]];
    notification.soundName = nil;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

-(void) addedFonts:(NSArray *)fonts sender:(id)sender
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
    notification.informativeText = [NSString stringWithFormat:@"Added %lu fonts", (unsigned long)[fonts count]];
    notification.soundName = nil;
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

@end
