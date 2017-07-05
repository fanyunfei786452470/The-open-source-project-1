//
//  YRCommentListModel.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/26.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YRCommentListModel : BaseModel


@property (nonatomic,assign) CGFloat cellHeight;

@property (nullable,nonatomic,copy) NSString *_id;

@property (nullable,nonatomic,copy) NSString *authorHeadImg;//被评论人头像

@property (nullable,nonatomic,copy) NSString *authorId;//被评论人id

@property (nullable,nonatomic,copy) NSString *authorName;//被评论人

@property (nullable,nonatomic,copy) NSString *cid;//评论id

@property (nullable,nonatomic,copy) NSString *content;//内容

@property (nullable,nonatomic,copy) NSString *sid;//晒一晒id

@property (nullable,nonatomic,copy) NSString *timeStamp;//时间

@property (nullable,nonatomic,copy) NSString *userHeadImg;//评论人头像

@property (nullable,nonatomic,copy) NSString *userId;//评论人id

@property (nullable,nonatomic,copy) NSString *userName;//评论人名


@end
