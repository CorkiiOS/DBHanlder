//
//  DB_TestModel.h
//  DBHanlder_Example
//
//  Created by 三米 on 2017/6/12.
//  Copyright © 2017年 corkiios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISqliteModel.h"
@interface DB_TestModel : NSObject<ISqliteModel>

@property (nonatomic, strong)NSString *username;
@property (nonatomic, strong)NSString *sign;
@property (nonatomic, assign)BOOL sex;
@property (nonatomic, assign)NSInteger key;
@end
