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
#import "SqliteUtils.h"
#import "ICSqliteBuilder.h"

@interface DB_ViewController ()

@end

@implementation DB_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *c_sql = [ICSqliteBuilder tableSqlBuildWithClass:[DB_TestModel class]
                                                         udid:nil];

    
}
- (void)saveModel {
    
    //保存模型
    DB_TestModel *model = [[DB_TestModel alloc] init];
    model.username = @"牛aaaa牛";
    model.sex = @"yayaydadadada";
    model.sign = @"牛牛牛大大";
    model.key = @"336699ssssss";
    [SqliteUtils saveObject:model udid:@"123456"];
}

- (void)saveModels {
    
    NSMutableArray *a = [NSMutableArray array];
    for (int i = 0; i < 600; i ++) {
        //保存模型
        DB_TestModel *model = [[DB_TestModel alloc] init];
        model.username = @"牛牛牛";
        model.sex = @"母dadad";
        model.sign = @"牛牛牛大大";
        model.key = [NSString stringWithFormat:@"%d--36699",i + 1000];
        [a addObject:model];
        
    }
    
    for (NSInteger i = 0; i < 10; i ++) {
        
        [[SqliteQueueUtils sharedInstance] saveObjects:a udid:[NSString stringWithFormat:@"%zd",i + 10000] completion:^(BOOL fis) {
            
        }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
