//
//  SHXTestingAppDelegate.m
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXTestingAppDelegate.h"

#import "SHXFolderFontCatalog.h"
#import "SHXFontManager.h"

@interface SHXTestingAppDelegate() <SHXIFontManagerDelegate>
{
    @private
    id <SHXIFontCatalog> _folderCatalog;
    id <SHXIFontManager> _fontManager;
}

@end

@implementation SHXTestingAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /*
    _folderCatalog = [[SHXFolderFontCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/Fonts"]];
    [_folderCatalog setDelegate:self];
     */
    SHXFolderFontCatalog *local = [[SHXFolderFontCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/FontsLocal"]];
    SHXFolderFontCatalog *remote = [[SHXFolderFontCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/FontsRemote"]];
    
    _fontManager = [[SHXFontManager alloc] initWithCatalog:local andCatalog:remote withDelegate:self asFirstTime:YES];
}

- (IBAction)didPressSync:(id)sender
{
    [_fontManager performMerge];
}

#pragma mark SHXIFontCatalogDelegate

-(void)disappearedFonts:(NSArray *)fonts sender:(id)sender
{
    NSLog(@"Disappearing fonts: %@",fonts);
    NSLog(@"All items: %@",[_folderCatalog allFonts]);
}

-(void)appearedFonts:(NSArray *)fonts sender:(id)sender
{
    NSLog(@"Appearing fonts: %@",fonts);
    NSLog(@"All items: %@",[_folderCatalog allFonts]);
}

@end
