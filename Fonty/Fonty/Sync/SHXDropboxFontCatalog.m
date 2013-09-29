//
//  SHXDropboxFontDatabase.m
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXDropboxFontCatalog.h"
#import "NSFileManager+DirectoryLocations.h"

static NSString *syncFolder;

@interface SHXDropboxFontCatalog() <DBRestClientDelegate>
{
    DBRestClient *_restClient;
}

@end


@implementation SHXDropboxFontCatalog

-(id) initWithRestClient:(DBRestClient *)restClient
{
    syncFolder = [NSString stringWithFormat:@"%@",[[NSFileManager defaultManager] applicationSupportDirectory]];
    
    self = [super initWithFolder:syncFolder];
    
    _restClient = restClient;
    
    [_restClient setDelegate:self];
    
    return self;
}



@end
