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

static BOOL adding;
static BOOL deleting;

@interface SHXFolderFontCatalog() <SCEventListenerProtocol>
{
@private
    NSString *_path;
    SCEvents *_folderEvents;
    NSArray *_previousFileList;
}

@end

@implementation SHXFolderFontCatalog

@synthesize delegate;

-(id) initWithFolder:(NSString *)path {
    self = [super init];
    
    AcceptedExtensions = [NSArray arrayWithObjects:@"ttf",@"otf", nil];
    
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
    if(!(deleting || adding))
    {
        if(delegate){
            
            NSMutableArray *disappeared = [NSMutableArray arrayWithArray:_previousFileList];
            NSMutableArray *changed = [NSMutableArray arrayWithArray:newFileList];
            
            for(SHXLocalFont *font in _previousFileList)
            {
                for(SHXLocalFont *current in newFileList)
                {
                    if([[current relativePath] isEqual:[font relativePath]])
                    {
                        [disappeared removeObject:font];
                    }
                }
            }
            
            [changed removeObjectsInArray:_previousFileList];
            
            if([disappeared count])
            {
                [[self delegate] disappearedFonts:disappeared sender:self];
            }
            if([changed count])
            {
                [[self delegate] changedFonts:changed sender:self];
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

-(void)updateFonts:(NSArray *)fonts
{
    adding = TRUE;
    for(SHXLocalFont *font in fonts)
    {
        //NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:[font localPath] error: NULL];
        //if([attrs fileSize])
        //{
            NSLog(@"Copy %@ to %@",[font localPath],[NSString stringWithFormat:@"%@/%@",_path,[font relativePath]]);
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@",_path,[font relativePath]] error:nil];
            [[NSFileManager defaultManager] copyItemAtPath:[font localPath] toPath:[NSString stringWithFormat:@"%@/%@",_path,[font relativePath]] error:nil];
        /*
            NSURL* from = [NSURL fileURLWithPath:[font localPath]];
            NSURL* to = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",_path,[font relativePath]]];
        
            [[NSFileManager defaultManager] replaceItemAtURL:to withItemAtURL:from backupItemName:nil options:NSFileManagerItemReplacementUsingNewMetadataOnly resultingItemURL:nil error:nil];
         */
        //}
    }
    
    _previousFileList = [self allFonts];
    if(delegate)
    {
        [[self delegate] updatedFonts:fonts sender:self];
    }
    adding = FALSE;
}

-(void)deleteFonts:(NSArray *)fonts
{
    deleting = TRUE;
    
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
    deleting = FALSE;
}
@end
