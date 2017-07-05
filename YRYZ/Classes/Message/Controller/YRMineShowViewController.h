//
//  YRMineShowViewController.h
//  
//
//  Created by Mrs_zhang on 16/7/12.
//
//

#import <UIKit/UIKit.h>

@interface YRMineShowViewController : UIViewController
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
} NotificationsType;//枚举名称
@end
