//
//  SFTestCustomClass.m
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

@interface SFBaseUser : NSObject
@property uint64_t uid;
@property NSString *name;
@end


@interface SFLocalUser : SFBaseUser
@property NSString *localName;
@end
@implementation SFLocalUser
@end

@interface SFRemoteUser : SFBaseUser
@property NSString *remoteName;
@end
@implementation SFRemoteUser
@end


@implementation SFBaseUser
+ (Class)sf_modelCustomClassForDictionary:(NSDictionary*)dictionary {
    if (dictionary[@"localName"]) {
        return [SFLocalUser class];
    } else if (dictionary[@"remoteName"]) {
        return [SFRemoteUser class];
    }
    return [SFBaseUser class];
}
@end

@interface SFTestCustomClassModel : NSObject
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSDictionary *userDict;
@property (nonatomic, strong) NSSet *userSet;
@property (nonatomic, strong) SFBaseUser *user;
@end

@implementation SFTestCustomClassModel

+ (NSDictionary *)sf_modelContainerPropertyGenericClass {
    return @{@"users" : SFBaseUser.class,
             @"userDict" : SFBaseUser.class,
             @"userSet" : SFBaseUser.class};
}
+ (Class)sf_modelCustomClassForDictionary:(NSDictionary*)dictionary {
    if (dictionary[@"localName"]) {
        return [SFLocalUser class];
    } else if (dictionary[@"remoteName"]) {
        return [SFRemoteUser class];
    }
    return nil;
}
@end


@interface SFTestCustomClass : XCTestCase

@end

@implementation SFTestCustomClass

- (void)test {
    SFTestCustomClassModel *model;
    SFBaseUser *user;
    
    NSDictionary *jsonUserBase = @{@"uid" : @123, @"name" : @"Harry"};
    NSDictionary *jsonUserLocal = @{@"uid" : @123, @"name" : @"Harry", @"localName" : @"HarryLocal"};
    NSDictionary *jsonUserRemote = @{@"uid" : @123, @"name" : @"Harry", @"remoteName" : @"HarryRemote"};
    
    user = [SFBaseUser sf_modelWithDictionary:jsonUserBase];
    XCTAssert([user isMemberOfClass:[SFBaseUser class]]);
    
    user = [SFBaseUser sf_modelWithDictionary:jsonUserLocal];
    XCTAssert([user isMemberOfClass:[SFLocalUser class]]);
    
    user = [SFBaseUser sf_modelWithDictionary:jsonUserRemote];
    XCTAssert([user isMemberOfClass:[SFRemoteUser class]]);
    
    
    model = [SFTestCustomClassModel sf_modelWithJSON:@{@"user" : jsonUserLocal}];
    XCTAssert([model.user isMemberOfClass:[SFLocalUser class]]);
    
    model = [SFTestCustomClassModel sf_modelWithJSON:@{@"users" : @[jsonUserBase, jsonUserLocal, jsonUserRemote]}];
    XCTAssert([model.users[0] isMemberOfClass:[SFBaseUser class]]);
    XCTAssert([model.users[1] isMemberOfClass:[SFLocalUser class]]);
    XCTAssert([model.users[2] isMemberOfClass:[SFRemoteUser class]]);
    
    model = [SFTestCustomClassModel sf_modelWithJSON:@{@"userDict" : @{@"a" : jsonUserBase, @"b" : jsonUserLocal, @"c" : jsonUserRemote}}];
    XCTAssert([model.userDict[@"a"] isKindOfClass:[SFBaseUser class]]);
    XCTAssert([model.userDict[@"b"] isKindOfClass:[SFLocalUser class]]);
    XCTAssert([model.userDict[@"c"] isKindOfClass:[SFRemoteUser class]]);
    
    model = [SFTestCustomClassModel sf_modelWithJSON:@{@"userSet" : @[jsonUserBase, jsonUserLocal, jsonUserRemote]}];
    XCTAssert([model.userSet.anyObject isKindOfClass:[SFBaseUser class]]);
}

@end
