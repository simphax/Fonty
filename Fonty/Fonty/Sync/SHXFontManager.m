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
        [self performMerge];
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

-(void) performMerge
{
    if(_delegate)
    {
        [[self delegate] fontSyncingBegin:self];
    }
    
    NSArray *allLocalFonts = [_localFontCatalog allFonts];
    NSArray *allRemoteFonts = [_remoteFontCatalog allFonts];
    NSMutableArray *addLocalList = [[NSMutableArray alloc] initWithArray:[_remoteFontCatalog allFonts]];
    NSMutableArray *addRemoteList = [[NSMutableArray alloc] initWithArray:[_localFontCatalog allFonts]];
    
    [addLocalList removeObjectsInArray:allLocalFonts];
    [addRemoteList removeObjectsInArray:allRemoteFonts];
    
    NSLog(@"Add these to local: %@",addLocalList);
    NSLog(@"Add these to remote: %@",addRemoteList);
    for(SHXFont *font in addLocalList)
    {
        if(![_localFontCatalog updateFont:font])
        {
            NSLog(@"Could not copy font %@",font);
        }
    }
    for(SHXFont *font in addRemoteList)
    {
        if(![_remoteFontCatalog updateFont:font])
        {
            NSLog(@"Could not copy font %@",font);
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
    
    NSArray *allLocalFonts = [toCatalog allFonts];
    NSArray *allRemoteFonts = [fromCatalog allFonts];
    NSMutableArray *addLocalList = [[NSMutableArray alloc] initWithArray:[fromCatalog allFonts]];
    NSMutableArray *deleteLocalList = [[NSMutableArray alloc] initWithArray:[toCatalog allFonts]];
    
    [addLocalList removeObjectsInArray:allLocalFonts];
    [deleteLocalList removeObjectsInArray:allRemoteFonts];
    
    for(SHXFont *font in addLocalList)
    {
        NSLog(@"Add to %@: %@",toCatalog,addLocalList);
        if(![toCatalog updateFont:font])
        {
            NSLog(@"Could not copy font %@ to %@",font,toCatalog);
        }
    }
    for(SHXFont *font in deleteLocalList)
    {
        NSLog(@"Delete from %@: %@",toCatalog,deleteLocalList);
        if(![toCatalog deleteFont:font])
        {
            NSLog(@"Could not delete font %@ in %@",font,toCatalog);
        }
    }
    
    if(_delegate)
    {
        [[self delegate] fontSyncingEnd:self];
    }
}

#pragma mark SHXIFontCatalogDelegate
/*
-(void)deletedFonts:(NSArray *)fonts sender:(id)sender
{
    if(sender == _localFontCatalog)
    {
        if(delegate && [fonts count])
        {
            [[self delegate] deletedFonts:fonts sender:self];
        }
    }
    NSLog(@"Deleted fonts %@",fonts);
}
-(void)updatedFonts:(NSArray *)fonts sender:(id)sender
{
    if(sender == _localFontCatalog)
    {
        if(delegate && [fonts count])
        {
            [[self delegate] changedFonts:fonts sender:self];
        }
    }
    NSLog(@"Updated fonts %@",fonts);
}

-(void)disappearedFonts:(NSArray *)fonts sender:(id)sender
{
    id <SHXIFontCatalog> toBeSynced = sender == _localFontCatalog ? _remoteFontCatalog : _localFontCatalog;
    
    [toBeSynced deleteFonts:fonts];
}
-(void)changedFonts:(NSArray *)fonts sender:(id)sender
{
    id <SHXIFontCatalog> toBeSynced = sender == _localFontCatalog ? _remoteFontCatalog : _localFontCatalog;
    
    [toBeSynced updateFonts:fonts];
}
*/

-(void)collectionChanged:(id)sender
{
    @synchronized(self)
    {
        id <SHXIFontCatalog> toBeSynced = sender == _localFontCatalog ? _remoteFontCatalog : _localFontCatalog;
        [self performHardFetchFrom:(id<SHXIFontCatalog>)sender to:(id<SHXIFontCatalog>)toBeSynced];
    }
}
@end
