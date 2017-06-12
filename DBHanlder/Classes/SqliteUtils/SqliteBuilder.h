//
//  SqliteBuilder.h
//  SQlDemo
//
//  Created by mac on 2016/5/29.
//  Copyright © 2016年 Corki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISqliteModel.h"
@interface SqliteBuilder : NSObject

//本类用于构建sql语句
/**
 建表sql

 @param object id
 @return sql
 */
+ (NSString *)tableSqlBuildWithObject:(id<ISqliteModel>)object
                                 udid:(NSString *)udid;


/**
 插入 或者 更新 数据

 @param object 模型
 @return sql 语句
 */
+ (NSString *)saveSqlBuildWithObject:(id<ISqliteModel>)object
                                udid:(NSString *)udid;

/**
 插入 或者 更新 数据
 
 @param cls 类
 @return udid 用户体系
 */
+ (NSString *)queryAllSqlBuildWithClass:(Class)cls
                                   udid:(NSString *)udid;

/**
 根据主键查询数据
 
 @param cls class
 @param key 主键
 @param udid 用户id
 @return sql
 */
+ (NSString *)querySqlBuildWithClass:(Class)cls
                                    key:(NSString *)key
                                   udid:(NSString *)udid;

/**
 删除 根据主键删除
 
 @param object 类
 @return udid 用户体系
 */
+ (NSString *)deleteSqlBuildWithObject:(id)object
                                 udid:(NSString *)udid;

/**
 删除表中所有数据
 
 @param cls 表名字
 @param udid 用户id
 @return sql
 */
+ (NSString *)deleteAllSqlBuildWithCls:(Class)cls
                                  udid:(NSString *)udid;


/**
 构建 insert sql

 @param object 模型
 @param udid 用户id
 @return sql
 */
+ (NSString *)insertSqlBuildWithObject:(id)object
                                  udid:(NSString *)udid;
/**
 构建 uodate sql
 
 @param object 模型
 @param udid 用户id
 @return sql
 */
+ (NSString *)updateSqlBuildWithObject:(id)object
                                  udid:(NSString *)udid;

+ (NSString *)querySqlBuildWithObject:(id)object
                                 udid:(NSString *)udid;
@end
