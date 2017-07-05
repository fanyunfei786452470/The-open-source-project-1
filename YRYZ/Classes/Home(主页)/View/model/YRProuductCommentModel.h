//
//  YRProuductCommentModel.h
//  YRYZ
//
//  Created by 易超 on 16/8/22.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRProuductCommentModel : BaseModel
@property (nonatomic,strong) NSString           *authorHeadimg;

@property (nonatomic,strong) NSString           *authorName;

@property (nonatomic,strong) NSString           *authorid;

@property (nonatomic,strong) NSString           *content;


@property (nonatomic,strong) NSString           *time;

@property (nonatomic,assign) NSInteger          type; //评论类型

@property (nonatomic,strong) NSString           *uid; //唯一标识

@property (nonatomic,strong) NSString           *userHeadimg;

@property (nonatomic,strong) NSString           *userName;//评论人

@property (nonatomic,strong) NSString           *userid;//评论人id

@end
