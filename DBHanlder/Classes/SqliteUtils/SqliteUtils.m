//
//  SqliteUtils.m
//  SQlDemo
//
//  Created by mac on 2016/5/29.
//  Copyright © 2016年 Corki. All rights reserved.
//

#import "SqliteUtils.h"
#import "SqliteDeals.h"
#import "SqliteObject.h"
#import "SqliteBuilder.h"
@implementation SqliteUtils

/**
 判断表是否存在

 @param tableName 表名字
 @param udid udid
 @return 结果
 */
+ (BOOL)isTableExists: (NSString *)tableName
                 udid: (NSString *)udid {
    
    NSString *sql = @"select name from sqlite_master";
    NSArray <NSDictionary *>*resultSet = [SqliteDeals querySql:sql udid:udid];
    __block BOOL isTableExists = NO;
    
    [resultSet enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj[@"name"] lowercaseString] isEqualToString:[tableName lowercaseString]]) {
            isTableExists = YES;
        }
    }];
    return isTableExists;
}

/**
 创建表

 @param cls 模型类
 @param udid udid
 @return 结果
 */
+ (BOOL)createTableWithClass:(Class)cls
                        udid:(NSString *)udid {
    
    NSString *tableName = [SqliteObject getTableNameWithObjectClass:cls];

    BOOL isTableExists = [SqliteUtils isTableExists:tableName udid:udid];
    
    BOOL isSuccess  = YES;
    
    if (!isTableExists) {
        
        NSString *createSql = [SqliteBuilder tableSqlBuildWithObject:[cls new] udid:udid];
        
        isSuccess = [SqliteDeals dealSql:createSql udid:udid];
        
        if (!isSuccess) {
            
            NSLog(@"创建表失败");
            return isSuccess;
        }

    }
    
    return isSuccess;

}

+ (BOOL)saveObjcet:(id)object
              udid:(NSString *)udid {
    
    BOOL isBuildTableSuccess = [self createTableWithClass:[object class] udid:udid];
    
    if (!isBuildTableSuccess) {
        
        return NO;
    }
    
    NSString *saveSql = [SqliteBuilder saveSqlBuildWithObject:object udid:udid];
    
    BOOL isSaveSuccess = [SqliteDeals dealSql:saveSql udid:udid];
    
    if (!isSaveSuccess) {
        
        NSLog(@"保存失败");
    }
    
    return isSaveSuccess;
}

+ (BOOL)deleteObjcet:(id)object
                udid:(NSString *)udid {
    
    BOOL isBuildTableSuccess = [self createTableWithClass:[object class] udid:udid];
    
    if (!isBuildTableSuccess) {
        
        return NO;
    }
    
    NSString *sql = [SqliteBuilder deleteSqlBuildWithObject:object udid:udid];
    
    BOOL result = [SqliteDeals dealSql:sql udid:udid];

    return result;
}

+ (NSArray *)queryAllObjectsWithClass:(Class)cls
                                 udid:(NSString *)udid {
    
    NSString *sql = [SqliteBuilder queryAllSqlBuildWithClass:cls udid:udid];
    
    NSArray * resultsMap = [SqliteDeals querySql:sql udid:udid];
    
    NSArray *results = [self parseRowDicArray:resultsMap withModelClass:cls];
    
    return results;
}

+ (id)queryObjectsWithClass:(Class)cls
                               key:(NSString *)key
                              udid:(NSString *)udid {
    
    NSString *sql = [SqliteBuilder querySqlBuildWithClass:cls key:key udid:udid];
    
    NSArray * resultsMap = [SqliteDeals querySql:sql udid:udid];
    
    NSArray *results = [self parseRowDicArray:resultsMap withModelClass:cls];
    
    return results.firstObject;
}
#pragma mark - 私有方法

// 处理结果集
+ (NSArray *)parseRowDicArray:(NSArray *)rowDicArray
               withModelClass: (Class)cls {
    
    NSMutableArray *resultM = [NSMutableArray array];
    
    // 模型真正的字段 - > 类型
    NSDictionary *modelColumnNames = [SqliteObject getObjectIvarNameIvarTypeWithClass:cls];
    
    for (NSDictionary *rowDic in rowDicArray) {
        id model = [[cls alloc] init];
        [resultM addObject:model];
        
        [modelColumnNames enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            // key, 字段名称
            // obj, 类型
            
            id value = rowDic[key];
            if ([obj isEqualToString:@"NSArray"] || [obj isEqualToString:@"NSDictionary"]) {
                
                NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
                
                // NSJSONReadingMutableContainers
                value = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
            } else if ([obj isEqualToString:@"NSMutableArray"] || [obj isEqualToString:@"NSMutableDictionary"]) {
                
                
                NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
                //
                value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            }
            
            [model setValue:value forKeyPath:key];
            
        }];
        
    }
    
    return resultM;
}
@end
