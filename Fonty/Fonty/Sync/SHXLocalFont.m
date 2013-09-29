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

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash += [[self relativePath] hash];
    
    hash += [[self getFileSize] hash];
    
    return hash;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[SHXLocalFont class]])
        return NO;
    return [[self relativePath] isEqual:[other relativePath]] && [[self getFileSize] isEqual:[other getFileSize]];
}

- (NSNumber *)getFileSize
{
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:[self localPath] error: NULL];
    return [NSNumber numberWithUnsignedLongLong:(unsigned long long)[attrs fileSize]];
}

- (NSString *)description {
    return [self localPath];
}

@end
