//
//  YRUserInfoLoginModel.h
//  YRYZ
//
//  Created by Sean on 16/9/8.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRUserInfoLoginModel : BaseModel

@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *isPrimary;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *openId;
@property (nonatomic,copy) NSString *type;
@end
