//
//  SHXLocalFont.h
//  Fonty
//
//  Created by Simon on 2013-09-29.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXFont.h"

@interface SHXLocalFont : SHXFont

-(id) initWithBase:(NSString*)base relativePath:(NSString*) path;

@property (readonly) NSString *localPath;

@end
