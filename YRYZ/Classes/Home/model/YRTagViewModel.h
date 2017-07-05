//
//  YRTagViewModel.h
//  YRYZ
//
//  Created by 21.5 on 16/9/22.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "BaseModel.h"

@interface YRTagViewModel : BaseModel

@property (nonatomic,assign)BOOL isSelected;//是否被选中
@property (nonatomic,copy)NSString * UID;//对应标签的uid
@property (nonatomic,strong)UIButton * btn;//对应的按钮
@end
