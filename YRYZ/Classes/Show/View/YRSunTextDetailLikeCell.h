//
//  YRSunTextDetailLikeCell.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSunTextDetailCell.h"

#import "YRLikeListHeightModel.h"

@protocol YRSunTextDetailLikeCellDelegate <NSObject>


- (void)didSeleteHeaderImgWithCustId:(NSString *)custId;


@end

@interface YRSunTextDetailLikeCell : YRSunTextDetailCell

@property (nonatomic,strong) NSMutableArray *likeListArr;

@property (nonatomic,strong) YRLikeListHeightModel *model;

@property (nonatomic,weak) id<YRSunTextDetailLikeCellDelegate> delegate;

- (void)reloadData;

@end
