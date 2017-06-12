//
//  SqliteQueueUtils.m
//  DBHanlder
//
//  Created by 三米 on 2017/6/12.
//

#import "SqliteQueueUtils.h"
#import "SqliteFileManager.h"
#import "SqliteBuilder.h"
#import "SqliteObject.h"
#import "FMDB.h"
@interface SqliteQueueUtils()

//@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
{
    FMDatabaseQueue *_dbQueue;
    NSString *lastUdid;
}
- (FMDatabaseQueue *(^)(NSString *))dbQueue;
@end

@implementation SqliteQueueUtils

+ (instancetype)sharedInstance {
    static SqliteQueueUtils *u = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        u = [[self alloc] init];
    });
    return u;
}

- (FMDatabaseQueue *(^)(NSString *))dbQueue {
    return ^(NSString *udid){
        if (!_dbQueue || udid != lastUdid) {
            NSString *dbPath = [SqliteFileManager buidlFolderWithName:nil];
            if (udid.length == 0) {
                dbPath = [dbPath stringByAppendingPathComponent:@"common.db"];
            }else {
                dbPath = [dbPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.db", udid]];
            }
            _dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbPath];
            lastUdid = udid;
        }
        return _dbQueue;
    };
}

- (BOOL)buildTableByCls:(Class)cls
                   udid:(NSString *)udid {
    
    
    NSString *sql = [SqliteBuilder tableSqlBuildWithObject:[cls new]
                                                      udid:udid];
    NSString *tableName = [SqliteObject getTableNameWithObjectClass:cls];
    __block BOOL isSuccess = NO;
    [self.dbQueue(udid) inDatabase:^(FMDatabase *db) {
        
        isSuccess = [db tableExists:tableName];
        if (!isSuccess) {
            isSuccess = [db executeUpdate:sql];
        }
    }];
    return isSuccess;
}

- (void)saveObjects:(NSArray <id<ISqliteModel>>*)objects
               udid:(NSString *)udid
         completion:(void(^)(BOOL))completion {
    if (objects.count == 0) {
        return;
    }
    if (![self buildTableByCls:[objects.firstObject class] udid:udid]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [self.dbQueue(udid) inTransaction:^(FMDatabase *db, BOOL *rollback) {
            for (id<ISqliteModel> object in objects) {

                NSString *selectSql = [SqliteBuilder querySqlBuildWithObject:object
                                                                        udid:udid];
                FMResultSet *set = [db executeQuery:selectSql];
                if ([set next]) {
                    [db executeUpdate:[SqliteBuilder updateSqlBuildWithObject:object
                                                                         udid:udid]];
                }else {
                    [db executeUpdate:[SqliteBuilder insertSqlBuildWithObject:object
                                                                         udid:udid]];
 
                }
                [set close];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(YES);
        });
    });
}

- (void)saveObject:(id<ISqliteModel>)object
              udid:(NSString *)udid {
    if (![self buildTableByCls:[object class] udid:udid]) {
        return;
    }
    [self.dbQueue(udid) inDatabase:^(FMDatabase *db) {
        NSString *selectSql = [SqliteBuilder querySqlBuildWithObject:object
                                                                udid:udid];
        FMResultSet *set = [db executeQuery:selectSql];
        if ([set next]) {
            [db executeUpdate:[SqliteBuilder updateSqlBuildWithObject:object
                                                                 udid:udid]];
        }else {
            [db executeUpdate:[SqliteBuilder insertSqlBuildWithObject:object
                                                                 udid:udid]];
        }
        [set close];
    }];
}

- (NSArray <id<ISqliteModel>>*)qyeryObjectsByCls:(Class)cls
                                 udid:(NSString *)udid {
    if (![self buildTableByCls:cls udid:udid]) {
        return nil;
    }
    __block NSMutableArray *objects = [NSMutableArray array];
    [self.dbQueue(udid) inDatabase:^(FMDatabase *db) {
        NSString *sql = [SqliteBuilder queryAllSqlBuildWithClass:cls
                                                            udid:udid];
        FMResultSet *rs = [db executeQuery:sql];
        NSArray *colums = [SqliteObject getAllIvarNames:cls];
        while ([rs next]) {
            id obj = [[cls alloc] init];
            for (NSString *key in colums) {
                id value = [rs objectForColumnName:key];
                if ([value isKindOfClass:[NSNull class]]) {
                    continue;
                }
                [obj setValue:value forKey:key];
            }
            [objects addObject:obj];
        }
        [rs close];
    }];
    return objects;
}

- (void)deleteAllObjectsByCls:(Class)cls
                         udid:(NSString *)udid {
    if (![self buildTableByCls:cls udid:udid]) {
        return;
    }
    NSString *sql = [SqliteBuilder deleteAllSqlBuildWithCls:cls
                                                       udid:udid];
    [self.dbQueue(udid) inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
}
@end
