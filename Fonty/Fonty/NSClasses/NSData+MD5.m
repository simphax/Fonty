//
//  NSData+MD5.m
//  Fonty
//
//  Created by Simon on 2013-10-01.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "NSData+MD5.h"

#import <CommonCrypto/CommonDigest.h>

@implementation NSData(MD5)

- (NSString*)MD5
{
    @autoreleasepool
    {
        unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
        
        CC_MD5(self.bytes, self.length, md5Buffer);
        
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        
        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        {
            [output appendFormat:@"%02x",md5Buffer[i]];
        }
        
        return output;
    }
}

@end