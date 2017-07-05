//
//  YRAdListItem.h
//  YRYZ
//
//  Created by 易超 on 16/7/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRAdListItem : BaseModel<NSCopying>

@property(assign,nonatomic) BOOL isSelete;

@property (nonatomic,strong) UIImage *avatar;
 
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
@property (copy, nonatomic) NSString *nameNotes;

@property (strong, nonatomic) NSString *custPhone;

/** 好友关系*/
//@property (assign, nonatomic) NSInteger custType;

@property (nonatomic,copy) NSString     *uid;

@property (nonatomic,copy) NSString *custImg;

@property (nonatomic,copy) NSString *custNo;

@property (nonatomic,copy) NSString *custSignature;
@end
