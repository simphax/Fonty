//
//  SHXFontManager.m
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXFontManager.h"

@interface SHXFontManager() <SHXIFontCatalogDelegate>
{
    @private
    id <SHXIFontCatalog> _localFontCatalog;
    id <SHXIFontCatalog> _remoteFontCatalog;
}

@end

@implementation SHXFontManager

@synthesize delegate = _delegate;

-(id) initWithCatalog:(id <SHXIFontCatalog>)local andCatalog:(id <SHXIFontCatalog>)remote withDelegate:(id<SHXIFontManagerDelegate>)delegate asFirstTime:(BOOL)first
{
    self = [super init];
    
    _localFontCatalog = local;
    _remoteFontCatalog = remote;
    
    [_localFontCatalog setDelegate:self];
    [_remoteFontCatalog setDelegate:self];
    
    [self setDelegate:delegate];
    
    if(first)
    {
        [self performMergeWith:_remoteFontCatalog and:_localFontCatalog];
    }
    else
    {
        [self performHardFetchFrom:_remoteFontCatalog to:_localFontCatalog];
    }
    
    return self;
}

-(NSArray *) activatedFonts
{
    return [_localFontCatalog allFonts];
}

-(void) performMergeWith:(id <SHXIFontCatalog>)fromCatalog and:(id <SHXIFontCatalog>)toCatalog
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
        for(SHXFont *font in addLocalList)
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
        for(SHXFont *font in addRemoteList)
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

-(void) performHardFetchFrom:(id <SHXIFontCatalog>)fromCatalog to:(id <SHXIFontCatalog>)toCatalog
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
    [deleteList removeObjectsInArray:allFromFonts];
    
    if([addList count])
    {
        NSLog(@"Add to %@: %@",toCatalog,addList);
        for(SHXFont *font in addList)
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
        for(SHXFont *font in deleteList)
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

-(void)collectionChanged:(id)sender
{
    @synchronized(self)
    {
        id <SHXIFontCatalog> toBeSynced = sender == _localFontCatalog ? _remoteFontCatalog : _localFontCatalog;
        [self performHardFetchFrom:(id<SHXIFontCatalog>)sender to:toBeSynced];
    }
}
@end
