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
    /*
    SHXLocalFolderCatalog *local = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/FilesLocal"]];
    SHXLocalFolderCatalog *remote = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/FilesRemote"]];
    
    _fileManager = [[SHXSyncingManager alloc] initWithCatalog:local andCatalog:remote withDelegate:self asFirstTime:YES];
     */
    SHXLocalFile *file0 = [[SHXLocalFile alloc] initWithBase:@"/Users/Simon/Desktop/Test" relativePath:@"not.ttf"];
    SHXLocalFile *file1 = [[SHXLocalFile alloc] initWithBase:@"/Users/Simon/Desktop/Test" relativePath:@"test.ttf"];
    SHXLocalFile *file2 = [[SHXLocalFile alloc] initWithBase:@"/Users/Simon/Desktop/Test2" relativePath:@"test.ttf"];
    SHXLocalFile *file3 = [[SHXLocalFile alloc] initWithBase:@"/Users/Simon/Desktop/Test2" relativePath:@"not.ttf"];
    SHXLocalFile *file4 = [[SHXLocalFile alloc] initWithBase:@"/Users/Simon/Desktop/Test2" relativePath:@"same.ttf"];
    
    NSLog(@"1. Should be true: %hhd",[file1 isEqual:file2]);
    NSLog(@"2. Should be true: %d",([file1 hash] == [file2 hash]));
    NSLog(@"2. File 1 MD5: %@",[file1 MD5]);
    NSLog(@"2. File 2 MD5: %@",[file2 MD5]);
    NSLog(@"2. File 4 MD5: %@",[file4 MD5]);
    NSLog(@"1. Should be false: %hhd",[file1 isEqual:file4]);
    NSLog(@"2. Should be false: %d",([file1 hash] == [file4 hash]));
    NSLog(@"2. Should be true: %d",([[file1 MD5] isEqual:[file2 MD5]]));
    NSLog(@"3. Should be false: %hhd",[file1 isEqual:file3]);
    NSLog(@"4. Should be false: %d",([file1 hash] == [file3 hash]));
    NSLog(@"5. Should be false: %hhd",[file0 isEqual:file3]);
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
