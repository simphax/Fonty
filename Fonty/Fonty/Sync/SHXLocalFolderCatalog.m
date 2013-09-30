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
    BOOL _deleting;
    BOOL _updating;
}

@end

@implementation SHXLocalFolderCatalog

@synthesize delegate = _delegate;

-(id) initWithFolder:(NSString *)path
{
    self = [super init];
    
    NSLog(@"Creating folder %@: %hhd",path,[_fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil]);
    
    _path = path;
    
    _fileManager = [[NSFileManager alloc] init];
    
    _previousFileList = [self allFonts];
    
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
    return [NSString stringWithFormat:@"%@/%@",_path,file];
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

#pragma mark CDEventsDelegate
- (void)URLWatcher:(CDEvents *)urlWatcher eventOccurred:(CDEvent *)event
{
    @synchronized([SHXSharedLock sharedSyncLock])
    {
        NSArray *newFileList = [self allFonts];
        NSLog(@"Path %@ changed",_path);
        if(_delegate){
            
            NSMutableArray *disappeared = [NSMutableArray arrayWithArray:_previousFileList];
            NSMutableArray *changed = [NSMutableArray arrayWithArray:newFileList];
            
            [changed removeObjectsInArray:_previousFileList];
            
            for(SHXLocalFile *font in [disappeared copy])
            {
                for(SHXLocalFile *current in newFileList)
                {
                    if([[current relativePath] isEqual:[font relativePath]])
                    {
                        [disappeared removeObject:font];
                    }
                }
            }
            
            if([changed count])
            {
                [[self delegate] changedFonts:changed sender:self];
            }
            if([disappeared count])
            {
                [[self delegate] disappearedFonts:disappeared sender:self];
            }
        }
        _previousFileList = newFileList;
    }
}

#pragma mark SHXICatalog

-(NSArray *)allFonts
{
    NSArray *allFiles = [_fileManager contentsOfDirectoryAtPath:_path error:nil];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(NSString *aFile in allFiles){
        if([self isIncompleteFile:[self myPathWithFile:aFile]])//Do not add to the list if it seems incomplete (we are probably copying or downloading the file from somewhere)
        {
            NSDictionary *attrs = [_fileManager attributesOfItemAtPath:aFile error: NULL];
            NSNumber *hash = [NSNumber numberWithUnsignedLongLong:[attrs fileSize]];
            
            [result addObject:[[SHXLocalFile alloc] initWithBase:_path relativePath:aFile hash:hash]];
        }
    }
    return result;
}

-(BOOL)updateFont:(SHXFile *)font
{
    NSNumber *lock = [NSNumber numberWithUnsignedInteger:[font relativePath].hash]; //NSNumber are singeltons for equal values
    @synchronized(lock)
    {
        _updating = TRUE;
        SHXLocalFile *localFont = (SHXLocalFile *)font;
        NSLog(@"Copy %@ to %@",[localFont localPath],[self myPathWithFile:[font relativePath]]);
        [_fileManager removeItemAtPath:[self myPathWithFile:[font relativePath]] error:nil];
        BOOL result = [_fileManager copyItemAtPath:[localFont localPath] toPath:[self myPathWithFile:[font relativePath]] error:nil];
        _previousFileList = [self allFonts];
        _updating = FALSE;
        return result;
    }
}

-(BOOL)deleteFont:(SHXFile *)font
{
    NSNumber *lock = [NSNumber numberWithUnsignedInteger:[font relativePath].hash];
    @synchronized(lock)
    {
        _deleting = TRUE;
        SHXLocalFile *localFont = (SHXLocalFile *)font;
        NSLog(@"Move to trash %@",[localFont localPath]);
        NSURL* url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",_path,[font relativePath]]];
        BOOL result = [_fileManager trashItemAtURL:url resultingItemURL:nil error:nil];
        _previousFileList = [self allFonts];
        _deleting = FALSE;
        return result;
    }
}
@end
