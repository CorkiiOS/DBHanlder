//
//  ICClassIvarInfo.m
//  Pods
//
//  Created by mac on 2017/8/6.
//
//

#import "ICClassIvarInfo.h"

@implementation ICClassIvarInfo

- (instancetype)initWithIvar:(Ivar)ivar {
    if (!ivar) return nil;
    self = [super init];
    _ivar = ivar;
    const char *name = ivar_getName(ivar);
    if (name) {
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ([[ivarName substringToIndex:1] isEqualToString:@"_"] ) {
            _name = [ivarName substringFromIndex:1];
        }
    }
    
    _ivarType = [[NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\"\""]];
    _offset = ivar_getOffset(ivar);
    _dbColunmName = self.runtimeTypeToSqlType[_ivarType];
    return self;
}

/**
 runtime的字段类型到sql字段类型的映射表
 */
- (NSDictionary *)runtimeTypeToSqlType {
    
    return @{
             @"d": @"real", // double
             @"f": @"real", // float
             
             @"i": @"integer",  // int
             @"q": @"integer", // long
             @"Q": @"integer", // long long
             @"B": @"boolean", // bool
             
             @"NSData": @"blob",
             @"NSDictionary": @"text",
             @"NSMutableDictionary": @"text",
             @"NSArray": @"text",
             @"NSMutableArray": @"text",
             
             @"NSString": @"text",
             @"NSMutableString": @"text"
             };
}

@end

