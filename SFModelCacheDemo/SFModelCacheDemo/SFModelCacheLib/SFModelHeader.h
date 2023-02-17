//
//  SFModel.h
//  SFModel 
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <Foundation/Foundation.h>

#if __has_include(<SFModel/SFModel.h>)

FOUNDATION_EXPORT double SFModelVersionNumber;
FOUNDATION_EXPORT const unsigned char SFModelVersionString[];

#import <SFModel/SFTable.h>
#import <SFModel/SFRedis.h>
#import <SFModel/SFClassInfo.h>
#import <SFModel/NSObject+SFModel.h>

#else

//表相关操作类
#import "SFTable.h"
//键值对操作类
#import "SFRedis.h"
//类相关信息
#import "SFClassInfo.h"
//模型相关操作
#import "NSObject+SFModel.h"

#endif
