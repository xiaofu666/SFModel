//
//  SFRedis.h
//  SFModel
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFRedis : NSObject

/// 根据Key获取值
/// @param key key
+ (id)sf_valueForKey:(NSString *)key;

/// 根据key重新赋值
/// @param value value
/// @param key key
+ (void)sf_setValue:(id)value forKey:(NSString *)key;

/// 根据keys数组重新赋值
/// @param keyedValues (key:value)数组
+ (void)sf_setValuesForKeysWithDictionary:(NSDictionary<NSString *, id> *)keyedValues;

/// 根据key删除数据
/// @param key key
+ (void)sf_removeObjectForKey:(NSString *)key;

/// 根据keys数组删除数据
/// @param keys keys数组
+ (void)sf_removeObjectsForKeys:(NSArray<NSString *> *)keys;

/// 删除全部的数据
+ (void)sf_removeAllObjects;

/// 根据keys数组获取对应的字典
/// @param keys keys数组
+ (NSDictionary *)sf_dictionaryWithValuesForKeys:(NSArray<NSString *> *)keys;

/// 获取所以的keys
+ (NSArray *)sf_allKeys;

/// 获取所以的values
+ (NSArray *)sf_allValues;

/// 获取数据条数
+ (NSInteger)sf_count;

/// 检查某个key是否存在
+ (BOOL)sf_isExistkey:(NSString *)key;

/// 最后一条错误信息
+ (NSError *)sf_lastRedisError;

@end

NS_ASSUME_NONNULL_END
