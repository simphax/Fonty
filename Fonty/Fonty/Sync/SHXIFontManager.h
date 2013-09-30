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
-(void) removedFonts:(NSArray *)fonts sender:(id)sender;
-(void) changedFonts:(NSArray *)fonts sender:(id)sender;

@end

@protocol SHXIFontManager <NSObject>

-(NSArray *) activatedFonts;

-(void) performMergeWith:(id <SHXIFontCatalog>)fromCatalog and:(id <SHXIFontCatalog>)toCatalog;
-(void) performHardFetchFrom:(id <SHXIFontCatalog>)fromCatalog to:(id <SHXIFontCatalog>)toCatalog;

@property(nonatomic,assign)id<SHXIFontManagerDelegate> delegate;

@end