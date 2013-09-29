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

-(id) initWithCatalog:(id <SHXIFontCatalog>)local andCatalog:(id <SHXIFontCatalog>)remote
{
    self = [super init];
    _localFontCatalog = local;
    _remoteFontCatalog = remote;
    
    [self performManualSync];
    
    return self;
}

-(NSArray *) activatedFonts
{
    return [_localFontCatalog allFonts];
}

-(void) performManualSync
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
    [_localFontCatalog addFonts:addLocalList];
    [_remoteFontCatalog addFonts:addRemoteList];
    
    if(delegate)
    {
        [[self delegate] fontSyncingEnd:self];
    }
}

#pragma mark SHXIFontCatalogDelegate
-(void)deletedFonts:(NSArray *)fonts sender:(id)sender
{
    
}
-(void)addedFonts:(NSArray *)fonts sender:(id)sender
{
    
}

-(void)disappearedFonts:(NSArray *)fonts sender:(id)sender
{
    
}
-(void)appearedFonts:(NSArray *)fonts sender:(id)sender
{
    
}

@end
