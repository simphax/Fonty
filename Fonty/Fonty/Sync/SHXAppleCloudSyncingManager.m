//
//  SHXAppleCloudSyncingManager.m
//  Fonty
//
//  Created by Simon on 2013-10-08.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXAppleCloudSyncingManager.h"
#import "SHXLocalFile.h"

@interface SHXAppleCloudSyncingManager() <SHXICatalogDelegate>
{
@private
    id <SHXICatalog> _localFileCatalog;
}

@end

@implementation SHXAppleCloudSyncingManager

-(id) initWithCatalog:(id <SHXICatalog>)local withDelegate:(id<SHXISyncingManagerDelegate>)delegate asFirstTime:(BOOL)first
{
    self = [super init];
    
    [local setDelegate:self];
    
    _localFileCatalog = local;
    
    if(first)
    {
        [self performMerge];
    }
    else
    {
        [self performHardFetch];
    }
    
    return self;
}


-(void) performMerge
{
    //FIXME
}

-(void) performHardFetch
{
    NSArray *allFiles = [_localFileCatalog allFiles];
    
    for(SHXLocalFile *file in allFiles)
    {
        if(![[NSFileManager defaultManager] isUbiquitousItemAtURL:[file URL]])
        {
            [_localFileCatalog deleteFile:file];
        }
    }
}


-(NSArray *) activatedFiles
{
    //FIXME Should return items with isUbiquitousItemAtURL: set to true
    return [_localFileCatalog allFiles];
}

@end
