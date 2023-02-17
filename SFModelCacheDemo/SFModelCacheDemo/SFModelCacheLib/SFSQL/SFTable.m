//
//  SFTable.m
//  SFModel
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "SFTable.h"
#import "SFSimpleObject.h"
#import "NSObject+SFModel.h"
#import "FMDatabase.h"
#import <objc/message.h>

@interface SFTable ()

@end

@implementation SFTable

+ (BOOL)sf_createTable:(Class)modelClass{
    NSString *tableName = [modelClass sf_tableName];
    NSArray *propertyNames = [modelClass sf_propertyNames];
    NSString *propertyNamesStr = [propertyNames componentsJoinedByString:@","];
    NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists %@(%@)",tableName, propertyNamesStr];
    BOOL ret = [[SFSimpleObject manager].dataBase executeUpdate:sqlStr];
    return ret;
}

+ (BOOL)sf_removeTable:(Class)modelClass{
    NSString *tableName = [modelClass sf_tableName];
    NSMutableString *sqlStr = [[NSMutableString alloc]initWithFormat:@"drop table %@",tableName];
    BOOL ret = [[SFSimpleObject manager].dataBase executeUpdate:sqlStr];
    return ret;
}

+ (BOOL)sf_removeAllTables{
    [[SFSimpleObject manager].dataBase close];
    [SFSimpleObject manager].dataBase = nil;
    BOOL ret = [[NSFileManager defaultManager] removeItemAtPath:[SFSimpleObject manager].dataBasePath error:nil];
    return ret;
}

+ (BOOL)sf_clearTable:(Class)modelClass{
    NSString *tableName = [modelClass sf_tableName];
    NSMutableString *sqlStr = [[NSMutableString alloc]initWithFormat:@"delete from %@",tableName];
    BOOL ret = [[SFSimpleObject manager].dataBase executeUpdate:sqlStr];
    return ret;
}

+ (void)sf_insertModel:(NSObject *)model completed:(void(^)(NSError *error))completed{
    NSDictionary *modelDict = [model sf_modelToJSONObject];
    NSString *tableName = [model sf_tableName];
    NSArray *fieldNameArr = modelDict.allKeys;
    NSMutableArray *valueArr = [[NSMutableArray alloc]init];
    for (int i = 0; i<fieldNameArr.count; i++) {
        id value = [modelDict objectForKey:fieldNameArr[i]];
        NSString *valueStr = @"";
        if([value isKindOfClass:[NSArray class]]){
            NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            valueStr = [NSString stringWithFormat:@"%@$$%@",dataStr, @"NSArray"];
        }else if([value isKindOfClass:[NSDictionary class]]){
            NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            valueStr = [NSString stringWithFormat:@"%@$$%@",dataStr, @"NSDictionary"];
        } else {
            valueStr = [NSString stringWithFormat:@"%@",value];
        }
        [valueArr addObject:[NSString stringWithFormat:@"'%@'",valueStr]];
    }
    NSString *fieldNameAll = [fieldNameArr componentsJoinedByString:@","];
    NSString *valueAll = [valueArr componentsJoinedByString:@","];
    NSString *sqlStr = [NSString stringWithFormat:@"insert into %@(%@) values(%@)",tableName,fieldNameAll,valueAll];
    BOOL ret = [[SFSimpleObject manager].dataBase executeUpdate:sqlStr];
    if(completed){
        completed(ret ? nil : [SFSimpleObject manager].dataBase.lastError);
    }
}
+ (void)sf_insertModels:(NSArray *)models completed:(void(^)(NSError *error))completed{
    dispatch_semaphore_wait([SFSimpleObject manager].dsema, DISPATCH_TIME_FOREVER);
    @autoreleasepool {
        [models enumerateObjectsUsingBlock:^(id model, NSUInteger idx, BOOL * _Nonnull stop) {
            [self sf_insertModel:model completed:^(NSError *error) {
                if (error) {*stop = YES;}
                if(completed && error){
                    completed([SFSimpleObject manager].dataBase.lastError);
                }
            }];
        }];
    }
    dispatch_semaphore_signal([SFSimpleObject manager].dsema);
}

+ (BOOL)sf_deleteModel:(Class)modelClass where:(NSString *)sqlStr{
    NSString *tableName = [modelClass sf_tableName];
    NSString *deleteSql = [NSString stringWithFormat:@"delete from %@ where %@",tableName, sqlStr];
    BOOL ret = [[SFSimpleObject manager].dataBase executeUpdate:deleteSql];
    return ret;
}

+ (void)sf_updateModel:(NSObject *)model byKey:(NSString *)key completed:(void(^)(NSError *error))completed{
    NSString *tableName = [model sf_tableName];
    NSDictionary *modelDict = [model sf_modelToJSONObject];
    NSArray *fieldNameArr = modelDict.allKeys;
    NSMutableArray *valueArr = [[NSMutableArray alloc]init];
    for (int i = 0; i<fieldNameArr.count; i++) {
        id value = [modelDict objectForKey:fieldNameArr[i]];
        NSString *valueStr = @"";
        if([value isKindOfClass:[NSArray class]]){
            NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            valueStr = [NSString stringWithFormat:@"%@$$%@",dataStr, @"NSArray"];
        }else if([value isKindOfClass:[NSDictionary class]]){
            NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
            NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            valueStr = [NSString stringWithFormat:@"%@$$%@",dataStr, @"NSDictionary"];
        } else {
            valueStr = [NSString stringWithFormat:@"%@",value];
        }
        [valueArr addObject:[NSString stringWithFormat:@"%@ = '%@'",fieldNameArr[i],valueStr]];
    }
    NSString *valueAll = [valueArr componentsJoinedByString:@","];
    NSString *sqlStr = [NSString stringWithFormat:@"update %@ set %@ where %@ = '%@'",tableName, valueAll, key, [modelDict objectForKey:key]];
    BOOL ret = [[SFSimpleObject manager].dataBase executeUpdate:sqlStr];
    if(completed){
        completed(ret ? nil : [SFSimpleObject manager].dataBase.lastError);
    }
}

+ (void)sf_updateModels:(NSArray *)models byKey:(NSString *)key completed:(void(^)(NSError *error))completed{
    dispatch_semaphore_wait([SFSimpleObject manager].dsema, DISPATCH_TIME_FOREVER);
    @autoreleasepool {
        [models enumerateObjectsUsingBlock:^(id model, NSUInteger idx, BOOL * _Nonnull stop) {
            [self sf_updateModel:model byKey:key completed:^(NSError *error) {
                if (error) {*stop = YES;}
                if(completed && error){
                    completed([SFSimpleObject manager].dataBase.lastError);
                }
            }];
        }];
    }
    dispatch_semaphore_signal([SFSimpleObject manager].dsema);
}

+ (void)sf_selectTable:(Class)modelClass completed:(void(^)(NSError *error, NSArray *models))completed{
    [self sf_selectTable:modelClass where:nil completed:completed];
}

+ (void)sf_selectTable:(Class)modelClass where:(NSString * _Nullable)sqlStr completed:(void(^)(NSError *error, NSArray *models))completed{
    NSString *tableName = [modelClass sf_tableName];
    NSString *sqlString;
    if (sqlStr.length > 0) {
        sqlString = [NSString stringWithFormat:@"select * from %@ where %@",tableName, sqlStr];
    } else {
        sqlString = [NSString stringWithFormat:@"select * from %@",tableName];
    }
    FMResultSet *set = [[SFSimpleObject manager].dataBase executeQuery:sqlString];
    NSMutableArray *mutableArr = [[NSMutableArray alloc]init];
    while ([set next]){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        for (int i = 0; i<set.columnCount; i++) {
            NSString *key = [set columnNameForIndex:i];
            id value = [set stringForColumnIndex:i];
            NSArray *valueArr = [value componentsSeparatedByString:@"$$"];
            NSError *error;
            
            if ([valueArr.lastObject isEqualToString:@"NSArray"]){
                NSData *data = [valueArr.firstObject dataUsingEncoding:NSUTF8StringEncoding];
                value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            }else if ([valueArr.lastObject isEqualToString:@"NSDictionary"]){
                NSData *data = [valueArr.firstObject dataUsingEncoding:NSUTF8StringEncoding];
                value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            } else {
            }
            [dict setValue:value forKey:key];
        }
        id object = ((id(*)(id, SEL))objc_msgSend)(modelClass, NSSelectorFromString(@"new"));
        BOOL success = [object sf_modelSetWithDictionary:dict];
        if (!success) {
            NSLog(@"字典转模型失败");
        } else {
            [mutableArr addObject:object];
        }
    }
    [set close];
    if(completed){
        completed([SFSimpleObject manager].dataBase.lastError, mutableArr);
    }
}

+ (NSInteger)sf_selectTableCount:(Class)modelClass{
    NSString *tableName = [modelClass sf_tableName];
    NSString *sqlStr = [NSString stringWithFormat:@"select count(*) count from %@",tableName];
    FMResultSet *set = [[SFSimpleObject manager].dataBase executeQuery:sqlStr];
    NSInteger totalCount = -1;
    while ([set next]) {
        totalCount = [set intForColumn:@"count"];
    }
    return totalCount;
}

/// 根据条件查询某个表部分数据条数
/// @param modelClass model class
/// @param sqlStr 参数键值对
+ (NSInteger)sf_selectTableCount:(Class)modelClass where:(NSString *)sqlStr{
    NSString *tableName = [modelClass sf_tableName];
    if(sqlStr.length > 0){
        sqlStr = [NSString stringWithFormat:@"select count(*) count from %@ where %@",tableName, sqlStr];
    }else{
        sqlStr = [NSString stringWithFormat:@"select count(*) count from %@",tableName];
    }
    FMResultSet *set = [[SFSimpleObject manager].dataBase executeQuery:sqlStr];
    NSInteger totalCount = -1;
    while ([set next]) {
        totalCount = [set intForColumn:@"count"];
    }
    return totalCount;
}

+ (BOOL)sf_addProperty:(Class)modelClass propertyName:(NSString *)propertyName{
    NSString *tableName = [modelClass sf_tableName];
    NSString *alertStr = [NSString stringWithFormat:@"alter table %@ add %@",tableName, propertyName];
    BOOL ret = [[SFSimpleObject manager].dataBase executeUpdate:alertStr];
    return ret;
}

+ (NSError *)sf_lastTableError{
    return [SFSimpleObject manager].dataBase.lastError;
}

@end
