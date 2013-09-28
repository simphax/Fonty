//
//  SHXTestingAppDelegate.m
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXTestingAppDelegate.h"

#import "SHXFolderFontCatalog.h"

@implementation SHXTestingAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _folderCatalog = [[SHXFolderFontCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/Fonts"]];
    [_folderCatalog setDelegate:self];
}

-(void)collectionModified:(id)sender
{
    NSLog(@"Collection modified, sender: %@",sender);
    NSLog(@"All items: %@",[_folderCatalog allFonts]);
}

@end
