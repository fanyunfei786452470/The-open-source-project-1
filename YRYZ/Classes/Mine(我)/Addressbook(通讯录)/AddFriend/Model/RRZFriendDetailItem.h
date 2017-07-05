//
//  RRZFriendDetailItem.h
//  Rrz
//
//  Created by 易超 on 16/3/12.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "BaseModel.h"

@interface RRZFriendDetailItem : BaseModel

@property (strong, nonatomic) NSString *custName;
/** <#注释#>*/
@property (strong, nonatomic) NSString *custId;
/** <#注释#>*/
@property (strong, nonatomic) NSString *custNname;
/** <#注释#>*/
@property (strong, nonatomic) NSString *headPath;
/** 是否关注*/
@property (assign, nonatomic) BOOL isFollowers;
/** 是否好友*/
@property (assign, nonatomic) BOOL isFriend;
/** <#注释#>*/
@property (assign, nonatomic) BOOL isFun;
/** <#注释#>*/
@property (strong, nonatomic) NSString *nameNotes;
/** <#注释#>*/
@property (strong, nonatomic) NSString *signature;
/** <#注释#>*/
@property (strong, nonatomic) NSString *location;

/** <#注释#>*/
@property (strong, nonatomic) NSString *custNo;
/** <#注释#>*/
@property (assign, nonatomic) NSInteger custSex;

/** <#注释#>*/
@property (strong, nonatomic) NSArray *pathList;

/** 好友关系  1、单方关注   2、黑名单   3、相互关注*/
@property (assign, nonatomic) NSInteger custType;

@end
