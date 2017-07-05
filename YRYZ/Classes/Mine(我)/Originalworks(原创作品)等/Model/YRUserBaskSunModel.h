//
//  YRUserBaskSunModel.h
//  YRYZ
//
//  Created by Sean on 16/8/26.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRUserBaskSunModel : BaseModel


@property (nonatomic,copy) NSString *commentCount;

@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *custId;
@property (nonatomic,copy) NSString *custNname;

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *isLike;
@property (nonatomic,copy) NSString *likeCount;


@property (nonatomic,copy) NSString *sendTime;
@property (nonatomic,copy) NSString *sid;
@property (nonatomic,copy) NSString *timeStamp;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *videoPic;
@property (nonatomic,copy) NSString *videoUrl;

@property (nonatomic,copy) NSString *month;
@property (nonatomic,copy) NSString *day;
@property (nonatomic,copy) NSString *custImg;

@property (nonatomic,assign) BOOL isYesterday;

//实体信息
@property (nonatomic,copy) NSArray *gifts;
//点赞列表
@property (nonatomic,copy) NSArray *likes;
//评论列表
@property (nonatomic,copy) NSArray *comments;
@property (nonatomic,copy) NSArray *pics;
@end

@interface BaskPicModel : BaseModel

@property (nonatomic,copy) NSString *ids;
@property (nonatomic,copy) NSString *url;

@end







