//
//  SHXLocalFont.m
//  Fonty
//
//  Created by Simon on 2013-09-29.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXLocalFont.h"

@implementation SHXLocalFont

-(id) initWithBase:(NSString *)base relativePath:(NSString *)path
{
    self = [super initWithRelativePath:path];
    
    //TODO: Check path eligibility?
    self->_localPath = [NSString stringWithFormat:@"%@/%@", base, path];
    
    return self;
}

@end
