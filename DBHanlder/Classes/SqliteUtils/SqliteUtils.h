//
//  SqliteUtils.h
//  SQlDemo
//
//  Created by mac on 2016/5/29.
//  Copyright © 2016年 Corki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISqliteModel.h"
@interface SqliteUtils : NSObject

/**
 保存模型，存在则更新
 @param object 数据模型
 @param udid 用户体系
 @return 结果
 */
+ (BOOL)saveObjcet:(id<ISqliteModel>)object
              udid:(NSString *)udid;

/**
 删除模型
 @param object 数据模型
 @param udid 用户体系
 @return 结果
 */
+ (BOOL)deleteObjcet:(id<ISqliteModel>)object
                udid:(NSString *)udid;

/**
 查询表中所有的数据

 @param cls 类名字
 @param udid 用户体系所用
 @return 结果集
 */
+ (NSArray *)queryAllObjectsWithClass:(Class)cls
                                 udid:(NSString *)udid;

/**
 查询表中所有的数据
 
 @param cls 类名字 key 
 @param udid 用户体系所用
 @return 结果集
 */
+ (id)queryObjectsWithClass:(Class)cls
                               key:(NSString *)key
                                 udid:(NSString *)udid;
@end

