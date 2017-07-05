//
//  friendsModel.h
//  Rrz
//
//  Created by weishibo on 16/3/7.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "BaseModel.h"

@interface FriendsModel : BaseModel
@property (nonatomic, copy) NSString *custId;
@property (nonatomic, copy) NSString *custPhone;
@property (nonatomic, copy) NSString *signature;

@property (strong, nonatomic) NSString *custName;
/** <#注释#>*/
@property (strong, nonatomic) NSString *custNname;
@property (strong, nonatomic) NSString *nameNotes;

/** <#注释#>*/
@property (strong, nonatomic) NSString *headPath;

@property (nonatomic,copy) NSString *custImg;
@property (nonatomic,copy) NSString *custSignature;
/**relation =1 互相关注 relation = 0 关注 **/
@property (nonatomic,copy) NSString *relation;

/** 
 好友关系:
 1、单方关注
 2、黑名单
 3、相互关注
 */
@property (assign, nonatomic) NSInteger custType;

/** <#注释#>*/
@property (assign, nonatomic) BOOL isSel;

@end
