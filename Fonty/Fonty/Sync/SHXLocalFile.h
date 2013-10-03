//
//  SHXLocalFile.h
//  Fonty
//
//  Created by Simon on 2013-09-29.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXFile.h"

@interface SHXLocalFile : SHXFile

-(id) initWithBase:(NSString *)base relativePath:(NSString *)path;

@property (readonly, retain) NSString *localPath;

@end