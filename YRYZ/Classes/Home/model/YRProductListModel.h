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

@property (nonatomic,copy) NSString             *custImg;

@property (nonatomic,assign) NSInteger          recommand; //是否推荐

@property (nonatomic,assign) NSInteger          forwardStatus; //是否转发

@property (nonatomic,assign) NSInteger          readStatus; //是否阅读

@property (nonatomic,assign) NSInteger          rewardStatus; //是否打赏

@property (nonatomic,strong) NSString           *transferBonud; //跟转数


@property (nonatomic,strong) NSString           *transferCount;//转发数

@property (nonatomic,assign) InfoProductType    type;

@property (nonatomic,strong) NSString           *uid; //作品id

@property (nonatomic,strong) NSString           *url; //oss地址

@property (nonatomic,strong) NSString           *custId; //作者id

@property (nonatomic,strong) NSString           *urlThumbnail;//缩略图地址

@property (nonatomic,assign) NSInteger          infoTime; //时长

@property (nonatomic,strong) NSIndexPath        *indexPath;

//我的sch
@property (nonatomic,strong) NSString           *custDesc;
@property (nonatomic,strong) NSString           *createDate;
@property (nonatomic,strong) NSString           *custNname;
@property (nonatomic,strong) NSString           *custSignature;
@property (nonatomic,strong) NSString           *infoIntroduction;
@property (nonatomic,copy) NSString             *clubId;

@property (nonatomic,copy) NSString             *infoCustId;
@property (nonatomic,copy) NSString             *infoId;
@property (nonatomic,copy) NSString             *infoStatus;
@property (nonatomic,copy) NSString             *infoThumbnail;
@property (nonatomic,copy) NSString             *infoTitle;
@property (nonatomic,assign)InfoProductType      infoType;
@property (nonatomic,copy) NSString              *sysType;

@property (nonatomic,assign) CGFloat            height;
/**作品状态  0:未审核，1:审核中，2:驳回 3:通过 4:下架**/
@property (nonatomic,assign) NSInteger auditStatus;

@property (nonatomic,copy) NSString             *nameNotes;//备注名


@property (nonatomic,assign) NSInteger            infoForwardStatus;//间接转发
@end
