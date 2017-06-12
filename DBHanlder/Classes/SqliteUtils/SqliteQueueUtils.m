//
//  SqliteQueueUtils.m
//  DBHanlder
//
//  Created by 三米 on 2017/6/12.
//

#import "SqliteQueueUtils.h"
#import "SqliteBuilder.h"
#import "SqliteObject.h"
#import "FMDB.h"
@interface SqliteQueueUtils()
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;
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

- (FMDatabaseQueue *)dbQueue {
    if (!_dbQueue) {
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:@"/Users/sanmi/Desktop/123.db"];
    }
    return _dbQueue;
}

- (void)buildTableByCls:(Class)cls
                   udid:(NSString *)udid{
    
    NSString *sql = [SqliteBuilder tableSqlBuildWithObject:[cls new] udid:udid];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
}

- (void)saveObjects:(NSArray <id<ISqliteModel>>*)objects
               udid:(NSString *)udid
         completion:(void(^)(BOOL))completion {
    if (objects.count == 0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            for (id<ISqliteModel> object in objects) {
                NSString *sql = [SqliteBuilder saveSqlBuildWithObject:object
                                                                 udid:udid];
                [db executeUpdate:sql];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(YES);
        });
    });
}

- (void)saveObject:(id<ISqliteModel>)object
              udid:(NSString *)udid {
    NSString *sql = [SqliteBuilder saveSqlBuildWithObject:object
                                                     udid:udid];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
}

- (NSArray <id<ISqliteModel>>*)qyeryObjectsByCls:(Class)cls
                                 udid:(NSString *)udid {
    __block NSMutableArray *objects = [NSMutableArray array];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [SqliteBuilder queryAllSqlBuildWithClass:cls
                                                            udid:udid];
        FMResultSet *rs = [db executeQuery:sql];
        NSArray *colums = [SqliteObject getAllIvarNames:cls];
        while ([rs next]) {
            id obj = [[cls alloc] init];
            for (NSString *key in colums) {
                id value = [rs valueForKeyPath:key];
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


- (id<ISqliteModel>)queryObjectByCls:(Class)cls
                     key:(NSString *)key
                           udid:(NSString *)udid {
    NSString *sql = [SqliteBuilder querySqlBuildWithClass:cls
                                                      key:key
                                                     udid:udid];
    id<ISqliteModel> obj = [[cls alloc] init];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            id obj = [[cls alloc] init];
            id value = [rs valueForKeyPath:key];
            if ([value isKindOfClass:[NSNull class]]) {
                value = nil;
            }
            [obj setValue:value forKey:key];
        }
        [rs close];
    }];
    return obj;
}

- (void)deleteAllObjectsByCls:(Class)cls
                         udid:(NSString *)udid {
    NSString *sql = [SqliteBuilder deleteAllSqlBuildWithCls:cls
                                                       udid:udid];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql];
    }];
}
@end
