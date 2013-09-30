//
//  SHXFolderFontCatalog.m
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXFolderFontCatalog.h"
#import <CDEvents/CDEvent.h>
#import <CDEvents/CDEvents.h>
#import <CDEvents/CDEventsDelegate.h>
#import "SHXLocalFont.h"
#import "NSFileManager+DirectoryLocations.h"

@interface SHXFolderFontCatalog() <CDEventsDelegate>
{
@private
    NSString *_path;
    CDEvents *_folderEvents;
    NSFileManager *_fileManager;
    BOOL _deleting;
    BOOL _updating;
}

@end

@implementation SHXFolderFontCatalog

@synthesize delegate;

-(id) initWithFolder:(NSString *)path {
    self = [super init];
    
    NSLog(@"Creating folder %@: %hhd",path,[_fileManager createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil]);
    
    _path = path;
    
    _fileManager = [[NSFileManager alloc] init];
    
    [self setupFolderEventListenerOnPath:_path];
    
    return self;
}

- (NSString *)description {
    return _path;
}

- (void) setupFolderEventListenerOnPath:(NSString *)path {
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
    if(!_updating && !_deleting && ([event isCreated] || [event isRenamed] || [event isRemoved]))
    {
        NSLog(@"Path %@ changed",_path);
        if(delegate)
        {
            [delegate collectionChanged:self];
        }
    }
}

#pragma mark SHXIFontCatalog

-(NSArray *)allFonts{
    NSArray *allFiles = [_fileManager contentsOfDirectoryAtPath:_path error:nil];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(NSString *aFile in allFiles){
        if([self isIncompleteFile:[self myPathWithFile:aFile]])//Do not add to the list if it seems incomplete (we are probably copying or downloading the file from somewhere)
        {
            [result addObject:[[SHXLocalFont alloc] initWithBase:_path relativePath:aFile]];
        }
    }
    return [[NSArray alloc] initWithArray:result];//Return immutable array
}

-(BOOL)updateFont:(SHXFont *)font
{
    NSNumber *lock = [NSNumber numberWithUnsignedInteger:[font relativePath].hash]; //NSNumber are singeltons for equal values
    @synchronized(lock)
    {
        _updating = TRUE;
        SHXLocalFont *localFont = (SHXLocalFont *)font;
        NSLog(@"Copy %@ to %@",[localFont localPath],[self myPathWithFile:[font relativePath]]);
        [_fileManager removeItemAtPath:[self myPathWithFile:[font relativePath]] error:nil];
        BOOL result = [_fileManager copyItemAtPath:[localFont localPath] toPath:[self myPathWithFile:[font relativePath]] error:nil];
        _updating = FALSE;
        return result;
    }
}

-(BOOL)deleteFont:(SHXFont *)font
{
    NSNumber *lock = [NSNumber numberWithUnsignedInteger:[font relativePath].hash];
    @synchronized(lock)
    {
        _deleting = TRUE;
        SHXLocalFont *localFont = (SHXLocalFont *)font;
        NSLog(@"Move to trash %@",[localFont localPath]);
        NSURL* url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",_path,[font relativePath]]];
        BOOL result = [_fileManager trashItemAtURL:url resultingItemURL:nil error:nil];
        _deleting = FALSE;
        return result;
    }
}
@end
