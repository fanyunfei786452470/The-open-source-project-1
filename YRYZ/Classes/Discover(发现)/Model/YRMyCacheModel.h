//
//  YRMyCacheModel.h
//  YRYZ
//
//  Created by Sean on 16/9/2.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRMyCacheModel : BaseModel<NSCopying>

@property (nonatomic,copy) NSString *name;

@property (nonatomic,assign) NSInteger *age;

@property (nonatomic,assign) BOOL sex;

@property (nonatomic,copy) NSString *imageName;

@end
