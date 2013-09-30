//
//  SHXSharedLock.h
//  Fonty
//
//  Created by Simon on 2013-09-30.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHXSharedLock : NSObject

+ (SHXSharedLock *)sharedSyncLock;

@end


