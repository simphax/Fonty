//
//  SHXAppleCloudSyncingManager.h
//  Fonty
//
//  Created by Simon on 2013-10-08.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SHXISyncingManager.h"

@interface SHXAppleCloudSyncingManager : NSObject <SHXISyncingManager>

-(id) initWithCatalog:(id <SHXICatalog>)local withDelegate:(id<SHXISyncingManagerDelegate>)delegate asFirstTime:(BOOL)first;

@end
