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
#import "SHXLocalFile.h"

@interface SHXTestingAppDelegate() <SHXISyncingManagerDelegate>
{
    @private
    id <SHXICatalog> _localCatalog;
    id <SHXICatalog> _remoteCatalog;
    id <SHXISyncingManager> _fileManager;
    NSArray *_fileList;
}

@end

@implementation SHXTestingAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /*
    _folderCatalog = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/Files"]];
    [_folderCatalog setDelegate:self];
     */
    
    _localCatalog = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/FilesLocal"]];
    //_remoteCatalog = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/FilesRemote"]];
    
    
    //_fileManager = [[SHXSyncingManager alloc] initWithCatalog:_localCatalog andCatalog:_remoteCatalog withDelegate:self asFirstTime:YES];
    
}

- (IBAction)didPressSync:(id)sender
{
    for(int i=0; i<100; i++)
    {
        _fileList = [_localCatalog allFiles];
    }
    //[_fileManager performMerge];
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
    
}
-(void) changedFiles:(NSArray *)files sender:(id)sender
{
    
}

#pragma mark SHXICatalogDelegate

-(void)disappearedFiles:(NSArray *)files sender:(id)sender
{
    
}

-(void)appearedFiles:(NSArray *)files sender:(id)sender
{
    
}

@end
