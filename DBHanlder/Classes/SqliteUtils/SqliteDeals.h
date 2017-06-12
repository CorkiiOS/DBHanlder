//
//  SqliteDeals.h
//  SQlDemo
//
//  Created by mac on 2016/5/29.
//  Copyright © 2016年 Corki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SqliteDeals : NSObject

/**
 执行sql
 
 @param sql 语句 insert update
 @param udid 用户体系
 @return yes or no
 */
+ (BOOL)dealSql:(NSString *)sql
           udid:(NSString *)udid;

/**
 执行查询语句
 
 @param sql sql语句
 @param udid 用户体系
 @return 结果集
 */
+ (NSArray<NSDictionary *> *)querySql:(NSString *)sql
                                 udid:(NSString *)udid;

@end
