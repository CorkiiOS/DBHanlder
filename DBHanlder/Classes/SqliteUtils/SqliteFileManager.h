//
//  SqliteFileManager.h
//  SQlDemo
//
//  Created by mac on 2016/5/30.
//  Copyright © 2016年 Corki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SqliteFileManager : NSObject


/**
 默认文件夹名字

 @return name
 */
+ (NSString *)defaultFolder;
/**
 创建一个文件夹用来管理所有表文件

 @param folderName 文件名称
 @return 文件路径
 */
+ (NSString *)buidlFolderWithName:(NSString *)folderName;


@end
