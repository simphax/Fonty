//
//  SHXLocalFile.m
//  Fonty
//
//  Created by Simon on 2013-09-29.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXLocalFile.h"
#import "NSData+MD5.h"

@implementation SHXLocalFile

-(id) initWithBase:(NSString *)base relativePath:(NSString *)path
{
    self = [super initWithRelativePath:path];
    
    _localPath = [base stringByAppendingPathComponent:path];
    
    NSData *nsData = [NSData dataWithContentsOfFile:_localPath];
    
    _MD5 = [nsData MD5];
    
    
    return self;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash += [[self relativePath] hash];
    
    hash += [[self MD5] hash];
    
    return hash;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[SHXLocalFile class]])
        return NO;
    return [[self relativePath] isEqual:[other relativePath]] && [[self MD5] isEqual:[other MD5]];
}

- (NSString *)description {
    return [self localPath];
}

@end
