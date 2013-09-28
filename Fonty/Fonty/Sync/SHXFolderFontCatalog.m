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

static NSArray *AcceptedExtensions;

@implementation SHXFolderFontCatalog

@synthesize delegate;

-(id) initWithFolder:(NSString *)path {
    self = [super init];
    
    AcceptedExtensions = [NSArray arrayWithObjects:@"ttf", nil];
    
    _path = path;
    
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
    
    if(delegate){
        [[self delegate] collectionModified:self];
    }
}
 
#pragma mark SHXIFontCatalog

-(NSArray *)allFonts{
    NSArray *allFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:_path error:nil];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for(NSString *aFile in allFiles){
        if ([AcceptedExtensions containsObject:[aFile pathExtension]])
        {
            // Found Image File
            [result addObject:aFile];
        }
    }
    return result;
}

@end
