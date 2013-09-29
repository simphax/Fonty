//
//  SHXTestingAppDelegate.h
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHXIFontCatalog.h"

@interface SHXTestingAppDelegate : NSObject <NSApplicationDelegate,SHXIFontCatalogDelegate>

@property (assign) IBOutlet NSWindow *window;

@end
