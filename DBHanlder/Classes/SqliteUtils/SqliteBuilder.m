//
//  SqliteBuilder.m
//  SQlDemo
//
//  Created by mac on 2016/5/29.
//  Copyright © 2016年 Corki. All rights reserved.
//

#import "SqliteBuilder.h"
#import "SqliteObject.h"
#import "SqliteDeals.h"
@implementation SqliteBuilder

+ (NSString *)tableSqlBuildWithObject:(id)object udid:(NSString *)udid {
    
    if (![[object class] instancesRespondToSelector:@selector(primaryKey)]) {
        NSLog(@"如果想要操作你这个模型, 必须要通过 - (NSString *)primaryKey; 方法, 来提供一个主键给我");
        return nil;
    }
    
    NSString *primaryKey = [object primaryKey];

    NSString *tableName = [SqliteObject getTableNameWithObjectClass:[object class]];
    
    NSDictionary *typeNameMapping = [SqliteObject getObjectIvarNameIvarTypeWithClass:[object class]];
    
    NSMutableArray *typeNames = [NSMutableArray array];
    
    [typeNameMapping enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if (![key isEqualToString:primaryKey]) {
            
            NSString *text = [NSString stringWithFormat:@"%@ %@",key, obj];
            [typeNames addObject:text];
        }
    }];
    
    NSString *typeNameSql = [typeNames componentsJoinedByString:@","];
    
    NSString *bulidSql = [NSString stringWithFormat:@"create table if not exists %@ (%@ ,%@ %@ primary key not null )", tableName, typeNameSql, primaryKey, typeNameMapping[primaryKey]];
    
    return bulidSql;
}

+ (NSString *)saveSqlBuildWithObject:(id)object
                                udid:(NSString *)udid {
    
    NSString *primaryKey = [object primaryKey];
    
    NSString *tableName = [SqliteObject getTableNameWithObjectClass:[object class]];
    
    NSArray *columnNames = [SqliteObject getAllIvarNames:[object class]];
    
    NSMutableArray *values = [NSMutableArray array];
    
    for (NSString *columnName in columnNames) {
        
        id value = [object valueForKeyPath:columnName];
        
        if ([value isKindOfClass:[NSArray class]] ||
            [value isKindOfClass:[NSDictionary class]]) {
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
            
            value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
        
        if (value == nil) {
            value = @"";
        }
        
        [values addObject:value];
    }
    
    NSString *columnNamesSql = [columnNames componentsJoinedByString:@","];
    
    NSString *valuesSql = [values componentsJoinedByString:@"','"];
    
    NSString *insertSql = nil;
    
    NSString *updateSql = nil;
    
    NSString *selectSql = [NSString stringWithFormat:@"select * from %@ where %@ = '%@'", tableName, primaryKey, [object valueForKeyPath:primaryKey]];
    
    NSArray *res = [SqliteDeals querySql:selectSql udid:udid];
    
    if (res.count > 0) {
        
        NSMutableArray *tempResult = [NSMutableArray array];
        
        for(int i = 0; i < columnNames.count; i++) {
            
            NSString *columnName = columnNames[i];
            
            id value = values[i];
            
            NSString *str = [NSString stringWithFormat:@"%@ = '%@'", columnName, value];
            
            [tempResult addObject:str];
        }
        
        updateSql = [NSString stringWithFormat:@"update %@ set %@ where %@ = '%@'", tableName, [tempResult componentsJoinedByString:@","], primaryKey, [object valueForKeyPath:primaryKey]];
        
        return updateSql;
        
    }else {
        
        insertSql = [NSString stringWithFormat:@"insert into %@ (%@) values ('%@')" ,tableName, columnNamesSql, valuesSql];
        
        return insertSql;
    }

}

+ (NSString *)queryAllSqlBuildWithClass:(Class)cls udid:(NSString *)udid {
    
    NSString *tableName = [SqliteObject getTableNameWithObjectClass:cls];
    
    return [NSString stringWithFormat:@"select * from %@",tableName];
}

+ (NSString *)querySqlBuildWithClass:(Class)cls
                                    key:(NSString *)key
                                   udid:(NSString *)udid {
    
    NSString *tableName = [SqliteObject getTableNameWithObjectClass:cls];
    
    NSString *primaryKey = [[cls new] primaryKey];

    return [NSString stringWithFormat:@"select * from %@ where %@ = '%@' ",tableName,primaryKey,key];
}

+ (NSString *)deleteSqlBuildWithObject:(id)object
                                  udid:(NSString *)udid {
    
    NSString *primaryKey = [object primaryKey];
    
    NSString *tableName = [SqliteObject getTableNameWithObjectClass:[object class]];
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@ = '%@'",tableName, primaryKey, [object valueForKeyPath:primaryKey]];
    
    return sql;
}

+ (NSString *)deleteAllSqlBuildWithCls:(Class)cls
                                  udid:(NSString *)udid {
    
    NSString *tableName = [SqliteObject getTableNameWithObjectClass:cls];
    NSString *sql = [NSString stringWithFormat:@"delete * from %@ ",tableName];
    return sql;
}
@end
