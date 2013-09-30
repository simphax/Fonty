//
//  SHXTestingAppDelegate.m
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXTestingAppDelegate.h"

#import "SHXLocalFolderCatalog.h"
#import "SHXSyncingManager.h"

@interface SHXTestingAppDelegate() <SHXISyncingManagerDelegate>
{
    @private
    id <SHXICatalog> _folderCatalog;
    id <SHXISyncingManager> _fontManager;
}

@end

@implementation SHXTestingAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /*
    _folderCatalog = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/Fonts"]];
    [_folderCatalog setDelegate:self];
     */
    SHXLocalFolderCatalog *local = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/FontsLocal"]];
    SHXLocalFolderCatalog *remote = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/FontsRemote"]];
    
    _fontManager = [[SHXSyncingManager alloc] initWithCatalog:local andCatalog:remote withDelegate:self asFirstTime:YES];
}

- (IBAction)didPressSync:(id)sender
{
    //[_fontManager performMerge];
}

#pragma mark SHXICatalogDelegate

-(void)disappearedFonts:(NSArray *)fonts sender:(id)sender
{
    NSLog(@"Disappearing fonts: %@",fonts);
    NSLog(@"All items: %@",[_folderCatalog allFonts]);
}

-(void)appearedFonts:(NSArray *)fonts sender:(id)sender
{
    NSLog(@"Appearing fonts: %@",fonts);
    NSLog(@"All items: %@",[_folderCatalog allFonts]);
}

@end
