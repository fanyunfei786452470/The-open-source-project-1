//
//  YRRemovePersonModel.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/9/9.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YRRemovePersonModel : NSObject


@property (nonatomic,copy) NSString *nickName;

@property (nonatomic,copy) NSString *displayName;

@property (nonatomic,copy) NSString *personId;

@property (nonatomic,strong) UIImage *avatar;

@property (nonatomic,copy) NSString *custPhone;


@end
