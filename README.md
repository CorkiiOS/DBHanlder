# DBHanlder

[![CI Status](http://img.shields.io/travis/corkiios/DBHanlder.svg?style=flat)](https://travis-ci.org/corkiios/DBHanlder)
[![Version](https://img.shields.io/cocoapods/v/DBHanlder.svg?style=flat)](http://cocoapods.org/pods/DBHanlder)
[![License](https://img.shields.io/cocoapods/l/DBHanlder.svg?style=flat)](http://cocoapods.org/pods/DBHanlder)
[![Platform](https://img.shields.io/cocoapods/p/DBHanlder.svg?style=flat)](http://cocoapods.org/pods/DBHanlder)
*	An easy way to handler sqlite
* model->sql->deal sql

## API Describe

### SqliteQueueUtils 线程安全
#### Save 

```
/**
注意：数据存在会执行更新sql语句，不存在插入数据！
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

```

#### Query



```
/**
 查询表中所有数据
 
 @param cls 类
 @param udid 用户id
 @return 模型集合
 */
- (NSArray <id<ISqliteModel>>*)qyeryObjectsByCls:(Class)cls
                                            udid:(NSString *)udid;



```
#### Delete

```
/**
 删除数据 所有
 
 */
- (void)deleteAllObjectsByCls:(Class)cls
                         udid:(NSString *)udid;
```



###  SqliteUtils 不支持多线程

```
/**
 保存模型，存在则更新
 @param object 数据模型
 @param udid 用户体系
 @return 结果
 */
+ (BOOL)saveObject:(id<ISqliteModel>)object
              udid:(NSString *)udid;

/**
 删除模型
 @param object 数据模型
 @param udid 用户体系
 @return 结果
 */
+ (BOOL)deleteObject:(id<ISqliteModel>)object
                udid:(NSString *)udid;

/**
 查询表中所有的数据

 @param cls 类名字
 @param udid 用户体系所用
 @return 结果集
 */
+ (NSArray *)queryAllObjectsWithClass:(Class)cls
                                 udid:(NSString *)udid;

/**
 查询表中所有的数据
 
 @param cls 类名字 key 
 @param udid 用户体系所用
 @return 结果集
 */
+ (id)queryObjectsWithClass:(Class)cls
                               key:(NSString *)key
                                 udid:(NSString *)udid;
```


## Example

* To run the example project, clone the repo, and run `pod install` from the Example directory first.
* 需要保存的模型必须遵守ISqliteModel,得到主键和忽略字段

### SqliteQueueUtils 线程安全


```
  DB_TestModel *model = [[DB_TestModel alloc] init];
    model.username = @"牛aaaa牛";
    model.sex = @"yayaydadadada";
    model.sign = @"牛牛牛大大";
    model.key = @"336699ssssss";
    [[SqliteQueueUtils sharedInstance] saveObject:model udid:nil];
```

###  SqliteUtils 不支持多线程


```
//保存模型
    DB_TestModel *model = [[DB_TestModel alloc] init];
    model.username = @"牛aaaa牛";
    model.sex = @"yayaydadadada";
    model.sign = @"牛牛牛大大";
    model.key = @"336699ssssss";
    [SqliteUtils saveObject:model udid:@"123456"];
    
```

## Installation

DBHanlder is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DBHanlder"
```

## Author

corkiios, 675053587@qq.com

## License

DBHanlder is available under the MIT license. See the LICENSE file for more info.


