//
//  SHXLocalFile.m
//  Fonty
//
//  Created by Simon on 2013-09-29.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXLocalFile.h"

@implementation SHXLocalFile

-(id) initWithBase:(NSString *)base relativePath:(NSString *)path hash:(NSNumber *)hash
{
    self = [super initWithRelativePath:path];
    
    self->_localPath = [NSString stringWithFormat:@"%@/%@", base, path];
    self->_theHash = hash;
    
    return self;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash += [[self relativePath] hash];
    
    hash += [[self theHash] hash];
    
    return hash;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[SHXLocalFile class]])
        return NO;
    return [[self relativePath] isEqual:[other relativePath]] && [[self theHash] isEqualToNumber:[other theHash]];
}

- (NSString *)description {
    return [self localPath];
}

@end
