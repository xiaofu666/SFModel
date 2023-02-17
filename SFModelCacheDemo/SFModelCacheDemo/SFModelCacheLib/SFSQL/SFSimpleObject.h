//
//  SFSimpleObject.h
//  SFModel
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>
@class FMDatabase;

@interface SFSimpleObject : NSObject

+ (SFSimpleObject *)manager;

/// 数据库FMDB
@property (nonatomic,retain) FMDatabase *dataBase;

/// 信号量
@property (nonatomic,strong) dispatch_semaphore_t dsema;

/// 数据库路径
@property (nonatomic,  copy) NSString *dataBasePath;

/// 是否打印Reddis错误
@property (nonatomic,assign) BOOL printRedisError;

@end
