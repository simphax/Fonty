//
//  SHXFolderFontCatalogTest.m
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SHXFolderFontCatalog.h"

@interface SHXFolderFontCatalogTest : XCTestCase <SHXIFontCatalogDelegate> {

    @private
    id <SHXIFontCatalog> _catalog;

}

@end

@implementation SHXFolderFontCatalogTest

- (void)setUp
{
    [super setUp];
    _catalog = [[SHXFolderFontCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/Fonts"]];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testallFonts
{
    NSArray *arr = [_catalog allFonts];
    NSLog(@"All fonts: %@",arr);
}

#pragma mark SHXIFontCatalogDelegate
-(void) collectionModified:(id)sender {
    
}

@end
