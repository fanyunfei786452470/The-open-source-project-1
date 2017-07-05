//
//  YRSunTextDetailHeaderView.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/20.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YRTapImageView;
@class YRSunTextDetailHeaderView;

@class YRSunTextDetailHeaderModel;

@protocol YRSunTextDetailHeaderViewDelegate <NSObject>

- (void)headerView:(YRSunTextDetailHeaderView *)view didClickedImageWithCellModel:(YRSunTextDetailHeaderModel *)model atIndex:(NSInteger)index WithArr:(NSMutableArray *)positionArr;

- (void)headerView:(YRSunTextDetailHeaderView *)view didClickedLikeButtonWithIsLike:(BOOL)isLike;

- (void)headerView:(YRSunTextDetailHeaderView *)view didClickedGiftButtonWithIsGift:(BOOL)isGift;

- (void)headerView:(YRSunTextDetailHeaderView *)view didClickedCommentWithCellModel:(YRSunTextDetailHeaderModel *)model;

- (void)headerView:(YRSunTextDetailHeaderView *)view didClickedVideoWithCellModel:(YRSunTextDetailHeaderModel *)model;
- (void)didClickDeleteSunText;
@end

@interface YRSunTextDetailHeaderView : UIView

@property (nonatomic,weak) id<YRSunTextDetailHeaderViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray<YRTapImageView *> *picViews;      // 图片

@property (nonatomic,strong) YRSunTextDetailHeaderModel *model;
@end
