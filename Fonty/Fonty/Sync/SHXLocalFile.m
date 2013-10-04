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
    
    @autoreleasepool
    {
        _localPath = [[NSString alloc] initWithFormat:@"%@/%@",base,path];
        _MD5 = [[[NSData alloc] initWithContentsOfFile:_localPath] MD5];
    }
    
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
    return [[self relativePath] isEqual:[other relativePath]] && [self contentsMatchFile:other];
}

-(BOOL)contentsMatchFile:(SHXLocalFile *)other
{
    return [[self MD5] isEqualToString:[other MD5]];//[[NSFileManager defaultManager] contentsEqualAtPath: [self localPath] andPath: [other localPath]];
}

- (NSString *)description {
    return [self localPath];
}

@end
