//
//  ISqliteModel.h
//  SQlDemo
//
//  Created by mac on 2016/5/29.
//  Copyright © 2016年 Corki. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ISqliteModel <NSObject>

/**
 主键

 @return 主键名称 必须有
 */
@required

- (NSString *)primaryKey;

/**
 忽略字段
 
 @return 忽略字段集合
 */
@optional
- (NSArray *)ignoreIvarNames;

@end
