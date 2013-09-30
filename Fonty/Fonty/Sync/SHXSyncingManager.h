//
//  SHXSyncingManager.h
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHXISyncingManager.h"

@interface SHXSyncingManager : NSObject <SHXISyncingManager>

-(id) initWithCatalog:(id <SHXICatalog>)local andCatalog:(id <SHXICatalog>)remote withDelegate:(id<SHXISyncingManagerDelegate>)delegate asFirstTime:(BOOL)first;

@end
