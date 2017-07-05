//
//  YRCircleListModel.h
//  YRYZ
//
//  Created by weishibo on 16/8/23.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRCircleListModel : BaseModel


@property (nonatomic,strong) NSString           *authorId;

@property (nonatomic,strong) NSString           *clubId;

@property (nonatomic,strong) NSString           *createDate;

@property (nonatomic,strong) NSString           *custId;

@property (nonatomic,strong) NSString           *custName;

@property (nonatomic,strong) NSString           *custNname;

@property (nonatomic,strong) NSString           *custSignature;

@property (nonatomic,strong) NSString           *fileUrl;

@property (nonatomic,assign) NSInteger          forwardStatus;

@property (nonatomic,strong) NSString           *headPath;

@property (nonatomic,strong) NSString           *infoId;

@property (nonatomic,strong) NSString           *infoIntroduction;

@property (nonatomic,strong) NSString           *infoTitle;

@property (nonatomic,assign) InfoProductType    infoType;

@property (nonatomic,strong) NSString           *redpacketId;

@property (nonatomic,assign) NSInteger          redpacketStatus;

@property (nonatomic,strong) NSString           *timeDif;
@property (nonatomic,assign) NSInteger          transferBonud; //收益
@property (nonatomic,assign) NSInteger          transferCount; //转发数
@end
