//
//  YRProductDetail.h
//  YRYZ
//
//  Created by weishibo on 16/8/20.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRProductDetail : BaseModel

@property (nonatomic,strong) NSString           *custId;

@property (nonatomic,strong) NSString           *custNname;

@property (nonatomic,strong) NSString           *nameNotes;
@property (nonatomic,strong) NSString           *custSignature;

@property (nonatomic,strong) NSString           *desc;

@property (nonatomic,strong) NSString           *isCollect;


@property (nonatomic,assign) InfoProductType    type;

@property (nonatomic,strong) NSString           *uid; //作品唯一标记

@property (nonatomic,strong) NSString           *url;

@property (nonatomic,strong) NSString           *urlThumbnail;


@property (nonatomic,strong) NSString           *urls;


@property (nonatomic,assign) NSInteger          collectStatus;
@property (nonatomic,assign) NSInteger          commentCount;
@property (nonatomic,assign) NSInteger          commentStatus;//评论状态



@property (nonatomic,assign) NSInteger          forwardStatus;
@property (nonatomic,assign) NSInteger          goodCount;//评论状态


@property (nonatomic,assign) NSInteger          goodStatus;

@property (nonatomic,strong) NSString           *headImg;

@property (nonatomic,strong) NSString           *createDate;



@property (nonatomic,strong) NSString           *infoIntroduction;


@property (nonatomic,copy) NSString             *readCount; //阅读数
@property (nonatomic,assign) NSInteger          recommand;



@property (nonatomic,assign) NSInteger          rewardCount;
@property (nonatomic,copy) NSString             *forwardCount;
@property (nonatomic,assign) NSInteger          transferBonud;
@property (nonatomic,assign) NSInteger          rewardStatus;


@property (nonatomic,strong) NSArray            *tageList;
@property (nonatomic,assign) NSInteger          forward1Count;
@property (nonatomic,assign) NSInteger          forward2Count;
@property (nonatomic,assign) NSInteger          forward3Count;

 

//搜索model
@property (nonatomic,copy) NSString *infoUrl;
@property (nonatomic,copy) NSString *infoThumbnail;
@property (nonatomic,copy) NSString *auditStatus;
@property (nonatomic,copy) NSString *infoTitle;
@property (nonatomic,assign) NSInteger infoType;
@property (nonatomic,assign) NSInteger    infoTime;


@property (nonatomic,assign) NSInteger          readStatus; //是否阅读

@property (nonatomic,assign) NSInteger          infoForwardStatus; //最终的转发状态
@property (nonatomic,copy) NSString             *custDesc;//简介

@property (nonatomic,strong) NSString           *redpacketId;


@end
