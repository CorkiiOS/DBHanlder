//
//  SqliteObject.m
//  SQlDemo
//
//  Created by mac on 2016/5/29.
//  Copyright © 2016年 Corki. All rights reserved.
//

#import "SqliteObject.h"
#import <objc/message.h>
@implementation SqliteObject

+ (NSString *)getTableNameWithObjectClass: (Class)cls {
    return [NSStringFromClass(cls) lowercaseString];
}

+ (NSDictionary *)getObjectIvarNameIvarTypeWithClass: (Class)cls {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    
    Ivar *ivars = class_copyIvarList(cls, &count);
    
    NSArray *ignoreNames = nil;
    
    if ([cls instancesRespondToSelector:@selector(ignoreIvarNames)]) {
        ignoreNames = [[cls new] ignoreIvarNames];
    }

    for (int i = 0; i < count; i ++) {
        
        Ivar ivar = ivars[i];
        
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        if ([[ivarName substringToIndex:1] isEqualToString:@"_"] ) {
            
            ivarName = [ivarName substringFromIndex:1];
        }
        
        NSString *ivarType = [[NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\"\""]];
        
        if ([ignoreNames containsObject:ivarName]) {
            
            continue;
        }
        //typecode map
        [result setObject:self.runtimeTypeToSqlType[ivarType] forKey:ivarName];
    }
    
    free(ivars);
    
    return result;
}

+ (void)getColumnNamesAndValuesWithObject:(id)object completion:(void (^)(NSString *, NSString *, NSArray *, NSArray *))completion {
    
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
    
    completion(tableName,primaryKey,columnNames, values);
}

/**
 获取模型里面所有的字段
 */
+ (NSArray <NSString *> *)getAllIvarNames: (Class)cls {
    
    return [[self getObjectIvarNameIvarTypeWithClass:cls] allKeys];
}

/**
 runtime的字段类型到sql字段类型的映射表
 */
+ (NSDictionary *)runtimeTypeToSqlType {
    
    return @{
             @"d": @"real", // double
             @"f": @"real", // float
             
             @"i": @"integer",  // int
             @"q": @"integer", // long
             @"Q": @"integer", // long long
             @"B": @"boolean", // bool
             
             @"NSData": @"blob",
             @"NSDictionary": @"text",
             @"NSMutableDictionary": @"text",
             @"NSArray": @"text",
             @"NSMutableArray": @"text",
             
             @"NSString": @"text",
             @"NSMutableString": @"text"
             };
}

@end
