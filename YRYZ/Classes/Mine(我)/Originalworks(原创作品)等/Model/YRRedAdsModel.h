//
//  YRRedAdsModel.h
//  YRYZ
//
//  Created by Sean on 16/9/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRRedAdsModel : BaseModel
@property (nonatomic,copy) NSString *adsId;
@property (nonatomic,copy) NSString *advertStatus;
@property (nonatomic,copy) NSString *auditTime;
@property (nonatomic,copy) NSString *expireDate;

@property (nonatomic,copy) NSString *redpacketId;

@property (nonatomic,copy) NSString *smallPic;
@property (nonatomic,copy) NSString *submitTime;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString  *payDays;
@property (nonatomic,copy) NSString * adsDesc;
@property (nonatomic,copy) NSString *upedTime;
@property (nonatomic,copy) NSString *code;

@property (nonatomic,assign) NSInteger remainAmount;
@property (nonatomic,assign) NSInteger isEnableEdit;
@property (nonatomic,assign) NSInteger isEnableRenew;
@property (nonatomic,assign) NSInteger isRenew;
@property (nonatomic,assign) NSInteger packetStatus;//红包状态 0：有效 1：过期 2：已领完 3：退款


@property (nonatomic,assign) NSInteger picCount;
@property (nonatomic,copy) NSString    *readCount;//阅读数
@property (nonatomic,assign) NSInteger receiveNum;
@property (nonatomic,assign) NSInteger totalNum;
@property (nonatomic,assign) NSInteger type;



@property (strong,nonatomic) NSString * desc;
@property (strong,nonatomic) NSString * remark;
@property (strong,nonatomic) NSString * custId;
@property (strong,nonatomic) NSString * nickName;
@property (strong,nonatomic) NSString * headImg;
@property (strong,nonatomic) NSString * contentPath;
@property (strong,nonatomic) NSString * phone;
@property (strong,nonatomic) NSString * custDesc;

@end







