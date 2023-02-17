//
//  SFTestRadis.m
//  SFModelCacheDemoTests
//
//  Created by lurich on 2023/2/17.
//
#import <XCTest/XCTest.h>
#import "SFTestHelper.h"
#import "SFModelHeader.h"
@interface SFTestModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, strong) SFTestModel *model;

@end

@implementation SFTestModel
@end

@interface SFTestRadis : XCTestCase

@end

@implementation SFTestRadis

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [SFRedis sf_removeAllObjects];
}

- (void)testRedisSaveValue {
    // This is an example of a functional test case.
    // NSString
    [SFRedis sf_setValue:@"zhangsan" forKey:@"name"];
    XCTAssert([[SFRedis sf_valueForKey:@"name"] isEqualToString:@"zhangsan"]);
    
    // NSNumber
    [SFRedis sf_setValue:@(20) forKey:@"age"];
    XCTAssert([[SFRedis sf_valueForKey:@"age"] isEqual:@(20)]);
    
    // NSArray
    [SFRedis sf_setValue:@[@"111", @(222)] forKey:@"array1"];
    XCTAssert([[SFRedis sf_valueForKey:@"array1"][0] isEqualToString:@"111"]);
    XCTAssert([[SFRedis sf_valueForKey:@"array1"][1] isEqual:@(222)]);
    
    // NSDictionary
    NSDictionary *dict = @{@"name":@"Test", @"age":@(22)};
    [SFRedis sf_setValue:dict forKey:@"sf_infors"];
    XCTAssert([[SFRedis sf_valueForKey:@"sf_infors"][@"name"] isEqualToString:@"Test"]);
    XCTAssert([[SFRedis sf_valueForKey:@"sf_infors"][@"age"] isEqual:@(22)]);
}

- (void)testRedisSaveModel {
    // NSObject 数据模型
    SFTestModel *model = [[SFTestModel alloc] init];
    model.name = @"Test";
    model.age = 22;
    
    // NSObject 数据模型
    SFTestModel *model2 = [[SFTestModel alloc] init];
    model2.name = @"Test升级版";
    model2.age = 32;
    model2.model = model;
    // 存
    [SFRedis sf_setValue:model2 forKey:@"model"];
    
    SFTestModel *model_my = [SFRedis sf_valueForKey:@"model"];
    
    XCTAssert([model_my.name isEqualToString:@"Test升级版"]);
    XCTAssert(model_my.age == 32);
    XCTAssert([model_my.model.name isEqualToString:@"Test"]);
    XCTAssert(model_my.model.age == 22);
    
    //根据字典赋值
    NSMutableDictionary *value_dict = [[NSMutableDictionary alloc] init];
    [value_dict setValue:@"aaaaaaaa" forKey:@"key_string"];
    [value_dict setValue:@(111) forKey:@"key_number"];
    [value_dict setValue:@[@"arrayFirst", @(222)] forKey:@"key_array"];
    [value_dict setValue:@{@"name":@"dictName", @"age":@(333)} forKey:@"key_dict"];
    [value_dict setValue:model_my forKey:@"key_model"];
    [SFRedis sf_setValuesForKeysWithDictionary:value_dict];
    
    NSDictionary *dict = [SFRedis sf_dictionaryWithValuesForKeys:value_dict.allKeys];
    XCTAssert([dict[@"key_string"] isEqualToString:@"aaaaaaaa"]);
    XCTAssert([dict[@"key_number"] isEqual:@(111)]);
    XCTAssert([dict[@"key_array"][0] isEqualToString:@"arrayFirst"]);
    XCTAssert([dict[@"key_array"][1] isEqual:@(222)]);
    XCTAssert([dict[@"key_dict"][@"name"] isEqualToString:@"dictName"]);
    XCTAssert([dict[@"key_dict"][@"age"] isEqual:@(333)]);
    
    SFTestModel *dictModel = [SFRedis sf_valueForKey:@"key_model"];
    XCTAssert([dictModel.name isEqualToString:@"Test升级版"]);
    XCTAssert(dictModel.age == 32);
    XCTAssert([dictModel.model.name isEqualToString:@"Test"]);
    XCTAssert(dictModel.model.age == 22);
}
- (void)testRedisCount {
    // 获取全部values
    NSArray *values = [SFRedis sf_allValues];
    NSLog(@"values == %@",values);
    // 获取全部条数
    NSInteger count = [SFRedis sf_count];
    NSLog(@"count == %ld",count);
    // 判断当前key是否存在
    [SFRedis sf_setValue:@"lisi" forKey:@"name"];
    XCTAssert([SFRedis sf_isExistkey:@"name"]);
    // 删除
    [SFRedis sf_removeObjectForKey:@"name"];
    XCTAssert(![SFRedis sf_isExistkey:@"name"]);
    
    [SFRedis sf_setValue:@"lisi" forKey:@"name"];
    [SFRedis sf_setValue:@(20) forKey:@"age"];
    XCTAssert([SFRedis sf_isExistkey:@"name"]);
    // 根据keys删除数据
    NSArray *key_list = @[@"name", @"age"];
    [SFRedis sf_removeObjectsForKeys:key_list];
    XCTAssert(![SFRedis sf_isExistkey:@"age"]);
    
    // 删除全部
    [SFRedis sf_removeAllObjects];
    XCTAssert(![SFRedis sf_isExistkey:@"name"]);
    XCTAssert(![SFRedis sf_isExistkey:@"age"]);
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        NSMutableDictionary *value_dict = [[NSMutableDictionary alloc] init];
        [value_dict setValue:@"aaaaaaaa" forKey:@"key_string"];
        [value_dict setValue:@(111) forKey:@"key_number"];
        [value_dict setValue:@[@"arrayFirst", @(222)] forKey:@"key_array"];
        [value_dict setValue:@{@"name":@"dictName", @"age":@(333)} forKey:@"key_dict"];
        //根据字典赋值
        [SFRedis sf_setValuesForKeysWithDictionary:value_dict];
        //根据字典赋值
        NSDictionary *dict = [SFRedis sf_dictionaryWithValuesForKeys:value_dict.allKeys];
        NSLog(@"dict == %@",dict);
    }];
}

@end

/*
 XCTFail(format…) 生成一个失败的测试；
 XCTAssertNil(a1, format...)为空判断，a1为空时通过，反之不通过；
 XCTAssertNotNil(a1, format…)不为空判断，a1不为空时通过，反之不通过；
 XCTAssert(expression, format...)当expression求值为TRUE时通过;
 XCTAssertTrue(expression, format...)当expression求值为TRUE时通过；
 XCTAssertFalse(expression, format...)当expression求值为False时通过；
 XCTAssertEqualObjects(a1, a2, format...)判断相等，[a1 isEqual:a2]值为TRUE时通过，其中一个不为空时，不通过；
 XCTAssertNotEqualObjects(a1, a2, format...)判断不等，[a1 isEqual:a2]值为False时通过；
 XCTAssertEqual(a1, a2, format...)判断相等（当a1和a2是 C语言标量、结构体或联合体时使用,实际测试发现NSString也可以）；
 XCTAssertNotEqual(a1, a2, format...)判断不等（当a1和a2是 C语言标量、结构体或联合体时使用）；
 XCTAssertEqualWithAccuracy(a1, a2, accuracy, format...)判断相等，（double或float类型）提供一个误差范围，当在误差范围（+/-accuracy）以内相等时通过测试；
 XCTAssertNotEqualWithAccuracy(a1, a2, accuracy, format...) 判断不等，（double或float类型）提供一个误差范围，当在误差范围以内不等时通过测试；
 XCTAssertThrows(expression, format...)异常测试，当expression发生异常时通过；反之不通过；（很变态） XCTAssertThrowsSpecific(expression, specificException, format...) 异常测试，当expression发生specificException异常时通过；反之发生其他异常或不发生异常均不通过；
 XCTAssertThrowsSpecificNamed(expression, specificException, exception_name, format...)异常测试，当expression发生具体异常、具体异常名称的异常时通过测试，反之不通过；
 XCTAssertNoThrow(expression, format…)异常测试，当expression没有发生异常时通过测试；
 XCTAssertNoThrowSpecific(expression, specificException, format...)异常测试，当expression没有发生具体异常、具体异常名称的异常时通过测试，反之不通过；
 XCTAssertNoThrowSpecificNamed(expression, specificException, exception_name, format...)异常测试，当expression没有发生具体异常、具体异常名称的异常时通过测试，反之不通过
 特别注意下XCTAssertEqualObjects和XCTAssertEqual。
 XCTAssertEqualObjects(a1, a2, format...)的判断条件是[a1 isEqual:a2]是否返回一个YES。
 XCTAssertEqual(a1, a2, format...)的判断条件是a1 == a2是否返回一个YES。
 对于后者，如果a1和a2都是基本数据类型变量，那么只有a1 == a2才会返回YES
 */
