//
//  SFSimpleObject.m
//  SFModel
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "SFSimpleObject.h"
#import "FMDatabase.h"
#import "SFTable.h"

// 数据库名字
#define KDataBaseName @"SFRedisDataBase.sqlite"
//数据库路径
#define KDataBasePath [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",KDataBaseName]]

@interface SFSimpleObject ()

@end

@implementation SFSimpleObject

static SFSimpleObject *simObj;

+ (SFSimpleObject *)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        simObj = [[super allocWithZone:NULL] init];
    });
    return simObj;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [SFSimpleObject manager];
}

- (id)copyWithZone:(struct _NSZone *)zone{
    return [SFSimpleObject manager];
}

- (id)init{
    if (self = [super init]){
        self.dsema = dispatch_semaphore_create(1);
    }
    return self;
}

#pragma mark - 懒加载
- (FMDatabase *)dataBase{
    if(_dataBase == nil){
        NSLog(@"KDataBasePath == %@",KDataBasePath);
        _dataBase = [[FMDatabase alloc] initWithPath:KDataBasePath];
        [_dataBase open];
    }
    return _dataBase;
}

- (NSString *)dataBasePath{
    return KDataBasePath;
}

@end
