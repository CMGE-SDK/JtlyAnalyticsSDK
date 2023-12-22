//
//  JtlyDemoEventManager.m
//  JtlyAnalyticsDemo
//
//  Created by 李阳 on 2022/3/15.
//

#import "JtlyDemoEventManager.h"
#import <JtlyAnalyticsKit/JtlyAnalyticsKit.h>

@interface JtlyDemoEventManager ()
@end

@implementation JtlyDemoEventManager

+ (instancetype)shared {
    static JtlyDemoEventManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[JtlyDemoEventManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _eventList = [NSMutableArray array];
        [self addSdkEvent];
        [self addGameEvent];
    }
    return self;
}

//添加事件
- (void)addDisplayName:(NSString *)displayName eventName:(NSString *)eventName parameters:(NSDictionary *)parameters {
    JtlyDemoEvent *event = [[JtlyDemoEvent alloc] initWithDisplayName:displayName eventName:eventName parameters:parameters];
    [self.eventList addObject:event];
}

//添加SDK事件
- (void)addSdkEvent {

//客户端激活 分析SDK会自动上报
//    [self addDisplayName:@"客户端激活"
//               eventName:@"activate"
//              parameters:nil];


    //sdk激活
    [self addDisplayName:@"sdk激活"
               eventName:@"sdk_activate"
              parameters:nil];


    //账号注册开始
    [self addDisplayName:@"发起账号注册"
               eventName:@"sdk_register_start"
              parameters:@{@"generic_enum": @"account"}];

    //账号注册成功
    [self addDisplayName:@"账号注册成功"
               eventName:@"sdk_register"
              parameters:@{@"generic_enum": @"account"}];

    //账号注册失败
    [self addDisplayName:@"账号注册失败"
               eventName:@"sdk_register_fail"
              parameters:@{@"generic_enum": @"account", @"error_code": @"1001", @"error_messsage": @"账号为空"}];

    //发起账号登录
    [self addDisplayName:@"发起账号登录"
               eventName:@"sdk_login_start"
              parameters:@{@"generic_enum": @"account"}];

    //账号登录成功
    [self addDisplayName:@"账号登录成功"
               eventName:@"sdk_login"
              parameters:@{@"generic_enum": @"account", @"account_id": @"12233", @"account_num": @"troger123", @"phone": @"13077868777"}];

    //账号登录失败
    [self addDisplayName:@"账号登录失败"
               eventName:@"sdk_login_fail"
              parameters:@{@"generic_enum": @"account", @"error_code": @"1001", @"error_message": @"密码错误"}];

    //绑定
    [self addDisplayName:@"绑定"
               eventName:@"sdk_bind"
              parameters:@{@"generic_enum": @"phone"}];

    //解绑
    [self addDisplayName:@"解绑"
               eventName:@"sdk_unbind"
              parameters:@{@"generic_enum": @"phone"}];

    //发起实名认证
    [self addDisplayName:@"发起实名认证"
               eventName:@"sdk_realname_start"
              parameters:nil];


    //实名认证成功
    [self addDisplayName:@"实名认证成功"
               eventName:@"sdk_realname"
              parameters:nil];

    //实名认证失败
    [self addDisplayName:@"实名认证失败"
               eventName:@"sdk_realname_fail"
              parameters:nil];


    //账号下单
    [self addDisplayName:@"账号下单"
               eventName:@"sdk_initiated_checkout"
              parameters:@{@"charging_money": @(12), @"charging_money_type": @"HKD", @"game_order_id": @"order12232803231", @"channel_order_id": @"order12345678", @"pay_order_id": @"2132121211", @"vip_level": @(12), @"level": @(1), @"power_value": @(2)}];

    //下单成功
    [self addDisplayName:@"下单成功"
               eventName:@"sdk_initiated_success"
              parameters:@{@"charging_money": @(12), @"charging_money_type": @"HKD", @"game_order_id": @"order12232803231", @"channel_order_id": @"order12345678", @"pay_order_id": @"2132121211", @"vip_level": @(12), @"level": @(1), @"power_value": @(2)}];


    //账号注销
    [self addDisplayName:@"账号注销"
               eventName:@"sdk_cancellation"
              parameters:nil];

    //客户端崩溃
    [self addDisplayName:@"客户端崩溃"
               eventName:@"sdk_crash"
              parameters:@{@"log_info": @"crash cased by memory exceed"}];

    //诊断信息
    [self addDisplayName:@"诊断信息"
               eventName:@"sdk_diagnostic"
              parameters:@{@"generic_enum": @"FacebookVersion", @"log_info": @"Facebook V1.12.1"}];

    //iOS 广告跟踪设置
    [self addDisplayName:@"iOS 广告跟踪设置"
               eventName:@"sdk_ios_att"
              parameters:nil];


    //iOS asa上报成功
    [self addDisplayName:@"iOS asa上报成功"
               eventName:@"sdk_ios_asa_report"
              parameters:@{@"log_info":@"test"}];
}


//TODO: 记得打开
//SDK1.2及以上使用。添加游戏事件。
- (void)addGameEvent {
    
    //打开游戏
    [self addDisplayName:@"打开游戏"
               eventName:@"open_game"
              parameters:nil];
    
    //开始闪屏事件
    [self addDisplayName:@"开始闪屏事件"
               eventName:@"start_launch"
              parameters:nil];
    
    //完成闪屏事件
    [self addDisplayName:@"完成闪屏事件"
               eventName:@"finish_launch"
              parameters:nil];
    
    //开始动画
    [self addDisplayName:@"开始动画"
               eventName:@"start_animation"
              parameters:nil];
    
    //结束动画
    [self addDisplayName:@"结束动画"
               eventName:@"finish_animation"
              parameters:nil];
    
    //强制更新
    [self addDisplayName:@"强制更新"
               eventName:@"forced_update"
              parameters:nil];
    
    
    //更新检测完毕无更新
    [self addDisplayName:@"更新检测完毕无更新"
               eventName:@"update_done"
              parameters:@{@"generic_enum":@"none"}];
    
    
    //开始下载更新
    [self addDisplayName:@"开始下载更新"
               eventName:@"update_download"
              parameters:nil];
    
    //完成下载更新
    [self addDisplayName:@"完成下载更新"
               eventName:@"update_download_complete"
              parameters:nil];
    
    //开始安装更新
    [self addDisplayName:@"开始安装更新"
               eventName:@"start_update"
              parameters:nil];
    
    //完成安装更新
    [self addDisplayName:@"完成安装更新"
               eventName:@"finish_update"
              parameters:nil];
    
    
    //sdk登录成功通知
    [self addDisplayName:@"sdk登录成功通知"
               eventName:@"sdk_login_notification"
              parameters:nil];
  
    
    //开始加载公告
    [self addDisplayName:@"开始加载公告"
               eventName:@"notice_loading"
              parameters:nil];
    
    //完成载入公告
    [self addDisplayName:@"完成载入公告"
               eventName:@"notice_show"
              parameters:nil];
    
    //关闭公告
    [self addDisplayName:@"关闭公告"
               eventName:@"notice_close"
              parameters:nil];
    
    
    //进入开始游戏页面
    [self addDisplayName:@"进入开始游戏页面"
               eventName:@"start_game_page"
              parameters:nil];
    
    //选择游戏区服
    [self addDisplayName:@"选择游戏区服"
               eventName:@"select_server"
              parameters:@{@"server_id": @"101"}];
    
    //点击进入游戏
    [self addDisplayName:@"点击进入游戏"
               eventName:@"click_enter"
              parameters:nil];
    
    //游戏开始加载
    [self addDisplayName:@"游戏开始加载"
               eventName:@"start_loading"
              parameters:nil];
    
    //游戏结束加载
    [self addDisplayName:@"游戏结束加载"
               eventName:@"finish_loading"
              parameters:nil];
    
    //创建新角色
    [self addDisplayName:@"创建新角色"
               eventName:@"create_new_role"
              parameters:@{@"server_id": @"101", @"role_id": @"281908768493063", @"role_name": @"令狐聪2"}];
    
    
    //角色进入游戏成功
    [self addDisplayName:@"角色进入游戏成功"
               eventName:@"enter_game"
              parameters:@{@"server_id": @"101", @"server_name": @"沧海一声笑", @"role_id": @"281908768493063", @"role_name": @"令狐聪", @"level": @(11), @"vip_level":@(12), @"power_value":@(13)}];
    
    //角色进入游戏失败
    [self addDisplayName:@"角色进入游戏失败"
               eventName:@"enter_fail"
              parameters:@{@"generic_enum": @"maintenance"}];
    
    //开始新手指引
    [self addDisplayName:@"完成新手指引"
               eventName:@"tutorial_completion"
              parameters:@{@"guide_state":@(1)}];
    
    //开始新手指引
    [self addDisplayName:@"开始新手指引"
               eventName:@"tutorial_begin"
              parameters:nil];
    
    
    //发起购买
    [self addDisplayName:@"发起购买"
               eventName:@"pre_initiated_checkout"
              parameters:@{@"vip_level": @(12), @"level":@(12), @"power_value":@(12), @"product_id":@"12323132", @"charging_money":@(12.2), @"charging_money_type":@"CNY"}];
    
    //发起购买
    [self addDisplayName:@"下发道具"
               eventName:@"client_delivery"
              parameters:@{@"game_order_id":@"order12232803231", @"channel_order_id":@"order12345678", @"pay_order_id":@"2132121211", @"product_id ":@"123232343", @"charging_money":@(100),  @"charging_money_type": @"CNY", @"money":@(12), @"money_type":@"CNY", @"level":@(12), @"power_value":@(13), @"product_id":@"432422432", @"vip_level":@(18)}];
    
    //副本通关记录
    [self addDisplayName:@"副本通关记录"
               eventName:@"pass_dungeon"
              parameters:@{@"dungeon_type":@"101", @"dungeon_id":@"101_1", @"point_state":@(1), @"use_second":@(1202022), @"power_value":@(12), @"vip_level":@(10), @"level":@(11), @"is_important":@(1)}];
    
    //切换角色
    [self addDisplayName:@"切换角色"
               eventName:@"switch_roles"
              parameters:@{@"vip_level":@(12), @"level":@(13), @"power_value":@(12)}];
    
    //角色升级
    [self addDisplayName:@"角色升级"
               eventName:@"trigger_levelup"
              parameters:@{@"level_type":@"level", @"before_level":@(11), @"after_level":@(12), @"before_power_value":@(99), @"after_power_value":@(100)}];
    
    //vip升级
    [self addDisplayName:@"vip升级"
               eventName:@"trigger_levelup"
              parameters:@{@"level_type":@"vip_level", @"before_level":@(1), @"after_level":@(2)}];
    
    
    //加入工会
    [self addDisplayName:@"加入工会"
               eventName:@"join_union"
              parameters:@{@"union_id":@"12345678", @"union_name":@"BigPigger"}];
    
    //游戏关键卡点
    [self addDisplayName:@"游戏关键卡点"
               eventName:@"pass_key_gamecard"
              parameters:nil];
    
    
    
    //第三方自定义事件
    [self addDisplayName:@"第三方自定义"
               eventName:@"custom_event"
              parameters:@{@"custom_param": @"111222"}];
}

@end


@implementation JtlyDemoEvent

- (instancetype)initWithDisplayName:(NSString *)displayName eventName:(NSString *)eventName parameters:(NSDictionary *)parameters {
    self = [super init];
    if (self) {
        _displayName = displayName;
        _eventName = eventName;
        _parameters = parameters;
    }
    return self;
}

@end
