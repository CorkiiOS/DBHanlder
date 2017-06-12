//
//  SqliteFileManager.m
//  SQlDemo
//
//  Created by mac on 2016/5/30.
//  Copyright © 2016年 Corki. All rights reserved.
//

#import "SqliteFileManager.h"


static NSString *const defaultSqliteFolder = @"defaultSqliteFolder";

@implementation SqliteFileManager

+ (NSString *)buidlFolderWithName:(NSString *)folderName {
    
    if (folderName == nil) {
        
        folderName = [self defaultFolder];
    }
    
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString *path = [cachesPath stringByAppendingPathComponent:folderName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        return path;
    }
    
    NSError *error = nil;
    
    [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    
    if (!error) return nil;
    
    return path;
}

+ (NSString *)defaultFolder {
 
    return defaultSqliteFolder;
}
@end
