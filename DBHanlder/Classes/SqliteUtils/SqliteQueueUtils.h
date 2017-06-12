//
//  SqliteQueueUtils.h
//  DBHanlder
//
//  Created by 三米 on 2017/6/12.
//

#import <Foundation/Foundation.h>
@protocol ISqliteModel;
@interface SqliteQueueUtils : NSObject
+ (instancetype)sharedInstance;

/**
 储存模型
 
 @param object 模型
 @param udid 用户id
 */
- (void)saveObject:(id<ISqliteModel>)object
              udid:(NSString *)udid;

/**
 储存列表模型
 
 @param objects 模型集合
 @param udid 用户id
 @param completion 完成回调
 */
- (void)saveObjects:(NSArray <id<ISqliteModel>>*)objects
               udid:(NSString *)udid
         completion:(void(^)(BOOL))completion;

/**
 查询表中所有数据
 
 @param cls 类
 @param udid 用户id
 @return 模型集合
 */
- (NSArray <id<ISqliteModel>>*)qyeryObjectsByCls:(Class)cls
                                            udid:(NSString *)udid;

/**
 删除数据 所有
 
 */
- (void)deleteAllObjectsByCls:(Class)cls
                         udid:(NSString *)udid;
@end
