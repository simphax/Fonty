//
//  SHXIFontDB.h
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHXFile.h"

@protocol SHXICatalogDelegate <NSObject>

-(void)disappearedFonts:(NSArray *)fonts sender:(id)sender;
-(void)changedFonts:(NSArray *)fonts sender:(id)sender;

@end

@protocol SHXICatalog <NSObject>

-(NSArray *)allFonts;

-(BOOL)updateFont:(SHXFile *)font;
-(BOOL)deleteFont:(SHXFile *)font;

@property(nonatomic,assign)id<SHXICatalogDelegate> delegate;

@end
