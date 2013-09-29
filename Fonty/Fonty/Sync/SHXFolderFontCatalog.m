//
//  SHXFolderFontCatalog.m
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXFolderFontCatalog.h"
#import "SCEvents.h"
#import "SCEvent.h"
#import "SHXLocalFont.h"
#import "NSFileManager+DirectoryLocations.h"

static NSArray *AcceptedExtensions;

@interface SHXFolderFontCatalog() <SCEventListenerProtocol>
{
    @private
    NSString *_path;
    SCEvents *_folderEvents;
    NSArray *_previousFileList;
    BOOL _adding;
    BOOL _deleting;
}

@end

@implementation SHXFolderFontCatalog

@synthesize delegate;

-(id) initWithFolder:(NSString *)path {
    self = [super init];
    
    AcceptedExtensions = [NSArray arrayWithObjects:@"ttf", nil];
    
    NSLog(@"Creating folder %@: %hhd",path,[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil]);
    
    _path = path;
    _previousFileList = [self allFonts];
    
    [self setupFolderEventListenerOnPath:_path];
    
    return self;
}

- (void) setupFolderEventListenerOnPath:(NSString *)path {
    if (_folderEvents) return;
	
    _folderEvents = [[SCEvents alloc] init];
    
    [_folderEvents setDelegate:self];
    
    NSMutableArray *paths = [NSMutableArray arrayWithObject:path];
    
	[_folderEvents startWatchingPaths:paths];
    
	// Display a description of the stream
	NSLog(@"Watching folder %@ %@", path, [_folderEvents streamDescription]);
}

#pragma mark SCEventListenerProtocol
- (void)pathWatcher:(SCEvents *)pathWatcher eventOccurred:(SCEvent *)event
{
    NSLog(@"Folder event: %@", event);
    
    
    NSArray *newFileList = [self allFonts];
    if(!(_deleting || _adding))
    {
        if(delegate){
            
            NSMutableArray *disappeared = [NSMutableArray arrayWithArray:_previousFileList];
            NSMutableArray *appeared = [NSMutableArray arrayWithArray:newFileList];
            
            [disappeared removeObjectsInArray:newFileList];
            [appeared removeObjectsInArray:_previousFileList];
            
            if([disappeared count])
            {
                [[self delegate] disappearedFonts:disappeared sender:self];
            }
            if([appeared count])
            {
                [[self delegate] appearedFonts:appeared sender:self];
            }
        }
    }
    _previousFileList = newFileList;
}
 
#pragma mark SHXIFontCatalog

-(NSArray *)allFonts{
    NSArray *allFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_path error:nil];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(NSString *aFile in allFiles){
        if ([AcceptedExtensions containsObject:[aFile pathExtension]])
        {
            // Found Image File
            [result addObject:[[SHXLocalFont alloc] initWithBase:_path relativePath:aFile]];
        }
    }
    return [[NSArray alloc] initWithArray:result];//Return immutable array
}

-(void)addFonts:(NSArray *)fonts
{
    _adding = TRUE;
    for(SHXLocalFont *font in fonts)
    {
        NSLog(@"Copy %@ to %@",[font localPath],[NSString stringWithFormat:@"%@/%@",_path,[font relativePath]]);
        [[NSFileManager defaultManager] copyItemAtPath:[font localPath] toPath:[NSString stringWithFormat:@"%@/%@",_path,[font relativePath]] error:nil];
    }
    
    _previousFileList = [self allFonts];
    if(delegate)
    {
        [[self delegate] addedFonts:fonts sender:self];
    }
    _adding = FALSE;
}

-(void)deleteFonts:(NSArray *)fonts
{
    _deleting = TRUE;
    
    for(SHXLocalFont *font in fonts)
    {
        NSLog(@"Move to trash %@",[font relativePath]);
        
        NSURL* url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",_path,[font relativePath]]];
        
        [[NSFileManager defaultManager] trashItemAtURL:url resultingItemURL:nil error:nil];
    }
    
    _previousFileList = [self allFonts];
    if(delegate)
    {
        [[self delegate] deletedFonts:fonts sender:self];
    }
    _deleting = FALSE;
}
@end
