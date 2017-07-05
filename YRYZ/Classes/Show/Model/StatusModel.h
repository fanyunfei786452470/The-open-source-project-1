//
//  StatusModel.h
//  LWAsyncDisplayViewDemo
//
//  Created by 刘微 on 16/4/5.
//  Copyright © 2016年 WayneInc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWAlchemy.h"

@interface StatusModel : BaseModel

@property (nullable, nonatomic, copy) NSString* type;
@property (nullable, nonatomic, copy) NSString* custId;
@property (nullable, nonatomic, copy) NSString *sid;
@property (nullable, nonatomic, copy) NSString *videoPic;
@property (nullable, nonatomic, copy) NSString *videoUrl;

@property (nullable, nonatomic, strong) NSURL* custImg;
@property (nullable, nonatomic, copy) NSString* content;
//@property (nullable, nonatomic, copy) NSString* detail;
//@property (nullable, nonatomic, strong) NSDate* date;
@property (nullable, nonatomic, strong) NSString* timeStamp;

@property (nonatomic,assign) NSInteger onePicH;
@property (nonatomic,assign) NSInteger onePicW;

@property (nullable, nonatomic, copy) NSArray* pics;
@property (nullable, nonatomic, copy) NSString* custNname;
@property (nullable, nonatomic, copy) NSString* nameNotes;

@property (nullable, nonatomic, strong) NSNumber* statusID;
@property (nullable, nonatomic, copy) NSArray* comments;
@property (nullable, nonatomic, copy) NSArray* likes;
@property (nonatomic,assign) NSInteger isLike;
@property (nullable, nonatomic, copy) NSArray* giftList;
@property (nonatomic,assign) NSInteger likeCount;
@property (nonatomic,assign) BOOL isGift;

@end