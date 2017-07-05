//
//  RRZUserInfoItem.h
//  Rrz
//
//  Created by 易超 on 16/3/19.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "BaseModel.h"

@interface RRZUserInfoItem : BaseModel

/** */
@property (strong, nonatomic) NSString *custAddr;
/** */
@property (strong, nonatomic) NSString *custBirthday;
/** */
@property (strong, nonatomic) NSString *custIdentified;
/** */
@property (strong, nonatomic) NSString *custImgId;
/** */
@property (strong, nonatomic) NSString *custNname;
/** */
@property (strong, nonatomic) NSString *custSex;
/** */
@property (strong, nonatomic) NSString *signature;
/** */
@property (strong, nonatomic) NSString *uuid;
/**二维码*/
@property (strong, nonatomic) NSString *twoDimenCode;
/** */
@property (strong, nonatomic) NSString *location;

@end
