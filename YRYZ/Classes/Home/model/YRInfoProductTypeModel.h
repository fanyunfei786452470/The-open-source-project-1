//
//  YRInfoProductTypeModel.h
//  YRYZ
//
//  Created by weishibo on 16/8/20.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRInfoProductTypeModel : BaseModel
@property (nonatomic, strong) NSString              *channelType;
@property (nonatomic, strong) NSString              *channelPid;
@property (nonatomic, strong) NSString              *uid;
@property (nonatomic, strong) NSString              *channelOrder;
@property (nonatomic, strong) NSString              *channelLogo;
@property (nonatomic, strong) NSString              *channelName;
@end
