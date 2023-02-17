//
//  SFTestNestModel.m
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


@interface SFTestNestUser : NSObject
@property uint64_t uid;
@property NSString *name;
@end
@implementation SFTestNestUser
@end

@interface SFTestNestRepo : NSObject
@property uint64_t repoID;
@property NSString *name;
@property SFTestNestUser *user;
@end
@implementation SFTestNestRepo
@end



@interface SFTestNestModel : XCTestCase

@end

@implementation SFTestNestModel

- (void)test {
    NSString *json = @"{\"repoID\":1234,\"name\":\"SFModel\",\"user\":{\"uid\":5678,\"name\":\"ibireme\"}}";
    SFTestNestRepo *repo = [SFTestNestRepo sf_modelWithJSON:json];
    XCTAssert(repo.repoID == 1234);
    XCTAssert([repo.name isEqualToString:@"SFModel"]);
    XCTAssert(repo.user.uid == 5678);
    XCTAssert([repo.user.name isEqualToString:@"ibireme"]);
    
    NSDictionary *jsonObject = [repo sf_modelToJSONObject];
    XCTAssert([((NSString *)jsonObject[@"name"]) isEqualToString:@"SFModel"]);
    XCTAssert([((NSString *)((NSDictionary *)jsonObject[@"user"])[@"name"]) isEqualToString:@"ibireme"]);
    
    [repo sf_modelSetWithJSON:@{@"name" : @"SFImage", @"user" : @{@"name": @"bot"}}];
    XCTAssert(repo.repoID == 1234);
    XCTAssert([repo.name isEqualToString:@"SFImage"]);
    XCTAssert(repo.user.uid == 5678);
    XCTAssert([repo.user.name isEqualToString:@"bot"]);
}

@end
