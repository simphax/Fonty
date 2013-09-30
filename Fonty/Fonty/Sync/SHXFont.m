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

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash += [[self relativePath] hash];
    
    hash += [[self relativePath] hash];
    
    return hash;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[SHXFont class]])
        return NO;
    return [[self relativePath] isEqual:[other relativePath]];
}


@end
