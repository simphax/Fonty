//
//  SHXSyncingManager.m
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXSyncingManager.h"
#import "SHXSharedLock.h"
#import "SHXLocalFile.h"

#define COPY_FONT_RETRIES 5

@interface SHXSyncingManager() <SHXICatalogDelegate>
{
    @private
    id <SHXICatalog> _localFileCatalog;
    id <SHXICatalog> _remoteFileCatalog;
}

@end

@implementation SHXSyncingManager

@synthesize delegate = _delegate;

-(id) initWithCatalog:(id <SHXICatalog>)local andCatalog:(id <SHXICatalog>)remote withDelegate:(id<SHXISyncingManagerDelegate>)delegate asFirstTime:(BOOL)first
{
    self = [super init];
    
    [self setDelegate:delegate];
    
    _localFileCatalog = local;
    _remoteFileCatalog = remote;
    
    if(first)
    {
        [self performMergeWith:_remoteFileCatalog and:_localFileCatalog];
    }
    else
    {
        [self performHardFetchFrom:_remoteFileCatalog to:_localFileCatalog];
    }
    
    [_localFileCatalog setDelegate:self];
    [_remoteFileCatalog setDelegate:self];
    
    return self;
}

-(NSArray *) activatedFiles
{
    return [_localFileCatalog allFiles];
}

-(void) performMerge
{
    [self performMergeWith:_remoteFileCatalog and:_localFileCatalog];
}

-(void) performHardFetch
{
    [self performHardFetchFrom:_remoteFileCatalog to:_localFileCatalog];
}

-(void) performMergeWith:(id <SHXICatalog>)fromCatalog and:(id <SHXICatalog>)toCatalog
{
    if(_delegate)
    {
        [[self delegate] fileSyncingBegin:self];
    }
    
    NSArray *allLocalFiles = [fromCatalog allFiles];
    NSArray *allRemoteFiles = [toCatalog allFiles];
    NSMutableArray *addLocalList = [[NSMutableArray alloc] initWithArray:[toCatalog allFiles]];
    NSMutableArray *addRemoteList = [[NSMutableArray alloc] initWithArray:[fromCatalog allFiles]];
    
    [addLocalList removeObjectsInArray:allLocalFiles];
    [addRemoteList removeObjectsInArray:allRemoteFiles];
    
    NSLog(@"Add these to local: %@",addLocalList);
    NSLog(@"Add these to remote: %@",addRemoteList);
    if([addLocalList count])
    {
        NSLog(@"Add to %@: %@",fromCatalog,addLocalList);
        for(SHXFile *file in addLocalList)
        {
            if(![fromCatalog updateFile:file])
            {
                NSLog(@"Could not copy file %@",file);
            }
        }
    }
    if([addRemoteList count])
    {
        NSLog(@"Add to %@: %@",toCatalog,addRemoteList);
        for(SHXFile *file in addRemoteList)
        {
            if(![toCatalog updateFile:file])
            {
                NSLog(@"Could not copy file %@",file);
            }
        }
    }
    
    if(_delegate)
    {
        [[self delegate] fileSyncingEnd:self];
    }
}

-(void) performHardFetchFrom:(id <SHXICatalog>)fromCatalog to:(id <SHXICatalog>)toCatalog
{
    if(_delegate)
    {
        [[self delegate] fileSyncingBegin:self];
    }
    
    NSArray *allToFiles = [toCatalog allFiles];
    NSArray *allFromFiles = [fromCatalog allFiles];
    NSMutableArray *addList = [[NSMutableArray alloc] initWithArray:[fromCatalog allFiles]];
    NSMutableArray *deleteList = [[NSMutableArray alloc] initWithArray:[toCatalog allFiles]];
    
    [addList removeObjectsInArray:allToFiles];
    
    for(SHXLocalFile *file in [deleteList copy])
    {
        for(SHXLocalFile *current in allFromFiles)
        {
            if([[current relativePath] isEqual:[file relativePath]])
            {
                [deleteList removeObject:file];
            }
        }
    }
    
    if([addList count])
    {
        NSLog(@"Add to %@: %@",toCatalog,addList);
        for(SHXFile *file in addList)
        {
            if(![toCatalog updateFile:file])
            {
                NSLog(@"Could not copy file %@ to %@",file,toCatalog);
            }
        }
        
        if(toCatalog == _localFileCatalog)
        {
            if(_delegate && [addList count])
            {
                [[self delegate] changedFiles:addList sender:self];
            }
        }
    }
    if([deleteList count])
    {
        NSLog(@"Delete from %@: %@",toCatalog,deleteList);
        for(SHXFile *file in deleteList)
        {
            if(![toCatalog deleteFile:file])
            {
                NSLog(@"Could not delete file %@ in %@",file,toCatalog);
            }
        }
        
        if(toCatalog == _localFileCatalog)
        {
            if(_delegate && [deleteList count])
            {
                [[self delegate] removedFiles:deleteList sender:self];
            }
        }
        
    }
    
    if(_delegate)
    {
        [[self delegate] fileSyncingEnd:self];
    }
}

-(void)disappearedFiles:(NSArray *)files sender:(id)sender
{
    @autoreleasepool
    {
        @synchronized([SHXSharedLock sharedSyncLock])
        {
            if([files count])
            {
                id <SHXICatalog> toBeSynced = sender == _localFileCatalog ? _remoteFileCatalog : _localFileCatalog;
                
                for(SHXFile *file in files)
                {
                    if(![toBeSynced deleteFile:file])
                    {
                        NSLog(@"Could not delete file %@ in %@",file,toBeSynced);
                    }
                }
                
                if(toBeSynced == _localFileCatalog)
                {
                    if(_delegate)
                    {
                        [[self delegate] removedFiles:files sender:self];
                    }
                }
            }
        }
    }
}

-(void)changedFiles:(NSArray *)files sender:(id)sender
{
    @autoreleasepool
    {
        @synchronized([SHXSharedLock sharedSyncLock])
        {
            if([files count])
            {
                id <SHXICatalog> toBeSynced = sender == _localFileCatalog ? _remoteFileCatalog : _localFileCatalog;
                for(SHXFile *file in files)
                {
                    int retries = COPY_FONT_RETRIES;
                    while(retries > 0 && ![toBeSynced updateFile:file])
                    {
                        NSLog(@"Could not copy file %@ to %@ - Retrying...",file,toBeSynced);
                        [NSThread sleepForTimeInterval:0.01f];//Wait 0.01 seconds before retrying (this will halt the thread)
                        retries--;
                    }
                    
                }
                
                if(toBeSynced == _localFileCatalog)
                {
                    if(_delegate)
                    {
                        [[self delegate] changedFiles:files sender:self];
                    }
                }
            }
        }
    }
}
@end
