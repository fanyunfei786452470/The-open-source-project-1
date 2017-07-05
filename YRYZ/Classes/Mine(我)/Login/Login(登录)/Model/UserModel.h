//
//  UserModel.h
//  Rrz
//
//  Created by weishibo on 16/3/2.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//


#import "BaseModel.h"


@interface UserModel : BaseModel



@property (nonatomic, strong) NSString  *custLevel;
@property (nonatomic, strong) NSString  *custName;
@property (nonatomic, strong) NSString  *custPhone;
@property (nonatomic, strong) NSString  *headImg;
@property (nonatomic, strong) NSString  *qrCode;
@property (strong, nonatomic) NSString  *token;
//@property (strong, nonatomic) NSString  *uid;

@property (nonatomic,copy) NSString   *custId;

@property (nonatomic,copy) NSString             *isbusy; //占线

//// 消息
@property (assign, nonatomic)  NSInteger msgCount;//消息数
@property (assign, nonatomic)  NSInteger mineShowCount;//我的动态数
@property (assign, nonatomic) NSInteger friendsShowCount;//好友动态数


@property (nonatomic,copy) NSString *custDesc;
@property (nonatomic,strong)  NSString  *custSex;
/** 位置*/
@property (nonatomic,strong)  NSString  *custLocation;
//位置
@property (nonatomic,copy) NSString *address;

@property (nonatomic,strong)  NSString  *custImg;
/** 个性签名*/
@property (nonatomic,strong)  NSString  *custSignature;
//昵称
@property (nonatomic,strong)  NSString  *custNname;
//简介
@property (nonatomic,copy) NSString *desc;

@property (nonatomic,copy) NSString *custQr;

@property (nonatomic,copy) NSString *loginType;
/** 开奖公布第几名*/
@property (nonatomic,assign) NSInteger winning;


/** 是否开始倒计时 YES 开启 NO 不开启**/
@property (nonatomic,assign) BOOL isOpenLottery;
/** 开奖倒计时还剩多少秒 */
@property (nonatomic,assign) NSInteger seconds;

/** 认证状态*/
@property (strong, nonatomic) NSString *custIdentified;

/** <#注释#>*/
@property (strong, nonatomic) NSString *custLoginName;


@property (strong, nonatomic) NSString *accountSum;//账户余额
@property (strong, nonatomic) NSString *costSum;//累计消费金额
@property (strong, nonatomic) NSString *currency;//币种
@property (strong, nonatomic) NSDictionary *defaultCardObj;//币种

+ (UserModel*)getObjcByid:(NSString*)objc_id;

/**
 *  @author yichao, 16-04-29 16:04:53
 *
 *  银行卡信息
 */
/** <#注释#>*/
@property (strong, nonatomic) NSString *bankCardId;
/** <#注释#>*/
@property (strong, nonatomic) NSString *bankCardNo;
/** <#注释#>*/
@property (strong, nonatomic) NSString *bankId;
/** <#注释#>*/
@property (strong, nonatomic) NSString *bankName;
/** <#注释#>*/
@property (strong, nonatomic) NSString *iconUrl;
/** <#注释#>*/
@property (assign, nonatomic) NSInteger defaultCard;
/** <#注释#>*/
@property (strong, nonatomic) NSString *identCode;



/** 朋友圈是否有更新*/
@property (assign, nonatomic) BOOL ringUpdata;

@end



@interface UserDefaultCardModel : BaseModel


//-------我的账户


@property (strong, nonatomic) NSString *profitAccountSum;//获利余额
@property (strong, nonatomic) NSString *profitSum;//累计获利余额
@property (strong, nonatomic) NSString *currency;//币种
@property (strong, nonatomic) NSString *defaultCardObj;//默认银行
/** 当前可兑换余额*/
@property (strong, nonatomic) NSString *transSum;







@end
