//
//  SHXFontManager.h
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHXIFontCatalog.h"

@protocol SHXFontManagerDelegate <NSObject>

-(void) fontSyncingBegin:(id)sender;
-(void) fontSyncingEnd:(id)sender;
-(void) collectionModified:(id)sender;

@end

@interface SHXFontManager : NSObject

-(id) initWithCatalog:(id <SHXIFontCatalog>)local andCatalog:(id <SHXIFontCatalog>)remote;

-(NSArray *) activatedFonts;

@end
