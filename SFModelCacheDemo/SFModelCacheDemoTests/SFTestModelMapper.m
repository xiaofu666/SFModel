//
//  SFTestModelMapper.m
//  SFModel <https://github.com/ibireme/SFModel>
//
//  Created by ibireme on 15/11/27.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <XCTest/XCTest.h>
#import "SFModelHeader.h"


@interface SFTestPropertyMapperModelAuto : NSObject
@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) NSNumber *count;
@end

@implementation SFTestPropertyMapperModelAuto
@end

@interface SFTestPropertyMapperModelCustom : NSObject
@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) NSNumber *count;
@property (nonatomic, assign) NSString *desc1;
@property (nonatomic, assign) NSString *desc2;
@property (nonatomic, assign) NSString *desc3;
@property (nonatomic, assign) NSString *desc4;
@property (nonatomic, assign) NSString *modelID;
@end

@implementation SFTestPropertyMapperModelCustom
+ (NSDictionary *)sf_modelCustomPropertyMapper {
    return @{ @"name" : @"n",
              @"count" : @"ext.c",
              @"desc1" : @"ext.d", // mapped to same key path
              @"desc2" : @"ext.d", // mapped to same key path
              @"desc3" : @"ext.d.e",
              @"desc4" : @".ext",
              @"modelID" : @[@"ID", @"Id", @"id", @"ext.id"]};
}
@end

@interface SFTestPropertyMapperModelWarn : NSObject {
    NSString *_description;
}
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSNumber *id;
@end

@implementation SFTestPropertyMapperModelWarn
@synthesize description = _description;
@end






@protocol SFTestPropertyMapperModelAuto <NSObject>
@end

@protocol SFTestPropertyMapperModelCustom <NSObject>
@end

@protocol SFSimpleProtocol <NSObject>
@end


@interface SFTestPropertyMapperModelContainer : NSObject
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSMutableDictionary *mDict;
@property (nonatomic, strong) NSSet *set;
@property (nonatomic, strong) NSMutableSet *mSet;

@property (nonatomic, strong) NSArray<SFTestPropertyMapperModelAuto> *pArray1;
@property (nonatomic, strong) NSArray<SFSimpleProtocol,SFTestPropertyMapperModelAuto> *pArray2;
@property (nonatomic, strong) NSArray<SFSimpleProtocol,SFTestPropertyMapperModelCustom> *pArray3;
@end

@implementation SFTestPropertyMapperModelContainer
@end

@interface SFTestPropertyMapperModelContainerGeneric : SFTestPropertyMapperModelContainer
@end

@implementation SFTestPropertyMapperModelContainerGeneric
+ (NSDictionary *)sf_modelCustomPropertyMapper {
    return @{ @"mArray" : @"array",
              @"mDict" : @"dict",
              @"mSet" : @"set",
              @"pArray1" : @"array",
              @"pArray2" : @"array",
              @"pArray3" : @"array"};
}
+ (NSDictionary *)sf_modelContainerPropertyGenericClass {
    return @{@"array" : SFTestPropertyMapperModelAuto.class,
             @"mArray" : SFTestPropertyMapperModelAuto.class,
             @"dict" : SFTestPropertyMapperModelAuto.class,
             @"mDict" : SFTestPropertyMapperModelAuto.class,
             @"set" : @"SFTestPropertyMapperModelAuto",
             @"mSet" : @"SFTestPropertyMapperModelAuto",
             @"pArray3" : @"SFTestPropertyMapperModelAuto"};
}
@end



@interface SFTestModelPropertyMapper : XCTestCase

@end

@implementation SFTestModelPropertyMapper

- (void)testAuto {
    NSString *json;
    SFTestPropertyMapperModelAuto *model;
    
    json = @"{\"name\":\"Apple\",\"count\":12}";
    model = [SFTestPropertyMapperModelAuto sf_modelWithJSON:json];
    XCTAssertTrue([model.name isEqualToString:@"Apple"]);
    XCTAssertTrue([model.count isEqual:@12]);
    
    json = @"{\"n\":\"Apple\",\"count\":12, \"description\":\"hehe\"}";
    model = [SFTestPropertyMapperModelAuto sf_modelWithJSON:json];
    XCTAssertTrue(model.name == nil);
    XCTAssertTrue([model.count isEqual:@12]);
}

- (void)testCustom {
    NSString *json;
    NSDictionary *jsonObject;
    SFTestPropertyMapperModelCustom *model;
    
    json = @"{\"n\":\"Apple\",\"ext\":{\"c\":12}}";
    model = [SFTestPropertyMapperModelCustom sf_modelWithJSON:json];
    XCTAssertTrue([model.name isEqualToString:@"Apple"]);
    XCTAssertTrue([model.count isEqual:@12]);
    
    json = @"{\"n\":\"Apple\",\"count\":12}";
    model = [SFTestPropertyMapperModelCustom sf_modelWithJSON:json];
    XCTAssertTrue(model.count == nil);
    
    json = @"{\"n\":\"Apple\",\"ext\":12}";
    model = [SFTestPropertyMapperModelCustom sf_modelWithJSON:json];
    XCTAssertTrue(model.count == nil);
    
    json = @"{\"n\":\"Apple\",\"ext\":@{}}";
    model = [SFTestPropertyMapperModelCustom sf_modelWithJSON:json];
    XCTAssertTrue(model.count == nil);
    
    json = @"{\"ext\":{\"d\":\"Apple\"}}";
    model = [SFTestPropertyMapperModelCustom sf_modelWithJSON:json];
    XCTAssertTrue([model.desc1 isEqualToString:@"Apple"]);
    XCTAssertTrue([model.desc2 isEqualToString:@"Apple"]);
    
    jsonObject = [model sf_modelToJSONObject];
    XCTAssertTrue([((NSDictionary *)jsonObject[@"ext"])[@"d"] isEqualToString:@"Apple"]);
    
    json = @"{\"ext\":{\"d\":{ \"e\" : \"Apple\"}}}";
    model = [SFTestPropertyMapperModelCustom sf_modelWithJSON:json];
    XCTAssertTrue([model.desc3 isEqualToString:@"Apple"]);
    
    json = @"{\".ext\":\"Apple\"}";
    model = [SFTestPropertyMapperModelCustom sf_modelWithJSON:json];
    XCTAssertTrue([model.desc4 isEqualToString:@"Apple"]);
    
    json = @"{\".ext\":\"Apple\", \"name\":\"Apple\", \"count\":\"10\", \"desc1\":\"Apple\", \"desc2\":\"Apple\", \"desc3\":\"Apple\", \"desc4\":\"Apple\", \"modelID\":\"Apple\"}";
    model = [SFTestPropertyMapperModelCustom sf_modelWithJSON:json];
    XCTAssertTrue([model.desc4 isEqualToString:@"Apple"]);
    
    json = @"{\"id\":\"abcd\"}";
    model = [SFTestPropertyMapperModelCustom sf_modelWithJSON:json];
    XCTAssertTrue([model.modelID isEqualToString:@"abcd"]);
    
    json = @"{\"ext\":{\"id\":\"abcd\"}}";
    model = [SFTestPropertyMapperModelCustom sf_modelWithJSON:json];
    XCTAssertTrue([model.modelID isEqualToString:@"abcd"]);
    
    json = @"{\"id\":\"abcd\",\"ID\":\"ABCD\",\"Id\":\"Abcd\"}";
    model = [SFTestPropertyMapperModelCustom sf_modelWithJSON:json];
    XCTAssertTrue([model.modelID isEqualToString:@"ABCD"]);
    
    jsonObject = [model sf_modelToJSONObject];
    XCTAssertTrue(jsonObject[@"id"] == nil);
    XCTAssertTrue([jsonObject[@"ID"] isEqualToString:@"ABCD"]);
}

- (void)testWarn {
    NSString *json = @"{\"description\":\"Apple\",\"id\":12345}";
    SFTestPropertyMapperModelWarn *model = [SFTestPropertyMapperModelWarn sf_modelWithJSON:json];
    XCTAssertTrue([model.description isEqualToString:@"Apple"]);
    XCTAssertTrue([model.id isEqual:@12345]);
}

- (void)testContainer {
    NSString *json;
    NSDictionary *jsonObject = nil;
    SFTestPropertyMapperModelContainer *model;
    
    json = @"{\"array\":[\n  {\"name\":\"Apple\", \"count\":10},\n  {\"name\":\"Banana\", \"count\":11},\n  {\"name\":\"Pear\", \"count\":12},\n  null\n]}";
    
    model = [SFTestPropertyMapperModelContainer sf_modelWithJSON:json];
    XCTAssertTrue([model.array isKindOfClass:[NSArray class]]);
    XCTAssertTrue(model.array.count == 4);
    
    jsonObject = [model sf_modelToJSONObject];
    XCTAssertTrue([jsonObject[@"array"] isKindOfClass:[NSArray class]]);
    
    model = [SFTestPropertyMapperModelContainerGeneric sf_modelWithJSON:json];
    XCTAssertTrue([model.array isKindOfClass:[NSArray class]]);
    XCTAssertTrue(model.array.count == 3);
    XCTAssertTrue([((SFTestPropertyMapperModelAuto *)model.array[0]).name isEqualToString:@"Apple"]);
    XCTAssertTrue([((SFTestPropertyMapperModelAuto *)model.array[0]).count isEqual:@10]);
    XCTAssertTrue([((SFTestPropertyMapperModelAuto *)model.array[2]).name isEqualToString:@"Pear"]);
    XCTAssertTrue([((SFTestPropertyMapperModelAuto *)model.array[2]).count isEqual:@12]);
    XCTAssertTrue([model.mArray isKindOfClass:[NSMutableArray class]]);
    
    XCTAssertTrue(model.pArray1.count == 3);
    XCTAssertTrue([((SFTestPropertyMapperModelAuto *)model.pArray1[0]).name isEqualToString:@"Apple"]);
    XCTAssertTrue([((SFTestPropertyMapperModelAuto *)model.pArray1[0]).count isEqual:@10]);
    XCTAssertTrue(model.pArray2.count == 3);
    XCTAssertTrue([((SFTestPropertyMapperModelAuto *)model.pArray2[0]).name isEqualToString:@"Apple"]);
    XCTAssertTrue([((SFTestPropertyMapperModelAuto *)model.pArray2[0]).count isEqual:@10]);
    XCTAssertTrue(model.pArray3.count == 3);
    XCTAssertTrue([((SFTestPropertyMapperModelAuto *)model.pArray3[0]).name isEqualToString:@"Apple"]);
    XCTAssertTrue([((SFTestPropertyMapperModelAuto *)model.pArray3[0]).count isEqual:@10]);
    
    
    jsonObject = [model sf_modelToJSONObject];
    XCTAssertTrue([jsonObject[@"array"] isKindOfClass:[NSArray class]]);
    
    json = @"{\"dict\":{\n  \"A\":{\"name\":\"Apple\", \"count\":10},\n  \"B\":{\"name\":\"Banana\", \"count\":11},\n  \"P\":{\"name\":\"Pear\", \"count\":12},\n  \"N\":null\n}}";
    
    model = [SFTestPropertyMapperModelContainer sf_modelWithJSON:json];
    XCTAssertTrue([model.dict isKindOfClass:[NSDictionary class]]);
    XCTAssertTrue(model.dict.count == 4);
    
    jsonObject = [model sf_modelToJSONObject];
    XCTAssertTrue(jsonObject != nil);
    
    model = [SFTestPropertyMapperModelContainerGeneric sf_modelWithJSON:json];
    XCTAssertTrue([model.dict isKindOfClass:[NSDictionary class]]);
    XCTAssertTrue(model.dict.count == 3);
    XCTAssertTrue([((SFTestPropertyMapperModelAuto *)model.dict[@"A"]).name isEqualToString:@"Apple"]);
    XCTAssertTrue([((SFTestPropertyMapperModelAuto *)model.dict[@"A"]).count isEqual:@10]);
    XCTAssertTrue([((SFTestPropertyMapperModelAuto *)model.dict[@"P"]).name isEqualToString:@"Pear"]);
    XCTAssertTrue([((SFTestPropertyMapperModelAuto *)model.dict[@"P"]).count isEqual:@12]);
    XCTAssertTrue([model.mDict isKindOfClass:[NSMutableDictionary class]]);
    
    jsonObject = [model sf_modelToJSONObject];
    XCTAssertTrue(jsonObject != nil);
    
    json = @"{\"set\":[\n  {\"name\":\"Apple\", \"count\":10},\n  {\"name\":\"Banana\", \"count\":11},\n  {\"name\":\"Pear\", \"count\":12},\n  null\n]}";
    
    model = [SFTestPropertyMapperModelContainer sf_modelWithJSON:json];
    XCTAssertTrue([model.set isKindOfClass:[NSSet class]]);
    XCTAssertTrue(model.set.count == 4);
    
    jsonObject = [model sf_modelToJSONObject];
    XCTAssertTrue(jsonObject != nil);
    
    model = [SFTestPropertyMapperModelContainerGeneric sf_modelWithJSON:json];
    XCTAssertTrue([model.set isKindOfClass:[NSSet class]]);
    XCTAssertTrue(model.set.count == 3);
    XCTAssertTrue([((SFTestPropertyMapperModelAuto *)model.set.anyObject).name isKindOfClass:[NSString class]]);
    XCTAssertTrue([model.mSet isKindOfClass:[NSMutableSet class]]);
    
    jsonObject = [model sf_modelToJSONObject];
    XCTAssertTrue(jsonObject != nil);
    
    model = [SFTestPropertyMapperModelContainerGeneric sf_modelWithJSON:@{@"set" : @[[SFTestPropertyMapperModelAuto new]]}];
    XCTAssertTrue([model.set isKindOfClass:[NSSet class]]);
    XCTAssertTrue([[model.set anyObject] isKindOfClass:[SFTestPropertyMapperModelAuto class]]);
    
    model = [SFTestPropertyMapperModelContainerGeneric sf_modelWithJSON:@{@"array" : [NSSet setWithArray:@[[SFTestPropertyMapperModelAuto new]]]}];
    XCTAssertTrue([model.array isKindOfClass:[NSArray class]]);
    XCTAssertTrue([[model.array firstObject] isKindOfClass:[SFTestPropertyMapperModelAuto class]]);
    
    model = [SFTestPropertyMapperModelContainer sf_modelWithJSON:@{@"mArray" : @[[SFTestPropertyMapperModelAuto new]]}];
    XCTAssertTrue([model.mArray isKindOfClass:[NSMutableArray class]]);
    XCTAssertTrue([[model.mArray firstObject] isKindOfClass:[SFTestPropertyMapperModelAuto class]]);
    
    model = [SFTestPropertyMapperModelContainer sf_modelWithJSON:@{@"mArray" : [NSSet setWithArray:@[[SFTestPropertyMapperModelAuto new]]]}];
    XCTAssertTrue([model.mArray isKindOfClass:[NSMutableArray class]]);
    XCTAssertTrue([[model.mArray firstObject] isKindOfClass:[SFTestPropertyMapperModelAuto class]]);
}

@end
