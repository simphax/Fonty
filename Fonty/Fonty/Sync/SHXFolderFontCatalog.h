//
//  SHXFolderFontCatalog.h
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHXIFontCatalog.h"
#import "SCEventListenerProtocol.h"

@interface SHXFolderFontCatalog : NSObject <SHXIFontCatalog>

-(id) initWithFolder:(NSString *)path;

@end
