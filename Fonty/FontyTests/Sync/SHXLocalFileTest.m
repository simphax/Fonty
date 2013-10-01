//
//  SHXLocalFileTest.m
//  Fonty
//
//  Created by Simon Nilsson on 2013-10-01.
//  Copyright (c) 2013 Simphax. All rights reserved.
//

#import "SHXLocalFileTest.h"
#import "SHXLocalFile.h"

@interface SHXLocalFileTest () {
    SHXLocalFile *local_same_filename_different_content;
    SHXLocalFile *local_same;
    SHXLocalFile *remote_same_filename_different_content;
    SHXLocalFile *remote_same;
    SHXLocalFile *remote_same_content_different_filename;
}

@end

@implementation SHXLocalFileTest

- (void)setUp
{
    [super setUp];
    
    NSString *base = [[NSBundle bundleForClass:[self class]]resourcePath];
    
    NSString *localBase = [base stringByAppendingPathComponent:@"/LocalFileTest/LocalFiles"];
    NSString *remoteBase = [base stringByAppendingPathComponent:@"/LocalFileTest/RemoteFiles"];
    
    local_same_filename_different_content = [[SHXLocalFile alloc] initWithBase:localBase relativePath:@"same_filename_different_content.txt"];
    local_same = [[SHXLocalFile alloc] initWithBase:localBase relativePath:@"same.txt"];
    
    remote_same_filename_different_content = [[SHXLocalFile alloc] initWithBase:remoteBase relativePath:@"same_filename_different_content.txt"];
    remote_same = [[SHXLocalFile alloc] initWithBase:remoteBase relativePath:@"same.txt"];
    remote_same_content_different_filename = [[SHXLocalFile alloc] initWithBase:remoteBase relativePath:@"same_content_different_filename.txt"];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    
}

- (void)testEquals
{
    NSAssert([local_same isEqual:remote_same], @"%@ is not equal to %@",[local_same relativePath],[remote_same relativePath]);
    NSAssert(![local_same_filename_different_content isEqual:remote_same_filename_different_content], @"2");
    NSAssert(![local_same isEqual:remote_same_content_different_filename], @"3");
}


@end
