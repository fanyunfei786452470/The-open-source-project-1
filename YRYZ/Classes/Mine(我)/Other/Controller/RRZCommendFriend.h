//
//  RRZCommendFriend.h
//  Rrz
//
//  Created by 易超 on 16/3/11.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "BaseModel.h"

@interface RRZCommendFriend : BaseModel

/** <#注释#>*/
@property (strong, nonatomic) NSString *custId;

@property (nonatomic,copy) NSString *custImg;
/** <#注释#>*/
@property (strong, nonatomic) NSString *nameNotes;
/** <#注释#>*/
@property (strong, nonatomic) NSString *custPhone;
@property (strong, nonatomic) NSString *headPath;
@property (strong, nonatomic) NSString *signature;
/** <#注释#>*/
@property (assign, nonatomic) BOOL isFollowers;
@property (assign, nonatomic) BOOL isFriend;
@property (assign, nonatomic) BOOL isFun;

@property (nonatomic,copy) NSString *custNname;

/** 是否选中*/
@property (assign, nonatomic) BOOL isSel;

@property (nonatomic,copy) NSString *cust;

@property (nonatomic,copy) NSString *custLevel;
@property (nonatomic,copy) NSString *custLocation;
@property (nonatomic,copy) NSString *custSex;
@property (nonatomic,copy) NSString *isPwdExist;
@property (nonatomic,copy) NSString *relation;

@end
