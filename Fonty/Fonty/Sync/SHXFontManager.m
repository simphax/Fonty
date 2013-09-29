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

@synthesize delegate;

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
        [self performHardFetch];
    }
    
    return self;
}

-(NSArray *) activatedFonts
{
    return [_localFontCatalog allFonts];
}

-(void) performMerge
{
    if(delegate)
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
    [_localFontCatalog updateFonts:addLocalList];
    [_remoteFontCatalog updateFonts:addRemoteList];
    
    if(delegate)
    {
        [[self delegate] fontSyncingEnd:self];
    }
}

-(void) performHardFetch
{
    if(delegate)
    {
        [[self delegate] fontSyncingBegin:self];
    }
    
    NSArray *allLocalFonts = [_localFontCatalog allFonts];
    NSArray *allRemoteFonts = [_remoteFontCatalog allFonts];
    NSMutableArray *addLocalList = [[NSMutableArray alloc] initWithArray:[_remoteFontCatalog allFonts]];
    NSMutableArray *deleteLocalList = [[NSMutableArray alloc] initWithArray:[_localFontCatalog allFonts]];
    
    [addLocalList removeObjectsInArray:allLocalFonts];
    [deleteLocalList removeObjectsInArray:allRemoteFonts];
    
    NSLog(@"Add these to local: %@",addLocalList);
    NSLog(@"Delete these from local: %@",deleteLocalList);
    [_localFontCatalog updateFonts:addLocalList];
    [_localFontCatalog deleteFonts:deleteLocalList];
    
    if(delegate)
    {
        [[self delegate] fontSyncingEnd:self];
    }
}

#pragma mark SHXIFontCatalogDelegate
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

@end
