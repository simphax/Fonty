//
//  SHXFolderFontCatalog.m
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXFolderFontCatalog.h"

@implementation SHXFolderFontCatalog

@synthesize delegate;

-(id) initWithFolder:(NSString *)path {
    self = [super init];
    _path = path;
    return self;
}

-(NSArray *)allFonts{
    NSArray *allFiles = [[NSFileManager defaultManager]
                            contentsOfDirectoryAtPath:_path error:nil];
    return allFiles;
}

@end
