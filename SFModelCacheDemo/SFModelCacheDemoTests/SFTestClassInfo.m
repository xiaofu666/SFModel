//
//  SFTestClassInfo.m
//  SFModel <https://github.com/ibireme/SFModel>
//
//  Created by ibireme on 15/11/27.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <XCTest/XCTest.h>
#import <CoreFoundation/CoreFoundation.h>
#import "SFModelHeader.h"

typedef union sf_union{ char a; int b;} sf_union;

@interface SFTestPropertyModel : NSObject
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
@property (strong) NSObject *objectValue;
@property (strong) NSArray *arrayValue;
@property (strong) Class classValue;
@property SEL selectorValue;
@property (copy) void (^blockValue)(void);
@property void *pointerValue;
@property CFArrayEqualCallBack functionPointerValue;
@property CGRect structValue;
@property sf_union unionValue;
@property char *cStringValue;

@property (nonatomic) NSObject *nonatomicValue;
@property (copy) NSObject *aCopyValue;
@property (assign) NSObject *assignValue;
@property (strong) NSObject *strongValue;
@property (retain) NSObject *retainValue;
@property (weak) NSObject *weakValue;
@property (readonly) NSObject *readonlyValue;
@property (nonatomic) NSObject *dynamicValue;
@property (unsafe_unretained) NSObject *unsafeValue;
@property (nonatomic, getter=getValue) NSObject *getterValue;
@property (nonatomic, setter=setValue:) NSObject *setterValue;
@end

@implementation SFTestPropertyModel {
    const NSObject *_constValue;
}

@dynamic dynamicValue;

- (NSObject *)getValue {
    return _getterValue;
}

- (void)setValue:(NSObject *)value {
    _setterValue = value;
}

- (void)testConst:(const NSObject *)value {}
- (void)testIn:(in NSObject *)value {}
- (void)testOut:(out NSObject *)value {}
- (void)testInout:(inout NSObject *)value {}
- (void)testBycopy:(bycopy NSObject *)value {}
- (void)testByref:(byref NSObject *)value {}
- (void)testOneway:(oneway NSObject *)value {}
@end






@interface SFTestClassInfo : XCTestCase
@end

@implementation SFTestClassInfo

- (void)testClassInfoCache {
    SFClassInfo *info1 = [SFClassInfo classInfoWithClass:[SFTestPropertyModel class]];
    [info1 setNeedUpdate];
    SFClassInfo *info2 = [SFClassInfo classInfoWithClassName:@"SFTestPropertyModel"];
    XCTAssertNotNil(info1);
    XCTAssertNotNil(info2);
    XCTAssertEqual(info1, info2);
}

- (void)testClassMeta {
    SFClassInfo *classInfo = [SFClassInfo classInfoWithClass:[SFTestPropertyModel class]];
    XCTAssertNotNil(classInfo);
    XCTAssertEqual(classInfo.cls, [SFTestPropertyModel class]);
    XCTAssertEqual(classInfo.superCls, [NSObject class]);
    XCTAssertEqual(classInfo.metaCls, objc_getMetaClass("SFTestPropertyModel"));
    XCTAssertEqual(classInfo.isMeta, NO);
    
    Class meta = object_getClass([SFTestPropertyModel class]);
    SFClassInfo *metaClassInfo = [SFClassInfo classInfoWithClass:meta];
    XCTAssertNotNil(metaClassInfo);
    XCTAssertEqual(metaClassInfo.cls, meta);
    XCTAssertEqual(metaClassInfo.superCls, object_getClass([NSObject class]));
    XCTAssertEqual(metaClassInfo.metaCls, nil);
    XCTAssertEqual(metaClassInfo.isMeta, YES);
}

- (void)testClassInfo {
    SFClassInfo *info = [SFClassInfo classInfoWithClass:[SFTestPropertyModel class]];
    XCTAssertEqual([self getType:info name:@"boolValue"] & SFEncodingTypeMask, SFEncodingTypeBool);
#ifdef OBJC_BOOL_IS_BOOL
    XCTAssertEqual([self getType:info name:@"BOOLValue"] & SFEncodingTypeMask, SFEncodingTypeBool);
#else
    XCTAssertEqual([self getType:info name:@"BOOLValue"] & SFEncodingTypeMask, SFEncodingTypeInt8);
#endif
    XCTAssertEqual([self getType:info name:@"charValue"] & SFEncodingTypeMask, SFEncodingTypeInt8);
    XCTAssertEqual([self getType:info name:@"unsignedCharValue"] & SFEncodingTypeMask, SFEncodingTypeUInt8);
    XCTAssertEqual([self getType:info name:@"shortValue"] & SFEncodingTypeMask, SFEncodingTypeInt16);
    XCTAssertEqual([self getType:info name:@"unsignedShortValue"] & SFEncodingTypeMask, SFEncodingTypeUInt16);
    XCTAssertEqual([self getType:info name:@"intValue"] & SFEncodingTypeMask, SFEncodingTypeInt32);
    XCTAssertEqual([self getType:info name:@"unsignedIntValue"] & SFEncodingTypeMask, SFEncodingTypeUInt32);
#ifdef __LP64__
    XCTAssertEqual([self getType:info name:@"longValue"] & SFEncodingTypeMask, SFEncodingTypeInt64);
    XCTAssertEqual([self getType:info name:@"unsignedLongValue"] & SFEncodingTypeMask, SFEncodingTypeUInt64);
    XCTAssertEqual(SFEncodingGetType("l") & SFEncodingTypeMask, SFEncodingTypeInt32); // long in 32 bit system
    XCTAssertEqual(SFEncodingGetType("L") & SFEncodingTypeMask, SFEncodingTypeUInt32); // unsingle long in 32 bit system
#else
    XCTAssertEqual([self getType:info name:@"longValue"] & SFEncodingTypeMask, SFEncodingTypeInt32);
    XCTAssertEqual([self getType:info name:@"unsignedLongValue"] & SFEncodingTypeMask, SFEncodingTypeUInt32);
#endif
    XCTAssertEqual([self getType:info name:@"longLongValue"] & SFEncodingTypeMask, SFEncodingTypeInt64);
    XCTAssertEqual([self getType:info name:@"unsignedLongLongValue"] & SFEncodingTypeMask, SFEncodingTypeUInt64);
    XCTAssertEqual([self getType:info name:@"floatValue"] & SFEncodingTypeMask, SFEncodingTypeFloat);
    XCTAssertEqual([self getType:info name:@"doubleValue"] & SFEncodingTypeMask, SFEncodingTypeDouble);
    XCTAssertEqual([self getType:info name:@"longDoubleValue"] & SFEncodingTypeMask, SFEncodingTypeLongDouble);
    
    XCTAssertEqual([self getType:info name:@"objectValue"] & SFEncodingTypeMask, SFEncodingTypeObject);
    XCTAssertEqual([self getType:info name:@"arrayValue"] & SFEncodingTypeMask, SFEncodingTypeObject);
    XCTAssertEqual([self getType:info name:@"classValue"] & SFEncodingTypeMask, SFEncodingTypeClass);
    XCTAssertEqual([self getType:info name:@"selectorValue"] & SFEncodingTypeMask, SFEncodingTypeSEL);
    XCTAssertEqual([self getType:info name:@"blockValue"] & SFEncodingTypeMask, SFEncodingTypeBlock);
    XCTAssertEqual([self getType:info name:@"pointerValue"] & SFEncodingTypeMask, SFEncodingTypePointer);
    XCTAssertEqual([self getType:info name:@"functionPointerValue"] & SFEncodingTypeMask, SFEncodingTypePointer);
    XCTAssertEqual([self getType:info name:@"structValue"] & SFEncodingTypeMask, SFEncodingTypeStruct);
    XCTAssertEqual([self getType:info name:@"unionValue"] & SFEncodingTypeMask, SFEncodingTypeUnion);
    XCTAssertEqual([self getType:info name:@"cStringValue"] & SFEncodingTypeMask, SFEncodingTypeCString);
    
    XCTAssertEqual(SFEncodingGetType(@encode(void)) & SFEncodingTypeMask, SFEncodingTypeVoid);
    XCTAssertEqual(SFEncodingGetType(@encode(int[10])) & SFEncodingTypeMask, SFEncodingTypeCArray);
    XCTAssertEqual(SFEncodingGetType("") & SFEncodingTypeMask, SFEncodingTypeUnknown);
    XCTAssertEqual(SFEncodingGetType(".") & SFEncodingTypeMask, SFEncodingTypeUnknown);
    XCTAssertEqual(SFEncodingGetType("ri") & SFEncodingTypeQualifierMask, SFEncodingTypeQualifierConst);
    XCTAssertEqual([self getMethodTypeWithName:@"testIn:"] & SFEncodingTypeQualifierMask, SFEncodingTypeQualifierIn);
    XCTAssertEqual([self getMethodTypeWithName:@"testOut:"] & SFEncodingTypeQualifierMask, SFEncodingTypeQualifierOut);
    XCTAssertEqual([self getMethodTypeWithName:@"testInout:"] & SFEncodingTypeQualifierMask, SFEncodingTypeQualifierInout);
    XCTAssertEqual([self getMethodTypeWithName:@"testBycopy:"] & SFEncodingTypeQualifierMask, SFEncodingTypeQualifierBycopy);
    XCTAssertEqual([self getMethodTypeWithName:@"testByref:"] & SFEncodingTypeQualifierMask, SFEncodingTypeQualifierByref);
    XCTAssertEqual([self getMethodTypeWithName:@"testOneway:"] & SFEncodingTypeQualifierMask, SFEncodingTypeQualifierOneway);
    
    XCTAssert([self getType:info name:@"nonatomicValue"] & SFEncodingTypePropertyMask &SFEncodingTypePropertyNonatomic);
    XCTAssert([self getType:info name:@"aCopyValue"] & SFEncodingTypePropertyMask & SFEncodingTypePropertyCopy);
    XCTAssert([self getType:info name:@"strongValue"] & SFEncodingTypePropertyMask & SFEncodingTypePropertyRetain);
    XCTAssert([self getType:info name:@"retainValue"] & SFEncodingTypePropertyMask & SFEncodingTypePropertyRetain);
    XCTAssert([self getType:info name:@"weakValue"] & SFEncodingTypePropertyMask & SFEncodingTypePropertyWeak);
    XCTAssert([self getType:info name:@"readonlyValue"] & SFEncodingTypePropertyMask & SFEncodingTypePropertyReadonly);
    XCTAssert([self getType:info name:@"dynamicValue"] & SFEncodingTypePropertyMask & SFEncodingTypePropertyDynamic);
    XCTAssert([self getType:info name:@"getterValue"] & SFEncodingTypePropertyMask &SFEncodingTypePropertyCustomGetter);
    XCTAssert([self getType:info name:@"setterValue"] & SFEncodingTypePropertyMask & SFEncodingTypePropertyCustomSetter);
}

- (SFEncodingType)getType:(SFClassInfo *)info name:(NSString *)name {
    return ((SFClassPropertyInfo *)info.propertyInfos[name]).type;
}

- (SFEncodingType)getMethodTypeWithName:(NSString *)name {
    SFTestPropertyModel *model = [SFTestPropertyModel new];
    NSMethodSignature *sig = [model methodSignatureForSelector:NSSelectorFromString(name)];
    const char *typeName = [sig getArgumentTypeAtIndex:2];
    return SFEncodingGetType(typeName);
}

@end
