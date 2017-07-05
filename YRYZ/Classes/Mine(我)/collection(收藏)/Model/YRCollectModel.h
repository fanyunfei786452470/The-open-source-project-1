//
//  YRCollectModel.h
//  YRYZ
//
//  Created by Sean on 16/9/5.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRCollectModel : BaseModel
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *custId;
@property (nonatomic,copy) NSString *custImg;
@property (nonatomic,copy) NSString *custNname;
@property (nonatomic,copy) NSString *custSignature;
@property (nonatomic,copy) NSString *infoCustId;
@property (nonatomic,copy) NSString *infoId;
@property (nonatomic,copy) NSString *infoStatus;
@property (nonatomic,copy) NSString *infoThumbnail;
@property (nonatomic,copy) NSString *infoTitle;
@property (nonatomic,assign) InfoProductType  infoType;
@property (nonatomic,copy) NSString *sysType;

@end
