//
//  SqliteObject.h
//  SQlDemo
//
//  Created by mac on 2016/5/29.
//  Copyright © 2016年 Corki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISqliteModel.h"

@interface SqliteObject : NSObject


/**
 根据模型获取表的名字

 @param cls 类型->表名字
 @return 表名字
 */
+ (NSString *)getTableNameWithObjectClass: (Class)cls;

/**
 获取模型会被创建成为表格的  成员变量名称和类型组成的字典
 {key: 成员变量名称,取出下划线  value: 值}
 类型: runtime获取的类型
 */
+ (NSDictionary *)getObjectIvarNameIvarTypeWithClass: (Class)cls;

/**
 获取模型中所有的字段

 @param cls cls
 @return allIvarNames
 */
+ (NSArray <NSString *> *)getAllIvarNames: (Class)cls;

@end
