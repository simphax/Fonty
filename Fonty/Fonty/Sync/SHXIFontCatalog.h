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

-(void)collectionChanged:(id)sender;

@end

@protocol SHXIFontCatalog <NSObject>

-(NSArray *)allFonts;

-(BOOL)updateFont:(SHXFont *)font;
-(BOOL)deleteFont:(SHXFont *)font;

@property(nonatomic,assign)id<SHXIFontCatalogDelegate> delegate;

@end
