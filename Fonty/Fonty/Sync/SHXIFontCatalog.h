//
//  SHXIFontDB.h
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHXFont.h"

@protocol SHXIFontCatalogDelegate <NSObject>

-(void)deletedFonts:(NSArray *)fonts sender:(id)sender;
-(void)updatedFonts:(NSArray *)fonts sender:(id)sender;

-(void)disappearedFonts:(NSArray *)fonts sender:(id)sender;
-(void)changedFonts:(NSArray *)fonts sender:(id)sender;

@end

@protocol SHXIFontCatalog <NSObject>

-(NSArray *)allFonts;

-(void)updateFonts:(NSArray *)fonts;
-(void)deleteFonts:(NSArray *)fonts;

@property(nonatomic,assign)id<SHXIFontCatalogDelegate> delegate;

@end
