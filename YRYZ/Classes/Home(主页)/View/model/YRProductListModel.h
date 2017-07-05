//
//  YRProductListModel.h
//  YRYZ
//
//  Created by weishibo on 16/8/20.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRProductListModel : BaseModel
@property (nonatomic,strong) NSString           *authorid;

@property (nonatomic,strong) NSString           *desc;

@property (nonatomic,strong) NSString           *headImg;

@property (nonatomic,assign) NSInteger          recommand; //是否推荐

@property (nonatomic,assign) NSInteger          forwardStatus; //是否转发

@property (nonatomic,assign) NSInteger          readStatus; //是否阅读

@property (nonatomic,assign) NSInteger          rewardStatus; //是否打赏

@property (nonatomic,strong) NSString           *transferBonud; //跟转数


@property (nonatomic,strong) NSString           *transferCount;//转发数

@property (nonatomic,assign) InfoProductType    type;

@property (nonatomic,strong) NSString           *uid;

@property (nonatomic,strong) NSString           *url; //oss地址

@property (nonatomic,strong) NSString           *custId;

@property (nonatomic,strong) NSString           *urlThumbnail;//缩略图地址



@end
