//
//  YRCircleListModel.h
//  YRYZ
//
//  Created by weishibo on 16/8/23.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRCircleListModel : BaseModel
@property (nonatomic,assign) NSInteger          auditStatus;

@property (nonatomic,strong) NSString           *authorId;

@property (nonatomic,strong) NSString           *clubId;//唯一标示

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
@property (nonatomic,copy)   NSString           *infoThumbnail;
@property (nonatomic,assign) NSInteger          redpacketStatus;

@property (nonatomic,strong) NSString           *timeDif;
@property (nonatomic,assign) NSInteger          transferBonud; //收益
@property (nonatomic,assign) NSInteger          transferCount; //转发数
@property (nonatomic,strong) NSIndexPath        *indexPath;

@property (nonatomic ,assign)NSInteger           indexId;

@property (nonatomic,assign) NSInteger           infoTime; //时长

@property (nonatomic,assign) NSInteger           infoForwardStatus; // 0未转化  1转发

@property (nonatomic,strong) NSString             *nameNotes;


@end
