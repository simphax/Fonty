//
//  SHXDropboxFontDatabase.h
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <DropboxOSX/DropboxOSX.h>
#import "SHXFolderFontCatalog.h"

@interface SHXDropboxFontCatalog : SHXFolderFontCatalog

-(id) initWithRestClient:(DBRestClient *)restClient;

@end
