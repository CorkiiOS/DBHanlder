//
//  ICClassIvarInfo.h
//  Pods
//
//  Created by mac on 2017/8/6.
//
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface ICClassIvarInfo : NSObject

@property (nonatomic, assign, readonly) Ivar ivar;              ///< ivar opaque struct
@property (nonatomic, strong, readonly) NSString *name;         ///< Ivar's name
@property (nonatomic, assign, readonly) ptrdiff_t offset;       ///< Ivar's offset
@property (nonatomic, strong, readonly) NSString *ivarType; ///< Ivar's type encoding
@property (nonatomic, strong, readonly) NSString *dbColunmName; 


/**
 Creates and returns an ivar info object.
 
 @param ivar ivar opaque struct
 @return A new object, or nil if an error occurs.
 */
- (instancetype)initWithIvar:(Ivar)ivar;

@end
