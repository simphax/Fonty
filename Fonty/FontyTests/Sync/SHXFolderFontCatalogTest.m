//
//  SHXLocalFolderCatalogTest.m
//  Fonty
//
//  Created by Simon on 2013-09-28.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SHXLocalFolderCatalog.h"

@interface SHXLocalFolderCatalogTest : XCTestCase <SHXICatalogDelegate> {

    @private
    id <SHXICatalog> _catalog;

}

@end

@implementation SHXLocalFolderCatalogTest

- (void)setUp
{
    [super setUp];
    _catalog = [[SHXLocalFolderCatalog alloc] initWithFolder:[NSHomeDirectory() stringByAppendingString:@"/Desktop/Files"]];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testallFiles
{
    NSArray *arr = [_catalog allFiles];
    NSLog(@"All files: %@",arr);
}

#pragma mark SHXICatalogDelegate
-(void) collectionModified:(id)sender {
    
}

@end
