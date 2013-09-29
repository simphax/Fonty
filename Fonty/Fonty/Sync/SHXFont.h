//
//  SHXFont.h
//  Fonty
//
//  Created by Simon on 2013-09-29.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHXFont : NSObject

-(id) initWithRelativePath:(NSString*) path;

@property (readonly) NSString *relativePath;

@end
