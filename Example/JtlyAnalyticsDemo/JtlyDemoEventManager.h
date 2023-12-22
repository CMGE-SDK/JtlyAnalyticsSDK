//
//  JtlyDemoEventManager.h
//  JtlyAnalyticsDemo
//
//  Created by 李阳 on 2022/3/15.
//

#import <Foundation/Foundation.h>
@class JtlyDemoEvent;

/// 事件管理器
@interface JtlyDemoEventManager : NSObject

/// 单例
+ (instancetype)shared;

@property (nonatomic, strong, readonly) NSMutableArray<JtlyDemoEvent *> *eventList;

@end


/// 事件类
@interface JtlyDemoEvent : NSObject

- (instancetype)initWithDisplayName:(NSString *)displayName eventName:(NSString *)eventName parameters:(NSDictionary *)parameters;
/// 显示名称
@property (nonatomic, copy, readonly) NSString *displayName;
/// 事件名称
@property (nonatomic, copy, readonly) NSString *eventName;
/// 事件参数
@property (nonatomic, strong, readonly) NSDictionary *parameters;

@end
