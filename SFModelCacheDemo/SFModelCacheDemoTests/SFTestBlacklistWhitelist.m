//
//  SFTestBlacklistWhitelist.m
//  SFModel <https://github.com/ibireme/SFModel>
//
//  Created by ibireme on 15/11/29.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <XCTest/XCTest.h>
#import "SFModelHeader.h"


@interface SFTestBlacklistModel : NSObject
@property (nonatomic, strong) NSString *a;
@property (nonatomic, strong) NSString *b;
@property (nonatomic, strong) NSString *c;
@end

@implementation SFTestBlacklistModel
+ (NSArray *)sf_modelPropertyBlacklist {
    return @[@"a", @"d"];
}
@end

@interface SFTestWhitelistModel : NSObject
@property (nonatomic, strong) NSString *a;
@property (nonatomic, strong) NSString *b;
@property (nonatomic, strong) NSString *c;
@end

@implementation SFTestWhitelistModel
+ (NSArray *)sf_modelPropertyWhitelist {
    return @[@"a", @"d"];
}
@end


@interface SFTestBlackWhitelistModel : NSObject
@property (nonatomic, strong) NSString *a;
@property (nonatomic, strong) NSString *b;
@property (nonatomic, strong) NSString *c;
@end

@implementation SFTestBlackWhitelistModel
+ (NSArray *)sf_modelPropertyBlacklist {
    return @[@"a", @"d"];
}
+ (NSArray *)sf_modelPropertyWhitelist {
    return @[@"a", @"b", @"d"];
}
@end




@interface SFTestBlacklistWhitelist : XCTestCase

@end

@implementation SFTestBlacklistWhitelist

- (void)testBlacklist {
    NSString *json = @"{\"a\":\"A\", \"b\":\"B\", \"c\":\"C\", \"d\":\"D\"}";
    SFTestBlacklistModel *model = [SFTestBlacklistModel sf_modelWithJSON:json];
    XCTAssert(model.a == nil);
    XCTAssert(model.b != nil);
    XCTAssert(model.c != nil);
    
    NSDictionary *dic = [model sf_modelToJSONObject];
    XCTAssert(dic[@"a"] == nil);
    XCTAssert(dic[@"b"] != nil);
    XCTAssert(dic[@"c"] != nil);
}

- (void)testWhitelist {
    NSString *json = @"{\"a\":\"A\", \"b\":\"B\", \"c\":\"C\", \"d\":\"D\"}";
    SFTestWhitelistModel *model = [SFTestWhitelistModel sf_modelWithJSON:json];
    XCTAssert(model.a != nil);
    XCTAssert(model.b == nil);
    XCTAssert(model.c == nil);
    
    NSDictionary *dic = [model sf_modelToJSONObject];
    XCTAssert(dic[@"a"] != nil);
    XCTAssert(dic[@"b"] == nil);
    XCTAssert(dic[@"c"] == nil);
}


- (void)testBlackWhitelist {
    NSString *json = @"{\"a\":\"A\", \"b\":\"B\", \"c\":\"C\", \"d\":\"D\"}";
    SFTestBlackWhitelistModel *model = [SFTestBlackWhitelistModel sf_modelWithJSON:json];
    XCTAssert(model.a == nil);
    XCTAssert(model.b != nil);
    XCTAssert(model.c == nil);
    
    NSDictionary *dic = [model sf_modelToJSONObject];
    XCTAssert(dic[@"a"] == nil);
    XCTAssert(dic[@"b"] != nil);
    XCTAssert(dic[@"c"] == nil);
}

@end
