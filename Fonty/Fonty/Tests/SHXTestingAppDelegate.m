//
//  SHXTestingAppDelegate.m
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXTestingAppDelegate.h"

#import "SHXFolderFontCatalog.h"

@interface SHXTestingAppDelegate()
{
    @private
    id <SHXIFontCatalog> _folderCatalog;
}

@end

@implementation SHXTestingAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _folderCatalog = [[SHXFolderFontCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/Fonts"]];
    [_folderCatalog setDelegate:self];
}


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
