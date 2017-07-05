//
//  YRModelManager.h
//  YRYZ
//
//  Created by Sean on 16/10/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YRCircleListModel.h"
#import "YRProductListModel.h"
@interface YRModelManager : NSObject


@property (nonatomic,weak) YRCircleListModel *corcleModel;
@property (nonatomic,assign) NSInteger     baseSelectController;

@property (nonatomic,weak) YRProductListModel  *listModel;

@property (nonatomic,assign) BOOL    collect;

+(YRModelManager *)manager;


@end
