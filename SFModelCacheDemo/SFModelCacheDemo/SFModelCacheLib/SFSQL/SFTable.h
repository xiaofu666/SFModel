//
//  SFTable.h
//  SFModel
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFTable : NSObject

/// 创建表
/// @param modelClass model class
+ (BOOL)sf_createTable:(Class)modelClass;

/// 删除表
/// @param modelClass model class
+ (BOOL)sf_removeTable:(Class)modelClass;

/// 删除数据库
+ (BOOL)sf_removeAllTables;

/// 清空表
/// @param modelClass model class
+ (BOOL)sf_clearTable:(Class)modelClass;

/// 根据数据模型插入一条数据
/// @param model 数据模型
/// @param completed 操作回调
+ (void)sf_insertModel:(NSObject *)model completed:(void(^)(NSError *error))completed;

/// 根据数据模型数组插入多条数据
/// @param models 数据模型数组
/// @param completed 操作回调
+ (void)sf_insertModels:(NSArray *)models completed:(void(^)(NSError *error))completed;

/// 删除数据
/// @param modelClass model class
/// @param sqlStr sql语句
+ (BOOL)sf_deleteModel:(Class)modelClass where:(NSString * _Nullable)sqlStr;

/// 根据key修改单条数据
/// @param model 数据模型
/// @param key key
/// @param completed 操作回调
+ (void)sf_updateModel:(NSObject *)model byKey:(NSString *)key completed:(void(^)(NSError *error))completed;

/// 根据key修改多条数据
/// @param models 数据模型数组
/// @param key key
/// @param completed 操作回调
+ (void)sf_updateModels:(NSArray *)models byKey:(NSString *)key completed:(void(^)(NSError *error))completed;

/// 查询某个表的全部数据
/// @param modelClass model class
/// @param completed 操作回调
+ (void)sf_selectTable:(Class)modelClass completed:(void(^)(NSError *error, NSArray *models))completed;

/// 根据条件查询某个表的数据
/// @param modelClass model class
/// @param sqlStr sql
/// @param completed 操作回调
+ (void)sf_selectTable:(Class)modelClass where:(NSString * _Nullable)sqlStr completed:(void(^)(NSError *error, NSArray *models))completed;

/// 查询某个表的全部数据条数
/// @param modelClass model class
+ (NSInteger)sf_selectTableCount:(Class)modelClass;

/// 根据条件查询某个表部分数据条数
/// @param modelClass model class
/// @param sqlStr sql
+ (NSInteger)sf_selectTableCount:(Class)modelClass where:(NSString * _Nullable)sqlStr;

/// 向某个表添加一个字段
/// @param modelClass model class
/// @param propertyName 属性字段
+ (BOOL)sf_addProperty:(Class)modelClass propertyName:(NSString *)propertyName;

/// 最后一条错误信息
+ (NSError *)sf_lastTableError;

@end

NS_ASSUME_NONNULL_END
