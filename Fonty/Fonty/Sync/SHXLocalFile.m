//
//  SHXLocalFile.m
//  Fonty
//
//  Created by Simon on 2013-09-29.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXLocalFile.h"

@implementation SHXLocalFile

-(id) initWithBase:(NSString *)base relativePath:(NSString *)path
{
    self = [super initWithRelativePath:path];
    
    _localPath = [base stringByAppendingPathComponent:path];
    
    return self;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    
    hash += [[self relativePath] hash];
    
    return hash;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[SHXLocalFile class]])
        return NO;
    return [[self relativePath] isEqual:[other relativePath]] && [self contentsMatchFile:other];
}

-(BOOL)contentsMatchFile:(SHXLocalFile *)other
{
    return [[NSFileManager defaultManager] contentsEqualAtPath: [self localPath] andPath: [other localPath]];
}

- (NSString *)description {
    return [self localPath];
}

@end
