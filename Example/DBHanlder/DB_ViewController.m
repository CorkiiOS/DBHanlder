//
//  DB_ViewController.m
//  DBHanlder
//
//  Created by corkiios on 06/12/2017.
//  Copyright (c) 2017 corkiios. All rights reserved.
//

#import "DB_ViewController.h"
#import "DB_TestModel.h"
#import "SqliteQueueUtils.h"
@interface DB_ViewController ()

@end

@implementation DB_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self saveModels];
}
- (void)saveModel {
    
    //保存模型
    DB_TestModel *model = [[DB_TestModel alloc] init];
    model.username = @"牛牛牛";
    model.sex = @"母";
    model.sign = @"牛牛牛大大";
    model.key = @"336699";
    [[SqliteQueueUtils sharedInstance] saveObject:model udid:nil];
}

- (void)saveModels {
    
    NSMutableArray *a = [NSMutableArray array];
    for (int i = 0; i < 600; i ++) {
        //保存模型
        DB_TestModel *model = [[DB_TestModel alloc] init];
        model.username = @"牛牛牛";
        model.sex = @"母";
        model.sign = @"牛牛牛大大";
        model.key = [NSString stringWithFormat:@"%d--36699",i + 1000];
        [a addObject:model];
    }
    [[SqliteQueueUtils sharedInstance] saveObjects:a udid:nil completion:^(BOOL result) {
        
        NSLog(@"完成");
    }];
    
}
- (void)testCreate {
    //创建表测试
    [[SqliteQueueUtils sharedInstance] buildTableByCls:[DB_TestModel class] udid:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
