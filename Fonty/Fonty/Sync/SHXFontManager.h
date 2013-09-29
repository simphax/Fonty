//
//  SHXFontManager.h
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHXIFontManager.h"

@interface SHXFontManager : NSObject <SHXIFontManager>

-(id) initWithCatalog:(id <SHXIFontCatalog>)local andCatalog:(id <SHXIFontCatalog>)remote;

@end
