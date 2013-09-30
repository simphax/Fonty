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
    id <SHXICatalog> _localFontCatalog;
    id <SHXICatalog> _remoteFontCatalog;
}

@end

@implementation SHXSyncingManager

@synthesize delegate = _delegate;

-(id) initWithCatalog:(id <SHXICatalog>)local andCatalog:(id <SHXICatalog>)remote withDelegate:(id<SHXISyncingManagerDelegate>)delegate asFirstTime:(BOOL)first
{
    self = [super init];
    
    [self setDelegate:delegate];
    
    _localFontCatalog = local;
    _remoteFontCatalog = remote;
    
    if(first)
    {
        [self performMergeWith:_remoteFontCatalog and:_localFontCatalog];
    }
    else
    {
        [self performHardFetchFrom:_remoteFontCatalog to:_localFontCatalog];
    }
    
    [_localFontCatalog setDelegate:self];
    [_remoteFontCatalog setDelegate:self];
    
    return self;
}

-(NSArray *) activatedFonts
{
    return [_localFontCatalog allFonts];
}

-(void) performMergeWith:(id <SHXICatalog>)fromCatalog and:(id <SHXICatalog>)toCatalog
{
    if(_delegate)
    {
        [[self delegate] fontSyncingBegin:self];
    }
    
    NSArray *allLocalFonts = [fromCatalog allFonts];
    NSArray *allRemoteFonts = [toCatalog allFonts];
    NSMutableArray *addLocalList = [[NSMutableArray alloc] initWithArray:[toCatalog allFonts]];
    NSMutableArray *addRemoteList = [[NSMutableArray alloc] initWithArray:[fromCatalog allFonts]];
    
    [addLocalList removeObjectsInArray:allLocalFonts];
    [addRemoteList removeObjectsInArray:allRemoteFonts];
    
    NSLog(@"Add these to local: %@",addLocalList);
    NSLog(@"Add these to remote: %@",addRemoteList);
    if([addLocalList count])
    {
        NSLog(@"Add to %@: %@",fromCatalog,addLocalList);
        for(SHXFile *font in addLocalList)
        {
            if(![fromCatalog updateFont:font])
            {
                NSLog(@"Could not copy font %@",font);
            }
        }
    }
    if([addRemoteList count])
    {
        NSLog(@"Add to %@: %@",toCatalog,addRemoteList);
        for(SHXFile *font in addRemoteList)
        {
            if(![toCatalog updateFont:font])
            {
                NSLog(@"Could not copy font %@",font);
            }
        }
    }
    
    if(_delegate)
    {
        [[self delegate] fontSyncingEnd:self];
    }
}

-(void) performHardFetchFrom:(id <SHXICatalog>)fromCatalog to:(id <SHXICatalog>)toCatalog
{
    if(_delegate)
    {
        [[self delegate] fontSyncingBegin:self];
    }
    
    NSArray *allToFonts = [toCatalog allFonts];
    NSArray *allFromFonts = [fromCatalog allFonts];
    NSMutableArray *addList = [[NSMutableArray alloc] initWithArray:[fromCatalog allFonts]];
    NSMutableArray *deleteList = [[NSMutableArray alloc] initWithArray:[toCatalog allFonts]];
    
    [addList removeObjectsInArray:allToFonts];
    
    for(SHXLocalFile *font in [deleteList copy])
    {
        for(SHXLocalFile *current in allFromFonts)
        {
            if([[current relativePath] isEqual:[font relativePath]])
            {
                [deleteList removeObject:font];
            }
        }
    }
    
    if([addList count])
    {
        NSLog(@"Add to %@: %@",toCatalog,addList);
        for(SHXFile *font in addList)
        {
            if(![toCatalog updateFont:font])
            {
                NSLog(@"Could not copy font %@ to %@",font,toCatalog);
            }
        }
        
        if(toCatalog == _localFontCatalog)
        {
            if(_delegate && [addList count])
            {
                [[self delegate] changedFonts:addList sender:self];
            }
        }
    }
    if([deleteList count])
    {
        NSLog(@"Delete from %@: %@",toCatalog,deleteList);
        for(SHXFile *font in deleteList)
        {
            if(![toCatalog deleteFont:font])
            {
                NSLog(@"Could not delete font %@ in %@",font,toCatalog);
            }
        }
        
        if(toCatalog == _localFontCatalog)
        {
            if(_delegate && [deleteList count])
            {
                [[self delegate] removedFonts:deleteList sender:self];
            }
        }
        
    }
    
    if(_delegate)
    {
        [[self delegate] fontSyncingEnd:self];
    }
}

-(void)disappearedFonts:(NSArray *)fonts sender:(id)sender
{
    @synchronized([SHXSharedLock sharedSyncLock])
    {
        if([fonts count])
        {
            id <SHXICatalog> toBeSynced = sender == _localFontCatalog ? _remoteFontCatalog : _localFontCatalog;
            
            for(SHXFile *font in fonts)
            {
                if(![toBeSynced deleteFont:font])
                {
                    NSLog(@"Could not delete font %@ in %@",font,toBeSynced);
                }
            }
            
            if(toBeSynced == _localFontCatalog)
            {
                if(_delegate)
                {
                    [[self delegate] removedFonts:fonts sender:self];
                }
            }
        }
    }
}

-(void)changedFonts:(NSArray *)fonts sender:(id)sender
{
    @synchronized([SHXSharedLock sharedSyncLock])
    {
        if([fonts count])
        {
            id <SHXICatalog> toBeSynced = sender == _localFontCatalog ? _remoteFontCatalog : _localFontCatalog;
            for(SHXFile *font in fonts)
            {
                int retries = COPY_FONT_RETRIES;
                while(retries > 0 && ![toBeSynced updateFont:font])
                {
                    NSLog(@"Could not copy font %@ to %@ - Retrying...",font,toBeSynced);
                    [NSThread sleepForTimeInterval:0.01f];//Wait 0.01 seconds before retrying (this will halt the thread)
                    retries--;
                }
                
            }
            
            if(toBeSynced == _localFontCatalog)
            {
                if(_delegate)
                {
                    [[self delegate] changedFonts:fonts sender:self];
                }
            }
        }
    }
}
@end
