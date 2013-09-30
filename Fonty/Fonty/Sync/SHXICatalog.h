//
//  SHXIFileDB.h
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHXFile.h"

@protocol SHXICatalogDelegate <NSObject>

-(void)disappearedFiles:(NSArray *)files sender:(id)sender;
-(void)changedFiles:(NSArray *)files sender:(id)sender;

@end

@protocol SHXICatalog <NSObject>

-(NSArray *)allFiles;

-(BOOL)updateFile:(SHXFile *)file;
-(BOOL)deleteFile:(SHXFile *)file;

@property(nonatomic,assign)id<SHXICatalogDelegate> delegate;

@end
