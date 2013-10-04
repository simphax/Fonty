//
//  SHXFile.h
//  Fonty
//
//  Created by Simon on 2013-09-29.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHXFile : NSObject

-(id) initWithRelativePath:(NSString*) path;

@property (readonly, copy) NSString *relativePath;

@end
