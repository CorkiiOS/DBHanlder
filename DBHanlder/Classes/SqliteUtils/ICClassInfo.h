//
//  ICClassInfo.h
//  Pods
//
//  Created by mac on 2017/8/6.
//
//

#import <Foundation/Foundation.h>

@class ICClassIvarInfo;

@interface ICClassInfo : NSObject

@property (nonatomic, assign, readonly) Class cls; ///< class object

@property (nonatomic, strong, readonly) NSString *name; ///< class name

@property (nullable, nonatomic, strong, readonly) NSDictionary<NSString *, ICClassIvarInfo *> *ivarInfos; ///< ivars


/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param cls A class.
 @return A class info, or nil if an error occurs.
 */
+ (nullable instancetype)classInfoWithClass:(Class)cls;

/**
 Get the class info of a specified Class.
 
 @discussion This method will cache the class info and super-class info
 at the first access to the Class. This method is thread-safe.
 
 @param className A class name.
 @return A class info, or nil if an error occurs.
 */
+ (nullable instancetype)classInfoWithClassName:(NSString *)className;@end
