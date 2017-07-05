//
//  YRSunTextDetailHeaderModel.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YRSunTextDetailHeaderModel : BaseModel

@property (nonatomic,assign) CGFloat headerViewH;
@property (nullable, nonatomic, copy) NSString* type;
@property (nullable, nonatomic, strong) NSURL* custImg;
@property (nullable, nonatomic, copy) NSString* custNname;
@property (nullable, nonatomic, copy) NSString* nameNotes;

@property (nullable, nonatomic, copy) NSString* custId;
@property (nullable, nonatomic, copy) NSString* content;
@property (nullable, nonatomic, copy) NSString* timeStamp;
//@property (nullable, nonatomic, strong) NSDate* date;
@property (nullable, nonatomic, copy) NSArray* pics;
@property (nullable, nonatomic, strong) NSNumber* statusID;
@property (nullable, nonatomic, copy) NSArray* commentList;
@property (nullable, nonatomic, copy) NSArray* likeList;
@property (nullable, nonatomic, copy) NSString* videoUrl;
@property (nullable, nonatomic, copy) NSString* videoPic;
@property (nonatomic,assign) BOOL isLike;
@property (nullable, nonatomic, copy) NSArray* giftList;
@property (nonatomic,assign) BOOL isGift;

@end
