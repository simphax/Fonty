//
//  SHXFont.m
//  Fonty
//
//  Created by Simon on 2013-09-29.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXFont.h"

@implementation SHXFont

-(id) initWithRelativePath:(NSString *)path
{
    self = [super init];
    self->_relativePath = path;
    return self;
}

@end
