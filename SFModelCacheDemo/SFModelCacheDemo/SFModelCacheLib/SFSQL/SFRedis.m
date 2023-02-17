//
//  SFRedis.m
//  SFModel
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "SFRedis.h"
#import "SFTable.h"
#import "FMDatabase.h"
#import "NSObject+SFModel.h"
#import "SFSimpleObject.h"
#import <objc/message.h>

@interface SFRedisModel : NSObject

@property (nonatomic,  copy) NSString *key;
@property (nonatomic,  copy) id value;

@end

@implementation SFRedisModel

@end

@interface SFRedis ()

@property (nonatomic,  copy) NSString *tableName;

@end

@implementation SFRedis

+ (void)initialize{
    [SFTable sf_createTable:SFRedisModel.class];
}


//value=123$$type=String
+ (id)sf_valueForKey:(NSString *)key{
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@ where key = '%@'", self.tableName, key];
    FMResultSet *set = [[SFSimpleObject manager].dataBase executeQuery:sqlStr];
    NSMutableArray *models = [[NSMutableArray alloc]init];
    while ([set next]){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        for (int i = 0; i<set.columnCount; i++) {
            [dict setValue:[set stringForColumnIndex:i] forKey:[set columnNameForIndex:i]];
        }
        [models addObject:dict];
    }
    
    [set close];
    
    if(models.count == 0){
        return nil;
    }
    return [NSObject sf_decodeSQLString:[models.firstObject objectForKey:@"value"]];
}

+ (void)sf_setValue:(id)value forKey:(NSString *)key{
    if(value == nil){
        [self sf_removeObjectForKey:key];
    }else{
        NSString *valueStr = [value sf_toSQLString];
        
        BOOL isScu = NO;
        NSString *sqlStr = nil;
        if([self sf_valueForKey:key] == nil){
            //插入
            sqlStr = [NSString stringWithFormat:@"insert into %@ (key, value) values('%@', '%@')",self.tableName, key, valueStr];
            isScu = [[SFSimpleObject manager].dataBase executeUpdate:sqlStr];
        }else{
            //修改
            sqlStr = [NSString stringWithFormat:@"update %@ set value = '%@' where key = '%@'",self.tableName, valueStr, key];
            isScu = [[SFSimpleObject manager].dataBase executeUpdate:sqlStr];
        }
        if(!isScu){
            [self sf_printError];
        }
    }
}

+ (void)sf_setValuesForKeysWithDictionary:(NSDictionary<NSString *, id> *)keyedValues{
    [keyedValues enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self sf_setValue:obj forKey:key];
    }];
}

+ (void)sf_removeObjectForKey:(NSString *)key{
    NSString *sqlStr = [NSString stringWithFormat:@"delete from %@ where key = '%@'",self.tableName, key];
    BOOL isScu = [[SFSimpleObject manager].dataBase executeUpdate:sqlStr];
    if(!isScu){
        [self sf_printError];
    }
}

+ (void)sf_removeObjectsForKeys:(NSArray<NSString *> *)keys{
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self sf_removeObjectForKey:obj];
    }];
}

+ (void)sf_removeAllObjects{
    NSMutableString *sqlStr = [[NSMutableString alloc]initWithFormat:@"delete from %@",self.tableName];
    BOOL isScu = [[SFSimpleObject manager].dataBase executeUpdate:sqlStr];
    if(!isScu){
        [self sf_printError];
    }
}

+ (NSDictionary *)sf_dictionaryWithValuesForKeys:(NSArray<NSString *> *)keys{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (NSString *key in keys) {
        id value = [self sf_valueForKey:key];
        [dict setObject:value forKey:key];
    }
    return dict;
}

+ (NSArray *)sf_allKeys{
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@",self.tableName];
    FMResultSet *set = [[SFSimpleObject manager].dataBase executeQuery:sqlStr];
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
    while ([set next]){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        for (int i = 0; i<set.columnCount; i++) {
            [dict setValue:[set stringForColumnIndex:i] forKey:[set columnNameForIndex:i]];
        }
        [mutableDict setValue:dict[@"value"] forKey:dict[@"key"]];
    }
    [set close];
    
    return mutableDict.allKeys;
}

+ (NSArray *)sf_allValues{
    NSString *sqlStr = [NSString stringWithFormat:@"select * from %@",self.tableName];
    FMResultSet *set = [[SFSimpleObject manager].dataBase executeQuery:sqlStr];
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
    while ([set next]){
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        for (int i = 0; i<set.columnCount; i++) {
            [dict setValue:[set stringForColumnIndex:i] forKey:[set columnNameForIndex:i]];
        }
        [mutableDict setValue:dict[@"value"] forKey:dict[@"key"]];
    }
    [set close];
    return mutableDict.allValues;
}

+ (NSInteger)sf_count{
    NSString *sqlStr = [NSString stringWithFormat:@"select count(*) count from %@",self.tableName];
    FMResultSet *set = [[SFSimpleObject manager].dataBase executeQuery:sqlStr];
    NSInteger count = -1;
    while ([set next]) {
        count = [set intForColumn:@"count"];
    }
    return count;
}

+ (NSString *)tableName{
    return [SFRedisModel sf_tableName];
}

+ (BOOL)sf_isExistkey:(NSString *)key{
    NSString *sqlStr = [NSString stringWithFormat:@"select count(*) count from %@ where key = '%@'",self.tableName, key];
    FMResultSet *set = [[SFSimpleObject manager].dataBase executeQuery:sqlStr];
    NSInteger count = -1;
    while ([set next]) {
        count = [set intForColumn:@"count"];
    }
    return count > 0 ? YES : NO;
}

+ (NSError *)sf_lastRedisError{
    return [SFSimpleObject manager].dataBase.lastError;
}

+ (void)sf_printError{
    if([SFSimpleObject manager].printRedisError){
        NSLog(@"SFRedis Error == %@",[SFSimpleObject manager].dataBase.lastError);
    }
}

@end
