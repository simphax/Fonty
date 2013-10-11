//
//  SHXLocalFolderCatalog.h
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHXICatalog.h"

@interface SHXLocalFolderCatalog : NSObject <SHXICatalog>

-(id) initWithFolder:(NSString *)path;

-(void) performMergeWith:(id <SHXICatalog>)fromCatalog and:(id <SHXICatalog>)toCatalog;
-(void) performHardFetchFrom:(id <SHXICatalog>)fromCatalog to:(id <SHXICatalog>)toCatalog;

@end
