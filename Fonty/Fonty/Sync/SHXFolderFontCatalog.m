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

static NSArray *AcceptedExtensions;

@interface SHXFolderFontCatalog() <CDEventsDelegate>
{
@private
    NSString *_path;
    CDEvents *_folderEvents;
}

@end

@implementation SHXFolderFontCatalog

@synthesize delegate;

-(id) initWithFolder:(NSString *)path {
    self = [super init];
    
    AcceptedExtensions = [NSArray arrayWithObjects:@"ttf",@"otf", nil];
    
    NSLog(@"Creating folder %@: %hhd",path,[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil]);
    
    _path = path;
    
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

-(NSString *) URLEncodeString:(NSString *) str
{
    NSMutableString *tempStr = [NSMutableString stringWithString:str];
    return [[NSString stringWithFormat:@"%@",tempStr] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark CDEventsDelegate
- (void)URLWatcher:(CDEvents *)urlWatcher eventOccurred:(CDEvent *)event
{
	NSLog(@"Path %@ changed",_path);
    if(delegate)
    {
        [delegate collectionChanged:self];
    }
}

#pragma mark SHXIFontCatalog

-(NSArray *)allFonts{
    NSArray *allFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_path error:nil];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(NSString *aFile in allFiles){
        //if ([AcceptedExtensions containsObject:[aFile pathExtension]])
        //{
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@",_path,aFile] error: NULL];
        if([attrs fileSize])//Do not add if the file is 0 bytes in size (means we are still copying)
        {
            [result addObject:[[SHXLocalFont alloc] initWithBase:_path relativePath:aFile]];
        }
        //}
    }
    return [[NSArray alloc] initWithArray:result];//Return immutable array
}

-(BOOL)updateFont:(SHXFont *)font
{
    @synchronized([font relativePath])
    {
        SHXLocalFont *localFont = (SHXLocalFont *)font;
        NSLog(@"Copy %@ to %@",[localFont localPath],[NSString stringWithFormat:@"%@/%@",_path,[font relativePath]]);
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",_path,[font relativePath]] error:nil];
        return [[NSFileManager defaultManager] copyItemAtPath:[localFont localPath] toPath:[NSString stringWithFormat:@"%@/%@",_path,[font relativePath]] error:nil];
    }
}

-(BOOL)deleteFont:(SHXFont *)font
{
    @synchronized([font relativePath])
    {
        SHXLocalFont *localFont = (SHXLocalFont *)font;
        NSLog(@"Move to trash %@",[localFont localPath]);
        NSURL* url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",_path,[font relativePath]]];
        return [[NSFileManager defaultManager] trashItemAtURL:url resultingItemURL:nil error:nil];
    }
}
@end
