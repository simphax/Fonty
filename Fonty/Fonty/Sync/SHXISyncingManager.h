//
//  SHXISyncingManager.h
//  Fonty
//
//  Created by Simon on 2013-09-29.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SHXICatalog.h"

@protocol SHXISyncingManagerDelegate <NSObject>

-(void) fontSyncingBegin:(id)sender;
-(void) fontSyncingEnd:(id)sender;
-(void) removedFonts:(NSArray *)fonts sender:(id)sender;
-(void) changedFonts:(NSArray *)fonts sender:(id)sender;

@end

@protocol SHXISyncingManager <NSObject>

-(NSArray *) activatedFonts;

-(void) performMergeWith:(id <SHXICatalog>)fromCatalog and:(id <SHXICatalog>)toCatalog;
-(void) performHardFetchFrom:(id <SHXICatalog>)fromCatalog to:(id <SHXICatalog>)toCatalog;

@property(nonatomic,assign)id<SHXISyncingManagerDelegate> delegate;

@end