//
//  SHXLocalFolderCatalog.m
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXLocalFolderCatalog.h"
#import <CDEvents/CDEvent.h>
#import <CDEvents/CDEvents.h>
#import <CDEvents/CDEventsDelegate.h>
#import "SHXLocalFile.h"
#import "NSFileManager+DirectoryLocations.h"
#import "SHXSharedLock.h"

@interface SHXLocalFolderCatalog() <CDEventsDelegate>
{
@private
    NSString *_path;
    CDEvents *_folderEvents;
    NSFileManager *_fileManager;
    NSArray *_previousFileList;
    NSArray *_allFiles;
    BOOL _deleting;
    BOOL _updating;
}

@end

@implementation SHXLocalFolderCatalog

@synthesize delegate = _delegate;

-(id) initWithFolder:(NSString *)path
{
    self = [super init];
    
    _path = path;
    
    _fileManager = [[NSFileManager alloc] init];
    
    NSLog(@"Creating folder %@: %hhd",path,[_fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil]);
    
    _previousFileList = [self allFiles];
    
    [self setupFolderEventListenerOnPath:_path];
    
    return self;
}

- (NSString *)description
{
    return _path;
}

- (void) setupFolderEventListenerOnPath:(NSString *)path
{
    if (_folderEvents) return;
    NSURL *url = [NSURL URLWithString:[self URLEncodeString:path]];
    NSMutableArray *urls = [NSMutableArray arrayWithObject:url];
    
    _folderEvents = [[CDEvents alloc] initWithURLs:urls delegate:self];
    
	NSLog(@"Watching folder %@ %@", path, [_folderEvents streamDescription]);
}

-(NSString *) myPathWithFile:(NSString *)file
{
    return [NSString stringWithString:[_path stringByAppendingPathComponent:file]];
}

-(NSString *) URLEncodeString:(NSString *) str
{
    NSMutableString *tempStr = [NSMutableString stringWithString:str];
    return [[NSString stringWithFormat:@"%@",tempStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(BOOL) isIncompleteFile:(NSString *)path
{
    NSDictionary *attrs = [_fileManager attributesOfItemAtPath:path error: NULL];
    return [[attrs fileCreationDate] timeIntervalSince1970] > 0;
}

-(void) handleFolderEvent:(CDEvent *)event
{
    @synchronized([SHXSharedLock sharedSyncLock])
    {
        NSArray *newFileList = [self allFiles];
        NSLog(@"Path %@ changed",_path);
        if(_delegate){
            
            NSMutableArray *disappeared = [NSMutableArray arrayWithArray:_previousFileList];
            NSMutableArray *changed = [NSMutableArray arrayWithArray:newFileList];
            
            [changed removeObjectsInArray:_previousFileList];
            
            for(SHXLocalFile *file in [disappeared copy])
            {
                for(SHXLocalFile *current in newFileList)
                {
                    if([[current relativePath] isEqual:[file relativePath]])
                    {
                        [disappeared removeObject:file];
                    }
                }
            }
            
            if([changed count])
            {
                [[self delegate] changedFiles:changed sender:self];
            }
            if([disappeared count])
            {
                [[self delegate] disappearedFiles:disappeared sender:self];
            }
        }
        _previousFileList = nil;
        _previousFileList = newFileList;
    }
}

#pragma mark CDEventsDelegate
- (void)URLWatcher:(CDEvents *)urlWatcher eventOccurred:(CDEvent *)event
{
    NSLog(@"Is main thread: %hhd",[NSThread isMainThread]);
    dispatch_async(dispatch_get_main_queue(), ^{

        [self handleFolderEvent:event];
        
    });
}

#pragma mark SHXICatalog

-(NSArray *)allFiles
{
    _allFiles = nil;
    @autoreleasepool
    {
        NSArray *allFiles = [_fileManager contentsOfDirectoryAtPath:_path error:nil];
        NSMutableArray *result = [[NSMutableArray alloc] init];
        for(NSString *aFile in allFiles){
            if([self isIncompleteFile:[self myPathWithFile:aFile]])//Do not add to the list if it seems incomplete (we are probably copying or downloading the file from somewhere)
            {
                @autoreleasepool
                {
                    SHXLocalFile *fileToAdd = [[SHXLocalFile alloc] initWithBase:_path relativePath:aFile];
                    [result addObject:fileToAdd];
                }
            }
        }
        _allFiles = [NSArray arrayWithArray:result];
    }
    return _allFiles;
}

-(BOOL)updateFile:(SHXFile *)file
{
    NSNumber *lock = [NSNumber numberWithUnsignedInteger:[file relativePath].hash]; //NSNumber are singeltons for equal values
    @synchronized(lock)
    {
        _updating = TRUE;
        SHXLocalFile *localFile = (SHXLocalFile *)file;
        NSLog(@"Copy %@ to %@",[localFile localPath],[self myPathWithFile:[file relativePath]]);
        [_fileManager removeItemAtPath:[self myPathWithFile:[file relativePath]] error:nil];
        BOOL result = [_fileManager copyItemAtPath:[localFile localPath] toPath:[self myPathWithFile:[file relativePath]] error:nil];
        _previousFileList = nil;
        _previousFileList = [self allFiles];
        _updating = FALSE;
        return result;
    }
}

-(BOOL)deleteFile:(SHXFile *)file
{
    NSNumber *lock = [NSNumber numberWithUnsignedInteger:[file relativePath].hash];
    @synchronized(lock)
    {
        _deleting = TRUE;
        SHXLocalFile *localFile = (SHXLocalFile *)file;
        NSLog(@"Move to trash %@",[localFile localPath]);
        NSURL* url = [NSURL fileURLWithPath:[self myPathWithFile:[file relativePath]]];
        BOOL result = [_fileManager trashItemAtURL:url resultingItemURL:nil error:nil];
        _previousFileList = nil;
        _previousFileList = [self allFiles];
        _deleting = FALSE;
        return result;
    }
}
@end
