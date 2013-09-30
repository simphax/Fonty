//
//  SHXSharedLock.m
//  Fonty
//
//  Created by Simon on 2013-09-30.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXSharedLock.h"

@implementation SHXSharedLock

+ (SHXSharedLock *)sharedSyncLock
{
    static SHXSharedLock *sharedSyncLock;
    
    @synchronized(self)
    {
        if (!sharedSyncLock)
            sharedSyncLock = [[SHXSharedLock alloc] init];
        
        return sharedSyncLock;
    }
}

@end