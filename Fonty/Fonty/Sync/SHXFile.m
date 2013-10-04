//
//  SHXFile.m
//  Fonty
//
//  Created by Simon on 2013-09-29.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXFile.h"

@implementation SHXFile

-(id) initWithRelativePath:(NSString *)path
{
    _relativePath = [[NSString alloc] initWithString:path];
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
    if (!other || ![other isKindOfClass:[SHXFile class]])
        return NO;
    return [[self relativePath] isEqual:[other relativePath]];
}

@end
