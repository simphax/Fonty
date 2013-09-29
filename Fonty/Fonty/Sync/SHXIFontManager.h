//
//  SHXIFontManager.h
//  Fonty
//
//  Created by Simon on 2013-09-29.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SHXIFontCatalog.h"

@protocol SHXIFontManagerDelegate <NSObject>

-(void) fontSyncingBegin:(id)sender;
-(void) fontSyncingEnd:(id)sender;
-(void) collectionModified:(id)sender;

@end

@protocol SHXIFontManager <NSObject>

-(NSArray *) activatedFonts;

-(void) performManualSync;

@property(nonatomic,assign)id<SHXIFontManagerDelegate> delegate;

@end