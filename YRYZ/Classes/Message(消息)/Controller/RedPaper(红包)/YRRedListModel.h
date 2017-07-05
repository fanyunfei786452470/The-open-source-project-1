//
//  YRRedListModel.h
//  YRYZ
//
//  Created by weishibo on 16/8/26.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRRedListModel : BaseModel
@property (nonatomic ,strong) NSString *headImg;
@property (nonatomic ,strong) NSString *nickName;
@property (nonatomic ,strong) NSString *rcfee;//领取金额（分）
@property (nonatomic ,strong) NSString *reid;//子包id
@property (nonatomic ,strong) NSString *remark;//备注
@property (nonatomic ,strong) NSString *rid;//红包id
@property (nonatomic ,strong) NSString *userid;
@end
