//
//  SHXIFontDB.h
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SHXIFontCatalogDelegate <NSObject>

-(void)collectionModified:(id)sender;

@end

@protocol SHXIFontCatalog <NSObject>

-(NSArray *)allFonts;

@property(nonatomic,assign)id<SHXIFontCatalogDelegate> delegate;

@end
