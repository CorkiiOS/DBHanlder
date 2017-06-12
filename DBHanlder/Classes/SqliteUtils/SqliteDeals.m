//
//  SqliteDeals.m
//  SQlDemo
//
//  Created by mac on 2016/5/29.
//  Copyright © 2017年 Corki. All rights reserved.
//

#import "SqliteDeals.h"
#import "SqliteFileManager.h"
#import <sqlite3.h>

static sqlite3 *_db;

@implementation SqliteDeals
/**
 执行sql
 
 @param sql 语句 insert update
 @param udid 用户体系
 @return yes or no
 */
+ (BOOL)dealSql:(NSString *)sql udid:(NSString *)udid {
    
    [self openDBWithUID:udid];
    
    BOOL result = sqlite3_exec(_db, sql.UTF8String, nil, nil, nil) == SQLITE_OK;
    
    [self closeDBWithUID:udid];
    
    return result;
}

/**
 执行查询语句
 
 @param sql sql语句
 @param udid 用户体系
 @return 结果集
 */
+ (NSArray<NSDictionary *> *)querySql:(NSString *)sql udid:(NSString *)udid {
    
    
    [self openDBWithUID:udid];
    
    
    // "select * from t_stu";
    
    // 准备语句
    
    // 1. 创建一个准备语句
    sqlite3_stmt *ppStmt;
    if (sqlite3_prepare(_db, sql.UTF8String, -1, &ppStmt, nil) != SQLITE_OK) {
        
        NSLog(@"预处理失败");
        sqlite3_finalize(ppStmt);
        [self closeDBWithUID:udid];
        return nil;
    }
    
    NSMutableArray *rowDicArray = [NSMutableArray array];
    
    
    // 2. 执行
    // 如果下一行有记录, 就会返回 SQLITE_ROW, 会自动移动指针, 到下一行
    while (sqlite3_step(ppStmt) == SQLITE_ROW) {
        // 一条记录 , 都会执行这个循环
        // 解析一条记录 (列,  每一列的列名, 每一列的值)
        
        // 1. 获取, 列的个数
        int columnCount = sqlite3_column_count(ppStmt);
        
        
        NSMutableDictionary *rowDic = [NSMutableDictionary dictionary];
        [rowDicArray addObject:rowDic];
        // 2. 遍历列 (列名, 值)
        for (int i = 0; i < columnCount; i++) {
            // 这一行的每一列
            // 列名
            NSString *columnName = [NSString stringWithUTF8String:sqlite3_column_name(ppStmt, i)];
            
            
            
            // 列的值
            // 不同的列, 如果类型不同, 我们需要使用不同的函数, 获取响应的值
            // 1. 获取这一列对应的类型
            int type = sqlite3_column_type(ppStmt, i);
            
            // 2. 根据不同的类型, 使用不同的函数,获取相应的值
            
            //#define SQLITE_INTEGER  1
            //#define SQLITE_FLOAT    2
            //#define SQLITE_BLOB     4
            //#define SQLITE_NULL     5
            //#define SQLITE3_TEXT     3
            
            
            id value;
            
            switch (type) {
                case SQLITE_INTEGER:
                {
                    //                    NSLog(@"整形");
                    value = @(sqlite3_column_int(ppStmt, i));
                    break;
                }
                case SQLITE_FLOAT:
                {
                    //                    NSLog(@"浮点");
                    value = @(sqlite3_column_double(ppStmt, i));
                    break;
                }
                case SQLITE_BLOB:
                {
                    //                    NSLog(@"二进制");
                    value = CFBridgingRelease(sqlite3_column_blob(ppStmt, i));
                    break;
                }
                case SQLITE_NULL:
                {
                    //                    NSLog(@"空");
                    value = @"";
                    break;
                }
                case SQLITE3_TEXT:
                {
                    //                    NSLog(@"文本");
                    const char *valueC = (const char *)sqlite3_column_text(ppStmt, i);
                    
                    value = [NSString stringWithUTF8String:valueC];
                    
                    break;
                }
                    
                default:
                    break;
            }
            
            
            //            NSLog(@"%@---%@", columnName, value);
            
            [rowDic setValue:value forKey:columnName];
            
        }
        
        
        
    }
    
    
    
    // 3. 释放
    sqlite3_finalize(ppStmt);
    [self closeDBWithUID:udid];
    
    
    return rowDicArray;
}

#pragma mark - private

+ (BOOL)openDBWithUID: (NSString *)udid {
    // 确定哪个数据库
    // cache 默认的
    NSString *dbPath = [SqliteFileManager buidlFolderWithName:nil];
    if (udid.length == 0) {
        dbPath = [dbPath stringByAppendingPathComponent:@"common.db"];
    }else {
        dbPath = [dbPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db", udid]];
    }
    
    const char * path = [dbPath fileSystemRepresentation];
    
    // 1. 打开数据库(如果数据库不存在, 创建)
    
    if (sqlite3_open(path, &_db) != SQLITE_OK) {
        NSLog(@"打开数据库失败");
        return NO;
    }
    return YES;
    
}

+ (void)closeDBWithUID: (NSString *)udid {
    
    // 3. 关闭数据库
    sqlite3_close(_db);
    
}

@end
