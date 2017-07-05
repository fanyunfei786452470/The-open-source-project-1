//
//  RRZGoodFriend.h
//  Rrz
//
//  Created by 易超 on 16/3/10.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "BaseModel.h"

@interface RRZGoodFriendItem : BaseModel

/** 用户ID*/
@property (strong, nonatomic) NSString *custId;

/** 用户名*/
@property (strong, nonatomic) NSString *custNname;

@property (strong, nonatomic) NSString *custName;

/** <#注释#>*/
@property (strong, nonatomic) NSString *headPath;

/** <#注释#>*/
@property (strong, nonatomic) NSString *signature;

/** <#注释#>*/
@property (strong, nonatomic) NSString *nameNotes;

@property (strong, nonatomic) NSString *custPhone;

/** 好友关系*/
@property (assign, nonatomic) NSInteger custType;
/** 好友关系   (-1:用户不存在，0:陌生人，1: 关注，2:粉丝，3:好友)  */
@property (nonatomic,copy) NSString *relation;

@property (nonatomic,copy) NSString *custImg;

@property (nonatomic,copy) NSString *custNo;

@property (nonatomic,copy) NSString *custSignature;
 
@end





