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
    id <SHXISyncingManager> _fileManager;
}

@end

@implementation SHXTestingAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /*
    _folderCatalog = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/Files"]];
    [_folderCatalog setDelegate:self];
     */
    SHXLocalFolderCatalog *local = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/FilesLocal"]];
    SHXLocalFolderCatalog *remote = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/FilesRemote"]];
    
    _fileManager = [[SHXSyncingManager alloc] initWithCatalog:local andCatalog:remote withDelegate:self asFirstTime:YES];
}

- (IBAction)didPressSync:(id)sender
{
    //[_fileManager performMerge];
}

#pragma mark SHXICatalogDelegate

-(void)disappearedFiles:(NSArray *)files sender:(id)sender
{
    NSLog(@"Disappearing files: %@",files);
    NSLog(@"All items: %@",[_folderCatalog allFiles]);
}

-(void)appearedFiles:(NSArray *)files sender:(id)sender
{
    NSLog(@"Appearing files: %@",files);
    NSLog(@"All items: %@",[_folderCatalog allFiles]);
}

@end
