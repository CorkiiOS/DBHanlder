//
//  ICSqliteBuilder.m
//  Pods
//
//  Created by mac on 2017/8/6.
//
//

#import "ICSqliteBuilder.h"
#import "ICClassInfo.h"
#import "ICClassIvarInfo.h"
@implementation ICSqliteBuilder

+ (NSString *)tableSqlBuildWithClass:(Class)cls
                                 udid:(NSString *)udid {
    
    if (![cls instancesRespondToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作你这个模型, 必须要通过 - (NSString *)primaryKey; 方法, 来提供一个主键给我");
        return nil;
    }
    
    ICClassInfo *info = [ICClassInfo classInfoWithClass:cls];
    NSString *primaryKey = [[cls new] primaryKey];
    NSString *tableName = info.name.lowercaseString;
    NSMutableArray *typeNames = [NSMutableArray array];
    
    for (ICClassIvarInfo *ivar in info.ivarInfos.allValues) {
        if (ivar.dbColunmName == nil) {
            continue;
        }
        NSString *text = [NSString stringWithFormat:@"%@ %@",ivar.name, ivar.dbColunmName];
        [typeNames addObject:text];
    }
    
    NSString *typeNameSql = [typeNames componentsJoinedByString:@","];
    NSString *bulidSql = [NSString stringWithFormat:@"create table if not exists %@ (%@ ,%@ %@ primary key not null )", tableName, typeNameSql, primaryKey, @"text"];
    return bulidSql;
}

//+ (NSString *)insertSqlBuildWithObject:(id)object
//                                  udid:(NSString *)udid {
//    
//    __block NSString *sql = nil;
//    
//    [SqliteObject getColumnNamesAndValuesWithObject:object completion:^(NSString *tableName, NSString *primaryKey, NSArray *columns, NSArray *values) {
//        
//        NSString *columnNamesSql = [columns componentsJoinedByString:@","];
//        NSString *valuesSql = [values componentsJoinedByString:@"','"];
//        sql = [NSString stringWithFormat:@"insert into %@ (%@) values ('%@')" ,tableName, columnNamesSql, valuesSql];
//        
//    }];
//    
//    return sql;
//}
//
//+ (NSString *)updateSqlBuildWithObject:(id)object
//                                  udid:(NSString *)udid {
//    
//    __block NSString *sql = nil;
//    
//    [SqliteObject getColumnNamesAndValuesWithObject:object completion:^(NSString *tableName, NSString *primaryKey, NSArray *columns, NSArray *values) {
//        
//        NSMutableArray *tempResult = [NSMutableArray array];
//        
//        for(int i = 0; i < columns.count; i++) {
//            
//            NSString *columnName = columns[i];
//            id value = values[i];
//            NSString *str = [NSString stringWithFormat:@"%@ = '%@'", columnName, value];
//            [tempResult addObject:str];
//        }
//        sql = [NSString stringWithFormat:@"update %@ set %@ where %@ = '%@'", tableName, [tempResult componentsJoinedByString:@","], primaryKey, [object valueForKeyPath:primaryKey]];
//    }];
//    return sql;
//}
//
//+ (NSString *)saveSqlBuildWithObject:(id)object
//                                udid:(NSString *)udid {
//    
//    __block NSString *sql = nil;
//    
//    [SqliteObject getColumnNamesAndValuesWithObject:object completion:^(NSString *tableName, NSString *primaryKey, NSArray *columns, NSArray *values) {
//        
//        NSString *selectSql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", tableName, primaryKey, [object valueForKeyPath:primaryKey]];
//        NSArray *res = [SqliteDeals querySql:selectSql udid:udid];
//        
//        if (res.count > 0) {
//            
//            sql = [self updateSqlBuildWithObject:object udid:udid];
//            
//        }else {
//            
//            sql = [self insertSqlBuildWithObject:object udid:udid];
//        }
//        
//    }];
//    
//    return sql;
//}
//
//+ (NSString *)queryAllSqlBuildWithClass:(Class)cls udid:(NSString *)udid {
//    
//    NSString *tableName = [SqliteObject getTableNameWithObjectClass:cls];
//    return [NSString stringWithFormat:@"select * from %@",tableName];
//}
//
//+ (NSString *)querySqlBuildWithClass:(Class)cls
//                                 key:(NSString *)key
//                                udid:(NSString *)udid {
//    
//    NSString *tableName = [SqliteObject getTableNameWithObjectClass:cls];
//    NSString *primaryKey = [[cls new] primaryKey];
//    return [NSString stringWithFormat:@"select * from %@ where %@ = '%@' ",tableName,primaryKey,key];
//}
//
//+ (NSString *)querySqlBuildWithObject:(id)object
//                                 udid:(NSString *)udid {
//    
//    NSString *tableName = [SqliteObject getTableNameWithObjectClass:[object class]];
//    NSString *primaryKey = [object primaryKey];
//    return [NSString stringWithFormat:@"select * from %@ where %@ = '%@' ",tableName,primaryKey,[object valueForKey:primaryKey]];
//}
//
//
//+ (NSString *)deleteSqlBuildWithObject:(id)object
//                                  udid:(NSString *)udid {
//    
//    NSString *primaryKey = [object primaryKey];
//    NSString *tableName = [SqliteObject getTableNameWithObjectClass:[object class]];
//    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",tableName, primaryKey, [object valueForKeyPath:primaryKey]];
//    return sql;
//}
//
//+ (NSString *)deleteAllSqlBuildWithCls:(Class)cls
//                                  udid:(NSString *)udid {
//    
//    NSString *tableName = [SqliteObject getTableNameWithObjectClass:cls];
//    NSString *sql = [NSString stringWithFormat:@"delete from %@ ",tableName];
//    return sql;
//}

@end
