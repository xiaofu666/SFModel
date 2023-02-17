//
//  SFTestCustomTransform.m
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

@interface SFTestCustomTransformModel : NSObject
@property uint64_t id;
@property NSString *content;
@property NSDate *time;
@end

@implementation SFTestCustomTransformModel


-(NSDictionary *)sf_modelCustomWillTransformFromDictionary:(NSDictionary *)dic{
    if (dic) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
        if (dict[@"date"]) {
            dict[@"time"] = dict[@"date"];
        }
        return dict;
    }
    return dic;
}

- (BOOL)sf_modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSNumber *time = dic[@"time"];
    if ([time isKindOfClass:[NSNumber class]] && time.unsignedLongLongValue != 0) {
        _time = [NSDate dateWithTimeIntervalSince1970:time.unsignedLongLongValue / 1000.0];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)sf_modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    if (_time) {
        dic[@"time"] = @((uint64_t)(_time.timeIntervalSince1970 * 1000));
        return YES;
    } else {
        return NO;
    }
}

@end



@interface SFTestCustomTransform : XCTestCase

@end

@implementation SFTestCustomTransform


- (void)test {
    NSString *json;
    SFTestCustomTransformModel *model;
    NSDictionary *jsonObject;
    
    json = @"{\"id\":5472746497,\"content\":\"Hello\",\"time\":1401234567000}";
    model = [SFTestCustomTransformModel sf_modelWithJSON:json];
    XCTAssert(model.time != nil);
    
    json = @"{\"id\":5472746497,\"content\":\"Hello\"}";
    model = [SFTestCustomTransformModel sf_modelWithJSON:json];
    XCTAssert(model == nil);
    
    model = [SFTestCustomTransformModel sf_modelWithDictionary:@{@"id":@5472746497,@"content":@"Hello"}];
    XCTAssert(model == nil);
    
    json = @"{\"id\":5472746497,\"content\":\"Hello\",\"time\":1401234567000}";
    model = [SFTestCustomTransformModel sf_modelWithJSON:json];
    jsonObject = [model sf_modelToJSONObject];
    XCTAssert([jsonObject[@"time"] isKindOfClass:[NSNumber class]]);
    
    model.time = nil;
    jsonObject = [model sf_modelToJSONObject];
    XCTAssert(jsonObject == nil);
    
    json = @"{\"id\":5472746497,\"content\":\"Hello\",\"date\":1401234567000}";
    model = [SFTestCustomTransformModel sf_modelWithJSON:json];
    XCTAssert(model.time != nil);
    
}

@end
