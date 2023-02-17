//
//  SFTestAutoTypeConvert.m
//  SFModel <https://github.com/ibireme/SFModel>
//
//  Created by ibireme on 15/11/28.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <XCTest/XCTest.h>
#import "SFModelHeader.h"
#import "SFTestHelper.h"

@interface SFTestAutoTypeModel : NSObject
@property bool boolValue;
@property BOOL BOOLValue;
@property char charValue;
@property unsigned char unsignedCharValue;
@property short shortValue;
@property unsigned short unsignedShortValue;
@property int intValue;
@property unsigned int unsignedIntValue;
@property long longValue;
@property unsigned long unsignedLongValue;
@property long long longLongValue;
@property unsigned long long unsignedLongLongValue;
@property float floatValue;
@property double doubleValue;
@property long double longDoubleValue;
@property (strong) Class classValue;
@property SEL selectorValue;
@property (copy) void (^blockValue)(void);
@property void *pointerValue;
@property CGRect structValue;
@property CGPoint pointValue;

@property (nonatomic, strong) id anyObject;
@property (nonatomic, strong) NSObject *object;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) NSDecimalNumber *decimal;
@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSMutableString *mString;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSMutableData *mData;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSValue *value;
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSMutableDictionary *mDict;
@property (nonatomic, strong) NSSet *set;
@property (nonatomic, strong) NSMutableSet *mSet;
@end

@implementation SFTestAutoTypeModel
+ (NSDictionary *)sf_modelCustomPropertyMapper {
    return @{ @"boolValue" : @"v",
              @"BOOLValue" : @"v",
              @"charValue" : @"v",
              @"unsignedCharValue" : @"v",
              @"shortValue" : @"v",
              @"unsignedShortValue" : @"v",
              @"intValue" : @"v",
              @"unsignedIntValue" : @"v",
              @"longValue" : @"v",
              @"unsignedLongValue" : @"v",
              @"longLongValue" : @"v",
              @"unsignedLongLongValue" : @"v",
              @"floatValue" : @"v",
              @"doubleValue" : @"v",
              @"longDoubleValue" : @"v",
              @"classValue" : @"v",
              @"selectorValue" : @"v",
              @"blockValue" : @"v",
              @"pointerValue" : @"v",
              @"structValue" : @"v",
              @"pointValue" : @"v",
              
              @"anyObject" : @"v",
              @"object" : @"v",
              @"number" : @"v",
              @"decimal" : @"v",
              @"string" : @"v",
              @"mString" : @"v",
              @"data" : @"v",
              @"mData" : @"v",
              @"date" : @"v",
              @"value" : @"v",
              @"url" : @"v",
              
              @"array" : @"v",
              @"mArray" : @"v",
              @"dict" : @"v",
              @"mDict" : @"v",
              @"set" : @"v",
              @"mSet" : @"v"
              };
}
@end





@interface SFTestAutoTypeConvert : XCTestCase

@end

@implementation SFTestAutoTypeConvert

- (void)testNumber {
    NSString *json;
    SFTestAutoTypeModel *model;
    
    json = @"{\"v\" : 1}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert(model.boolValue);
    XCTAssert(model.BOOLValue);
    XCTAssert(model.charValue == 1);
    XCTAssert(model.unsignedCharValue == 1);
    XCTAssert(model.shortValue == 1);
    XCTAssert(model.unsignedShortValue == 1);
    XCTAssert(model.intValue == 1);
    XCTAssert(model.unsignedIntValue == 1);
    XCTAssert(model.longValue == 1);
    XCTAssert(model.unsignedLongValue == 1);
    XCTAssert(model.longLongValue == 1);
    XCTAssert(model.unsignedLongLongValue == 1);
    XCTAssert(model.floatValue == 1);
    XCTAssert(model.doubleValue == 1);
    XCTAssert(model.longDoubleValue == 1);
    XCTAssert([model.anyObject isEqual:@(1)]);
    XCTAssert([model.object isEqual:@(1)]);
    XCTAssert([model.number isEqual:@(1)]);
    XCTAssert([model.decimal isEqual:@(1)]);
    XCTAssert([model.string isEqualToString:@"1"]);
    XCTAssert([model.mString isEqualToString:@"1"]);
    XCTAssert([model.mString isKindOfClass:[NSMutableString class]]);
    XCTAssert(model.classValue == nil);
    XCTAssert(model.selectorValue == nil);
    XCTAssert(model.blockValue == nil);
    XCTAssert(model.pointerValue == nil);
    
    
    json = @"{\"v\" : 1.5}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert(model.boolValue);
    XCTAssert(model.BOOLValue);
    XCTAssert(model.charValue == 1);
    XCTAssert(model.unsignedCharValue == 1);
    XCTAssert(model.shortValue == 1);
    XCTAssert(model.unsignedShortValue == 1);
    XCTAssert(model.intValue == 1);
    XCTAssert(model.unsignedIntValue == 1);
    XCTAssert(model.longValue == 1);
    XCTAssert(model.unsignedLongValue == 1);
    XCTAssert(model.longLongValue == 1);
    XCTAssert(model.unsignedLongLongValue == 1);
    XCTAssert(model.floatValue == 1.5);
    XCTAssert(model.doubleValue == 1.5);
    XCTAssert(model.longDoubleValue == 1.5);
    XCTAssert([model.anyObject isEqual:@(1.5)]);
    XCTAssert([model.object isEqual:@(1.5)]);
    XCTAssert([model.number isEqual:@(1.5)]);
    XCTAssert([model.decimal isEqual:@(1.5)]);
    XCTAssert([model.string isEqualToString:@"1.5"]);
    XCTAssert([model.mString isEqualToString:@"1.5"]);
    XCTAssert([model.mString isKindOfClass:[NSMutableString class]]);
    
    json = @"{\"v\" : -1}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert(model.boolValue);
    XCTAssert(model.BOOLValue);
    XCTAssert(model.charValue == -1);
    XCTAssert(model.unsignedCharValue == (unsigned char)-1);
    XCTAssert(model.shortValue == -1);
    XCTAssert(model.unsignedShortValue == (unsigned short)-1);
    XCTAssert(model.intValue == -1);
    XCTAssert(model.unsignedIntValue == (unsigned int)-1);
    XCTAssert(model.longValue == -1);
    XCTAssert(model.unsignedLongValue == (unsigned long)-1);
    XCTAssert(model.longLongValue == -1);
    XCTAssert(model.unsignedLongLongValue == (unsigned long long)-1);
    XCTAssert(model.floatValue == -1);
    XCTAssert(model.doubleValue == -1);
    XCTAssert(model.longDoubleValue == -1);
    XCTAssert([model.anyObject isEqual:@(-1)]);
    XCTAssert([model.object isEqual:@(-1)]);
    XCTAssert([model.number isEqual:@(-1)]);
    XCTAssert([model.decimal isEqual:@(-1)]);
    XCTAssert([model.string isEqualToString:@"-1"]);
    XCTAssert([model.mString isEqualToString:@"-1"]);
    XCTAssert([model.mString isKindOfClass:[NSMutableString class]]);
    
    json = @"{\"v\" : \"2\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert(model.boolValue);
    XCTAssert(model.BOOLValue);
    XCTAssert(model.charValue == 2);
    XCTAssert(model.unsignedCharValue == 2);
    XCTAssert(model.shortValue == 2);
    XCTAssert(model.unsignedShortValue == 2);
    XCTAssert(model.intValue == 2);
    XCTAssert(model.unsignedIntValue == 2);
    XCTAssert(model.longValue == 2);
    XCTAssert(model.unsignedLongValue == 2);
    XCTAssert(model.longLongValue == 2);
    XCTAssert(model.unsignedLongLongValue == 2);
    XCTAssert(model.floatValue == 2);
    XCTAssert(model.doubleValue == 2);
    XCTAssert(model.longDoubleValue == 2);
    XCTAssert([model.anyObject isEqual:@"2"]);
    XCTAssert([model.object isEqual:@"2"]);
    XCTAssert([model.number isEqual:@(2)]);
    XCTAssert([model.decimal isEqual:@(2)]);
    XCTAssert([model.string isEqualToString:@"2"]);
    XCTAssert([model.mString isEqualToString:@"2"]);
    XCTAssert([model.mString isKindOfClass:[NSMutableString class]]);
    
    model.intValue = 12;
    [model sf_modelSetWithJSON:json];
    XCTAssert(model.intValue == 2);
    
    json = @"{\"v\" : \"-3.2\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert(fabs(model.floatValue + 3.2) < 0.0001);
    XCTAssert(fabs(model.doubleValue + 3.2) < 0.0001);
    XCTAssert(fabsl(model.longDoubleValue + 3.2) < 0.0001);
    XCTAssert([model.object isEqual:@"-3.2"]);
    XCTAssert([model.number isEqual:@(-3.2)]);
    XCTAssert([model.decimal isEqual:@(-3.2)]);
    XCTAssert([model.string isEqualToString:@"-3.2"]);
    XCTAssert([model.mString isEqualToString:@"-3.2"]);
    XCTAssert([model.mString isKindOfClass:[NSMutableString class]]);
    
    
    json = @"{\"v\" : \"true\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert(model.boolValue);
    XCTAssert(model.intValue == 1);
    
    json = @"{\"v\" : \"false\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert(model.boolValue == 0);
    XCTAssert(model.intValue == 0);
    
    json = @"{\"v\" : \"YES\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert(model.boolValue);
    XCTAssert(model.intValue == 1);
    
    json = @"{\"v\" : \"NO\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert(model.boolValue == 0);
    XCTAssert(model.intValue == 0);
    
    json = @"{\"v\" : \"nil\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert(model.boolValue == 0);
    XCTAssert(model.intValue == 0);
    XCTAssert([model.string isEqual:@"nil"]);
    XCTAssert(model.number == nil);
    
    json = @"{\"v\" : {}}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert(model.boolValue == 0);
    XCTAssert(model.intValue == 0);
    XCTAssert(model.string == nil);
    XCTAssert(model.number == nil);
    
    model = [SFTestAutoTypeModel sf_modelWithJSON:@{@"v" : [NSDecimalNumber decimalNumberWithString:@"9876543210"]}];
    XCTAssert(model.unsignedLongLongValue == 9876543210LLU);
    XCTAssert(model.longLongValue == 9876543210LL);
    
    model = [SFTestAutoTypeModel sf_modelWithJSON:@{@"v" : [NSValue valueWithPointer:CFArrayCreate]}];
    XCTAssert(model.pointerValue == CFArrayCreate);
    
    model = [SFTestAutoTypeModel sf_modelWithJSON:@{@"v" : [NSURL class]}];
    XCTAssert(model.classValue == [NSURL class]);
    
    __block int  i = 0;
    model = [SFTestAutoTypeModel sf_modelWithJSON:@{@"v" : ^{i = 1;}}];
    model.blockValue();
    XCTAssert(i == 1);
}


- (void)testDate {
    NSString *json;
    SFTestAutoTypeModel *model;
    
    json = @"{\"v\" : \"2014-05-06\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert([model.date isKindOfClass:[NSDate class]]);
    
    json = @"{\"v\" : \"2014-05-06 07:08:09\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert([model.date isKindOfClass:[NSDate class]]);
    
    json = @"{\"v\" : \"2014-05-06T07:08:09\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert([model.date isKindOfClass:[NSDate class]]);
    
    json = @"{\"v\" : \"2014-01-20T12:24:48Z\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert([model.date isKindOfClass:[NSDate class]]);
    
    json = @"{\"v\" : \"2014-01-20T12:24:48+0800\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert([model.date isKindOfClass:[NSDate class]]);
    
    json = @"{\"v\" : \"2014-01-20T12:24:48+12:00\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert([model.date isKindOfClass:[NSDate class]]);
    
    json = @"{\"v\" : \"Fri Sep 04 00:12:21 +0800 2015\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert([model.date isKindOfClass:[NSDate class]]);

    json = @"{\"v\" : \"2014-05-06 07:08:09.000\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert([model.date isKindOfClass:[NSDate class]]);

    json = @"{\"v\" : \"2014-05-06T07:08:09.000\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert([model.date isKindOfClass:[NSDate class]]);

    json = @"{\"v\" : \"2014-01-20T12:24:48.000Z\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert([model.date isKindOfClass:[NSDate class]]);

    json = @"{\"v\" : \"2014-01-20T12:24:48.000Z\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert([model.date isKindOfClass:[NSDate class]]);

    json = @"{\"v\" : \"2014-01-20T12:24:48.000+12:00\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert([model.date isKindOfClass:[NSDate class]]);

    json = @"{\"v\" : \"Fri Sep 04 00:12:21.000 +0800 2015\"}";
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssert([model.date isKindOfClass:[NSDate class]]);
    
    model = [SFTestAutoTypeModel sf_modelWithJSON:@{@"v" : [NSDate new]}];
    XCTAssert([model.date isKindOfClass:[NSDate class]]);
}

- (void)testString {
    NSDictionary *json;
    SFTestAutoTypeModel *model;
    
    json = @{@"v" : @"Apple"};
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssertTrue([model.string isEqualToString:@"Apple"]);
    
    json = @{@"v" : @" github.com"};
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssertTrue([model.url isEqual:[NSURL URLWithString:@"github.com"]]);
    
    json = @{@"v" : @"stringWithFormat:"};
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssertTrue(model.selectorValue == @selector(stringWithFormat:));
    
    json = @{@"v" : @"UILabel"};
    model = [SFTestAutoTypeModel sf_modelWithJSON:json];
    XCTAssertTrue(model.classValue == UILabel.class);
    
    model = [SFTestAutoTypeModel sf_modelWithJSON:@{@"v" : [@"haha" dataUsingEncoding:NSUTF8StringEncoding]}];
    XCTAssert([model.string isEqualToString:@"haha"]);
    
    model = [SFTestAutoTypeModel sf_modelWithJSON:@{@"v" : [NSURL URLWithString:@"https://github.com"]}];
    XCTAssert([model.string isEqualToString:@"https://github.com"]);
    
    model = [SFTestAutoTypeModel sf_modelWithJSON:@{@"v" : @" "}];
    XCTAssert(model.url == nil);
    
    model = [SFTestAutoTypeModel sf_modelWithJSON:@{@"v" : [[NSAttributedString alloc] initWithString:@"test"]}];
    XCTAssert([model.string isEqualToString:@"test"]);
}

- (void)testValue {
    NSValue *value;
    SFTestAutoTypeModel *model;
    
    value = [NSValue valueWithCGRect:CGRectMake(1, 2, 3, 4)];
    model = [SFTestAutoTypeModel sf_modelWithJSON:@{@"v" : value}];
    XCTAssertTrue(CGRectEqualToRect(model.structValue, CGRectMake(1, 2, 3, 4)));
    XCTAssertTrue(CGPointEqualToPoint(model.pointValue, CGPointZero));
    
    value = [NSValue valueWithCGPoint:CGPointMake(1, 2)];
    model = [SFTestAutoTypeModel sf_modelWithJSON:@{@"v" : value}];
    XCTAssertTrue(CGRectEqualToRect(model.structValue, CGRectZero));
    XCTAssertTrue(CGPointEqualToPoint(model.pointValue, CGPointMake(1, 2)));
}

- (void)testNull {
    SFTestAutoTypeModel *model;
    
    model = [SFTestAutoTypeModel sf_modelWithJSON:@{@"v" : [NSNull null]}];
    XCTAssertTrue(model.boolValue == false);
    XCTAssertTrue(model.object == nil);
}

- (void)testBlock {
    int (^block)(void) = ^{return 12;};
    NSDictionary *dic = @{@"v":block};
    SFTestAutoTypeModel *model = [SFTestAutoTypeModel sf_modelWithDictionary:dic];
    XCTAssertNotNil(model.blockValue);
    
    block = (id)model.blockValue;
    XCTAssertTrue(block() == 12);
}

- (void)testArrayAndDic {
    NSString *json;
    
    json = @"[{\"v\":1},{\"v\":2},{\"v\":3}]";
    NSArray *array = [NSArray sf_modelArrayWithClass:SFTestAutoTypeModel.class json:json];
    XCTAssertTrue(array.count == 3);
    XCTAssertTrue([array.firstObject isKindOfClass:[SFTestAutoTypeModel class]]);
    
    array = [NSArray sf_modelArrayWithClass:SFTestAutoTypeModel.class json:[SFTestHelper jsonDataFromString:json]];
    XCTAssertTrue(array.count == 3);
    XCTAssertTrue([array.firstObject isKindOfClass:[SFTestAutoTypeModel class]]);
    
    array = [NSArray sf_modelArrayWithClass:SFTestAutoTypeModel.class json:[SFTestHelper jsonObjectFromString:json]];
    XCTAssertTrue(array.count == 3);
    XCTAssertTrue([array.firstObject isKindOfClass:[SFTestAutoTypeModel class]]);
    
    
    json = @"{\"a\":{\"v\":1},\"b\":{\"v\":2},\"c\":{\"v\":3}}";
    NSDictionary *dict = [NSDictionary sf_modelDictionaryWithClass:SFTestAutoTypeModel.class json:json];
    XCTAssertTrue(dict.count == 3);
    XCTAssertTrue([dict[@"a"] isKindOfClass:[SFTestAutoTypeModel class]]);
    
    json = @"{\"a\":{\"v\":1},\"b\":{\"v\":2},\"c\":{\"v\":3}}";
    dict = [NSDictionary sf_modelDictionaryWithClass:SFTestAutoTypeModel.class json:[SFTestHelper jsonDataFromString:json]];
    XCTAssertTrue(dict.count == 3);
    XCTAssertTrue([dict[@"a"] isKindOfClass:[SFTestAutoTypeModel class]]);
    
    json = @"{\"a\":{\"v\":1},\"b\":{\"v\":2},\"c\":{\"v\":3}}";
    dict = [NSDictionary sf_modelDictionaryWithClass:SFTestAutoTypeModel.class json:[SFTestHelper jsonObjectFromString:json]];
    XCTAssertTrue(dict.count == 3);
    XCTAssertTrue([dict[@"a"] isKindOfClass:[SFTestAutoTypeModel class]]);
    
    SFTestAutoTypeModel *model;
    model = [SFTestAutoTypeModel sf_modelWithJSON:@{@"v" : [NSSet setWithArray:@[@1,@2,@3]]}];
    XCTAssertTrue([model.array isKindOfClass:[NSArray class]]);
    XCTAssertTrue(model.array.count == 3);
}

@end
