//
//  AppDelegate.h
//  YRYZ
//
//  Created by 易超 on 16/6/29.
//  Copyright © 2016年 yryz. All rights reserved.
//
//
//
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼        BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？


#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
typedef enum
{
    kNewFollowType              = 1001,//新关注
    kForwardType                = 1002,//转发
    kGoForwardType              = 1003,//跟转
    kSPlayTourType              = 1004,//打赏(晒一晒)
    kThransPlayTourType         = 1005,//打赏(转发)
    kWorksPlayTourType          = 1006,//打赏(作品)
    kAskThransType              = 1007,//邀请转发
    kRewardOutDataType          = 1008,//红包到期
    kRewardGetDownType          = 1009,//红包领完
    kWorksApproveType           = 1010,//审核通过(作品)
    kWorksAuditFailType         = 1011,//审核失败(作品)
    kAdvertApproveType          = 1012,//审核通过(广告)
    kAdvertAuditFailType        = 1013,//审核失败(广告)
    kGetThransLotteryCodeType   = 1014,//获得抽奖码(转发)
    kGetActivityLotteryCodeType = 1015,//获得抽奖码(活动)
    kGetCashCouponType          = 1016,//获得现金券
    kGetPayCashCouponType       = 1017,//获得现金券(充值)
    kMineIsWinnersCodeType      = 1018,//开奖消息（中奖人)
    kBeginCountdownCodeType     = 1019,//开奖消息 (非中奖人) 开始倒计时
    kFSendShowType              = 2001,//好友发布晒一晒
    kFForwardWorksType          = 2002,//好友转发作品
    kFSendWorksOrTextType       = 2003,//好友发布作品(文字)
    kFSendWorksOrAudioType      = 2004,//好友发布作品(声音)
    kFSendWorksOrVideoType      = 2005,//好友发布作品(视频)
    
} NotificationType;//枚举名称
@property (strong, nonatomic) UIWindow  *window;
@property(nonatomic,strong)NSString     *netState;
@property(nonatomic,assign)NSInteger    allowRotation;
//切换主控制器
- (void)changeRootController;

@end

