//
//  YRRewardListModel.h
//  YRYZ
//
//  Created by weishibo on 16/8/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRRewardListModel : BaseModel


@property (nonatomic,strong) NSString           *headImg;

@property (nonatomic,strong) NSString           *userid;

@property (nonatomic,strong) NSString           *nickName;

@property (nonatomic,strong) NSString           *remark;

@property (nonatomic,strong) NSString           *time;

@property (nonatomic,strong) NSString           *img; //礼物缩略图

@property (nonatomic,strong) NSString           *gitfid; //礼物id

@end
