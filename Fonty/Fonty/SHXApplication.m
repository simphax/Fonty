//
//  SHXApplication.m
//  Fonty
//
//  Created by Simon on 2013-09-29.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXApplication.h"
#import "SHXStatusView.h"
#import "SHXFontManager.h"
#import "SHXFolderFontCatalog.h"

@interface SHXApplication()
{
    @private
    SHXStatusView *_statusView;
    id <SHXIFontManager> _fontManager;
}
@end

@implementation SHXApplication

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    SHXFolderFontCatalog *local = [[SHXFolderFontCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Library/Fonts"]];
    SHXFolderFontCatalog *remote = [[SHXFolderFontCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Dropbox/Apps/Fonty"]];
    
    _fontManager = [[SHXFontManager alloc] initWithCatalog:local andCatalog:remote];
    
    _statusView = [[SHXStatusView alloc] init];
}

@end
