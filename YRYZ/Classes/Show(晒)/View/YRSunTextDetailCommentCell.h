//
//  YRSunTextDetailCommentCell.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/21.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSunTextDetailCell.h"
#import "YRCommentListModel.h"

@protocol YRSunTextDetailCommentCellDelegate <NSObject>

- (void)didClickLongPressGestureRecognizerCellWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface YRSunTextDetailCommentCell : UITableViewCell

@property (nonatomic,strong) UIImageView *msgImage;

@property (nonatomic,strong) NSIndexPath* indexPath;

@property (nonatomic,strong) YRCommentListModel *model;

@property (nonatomic,weak) id<YRSunTextDetailCommentCellDelegate> delegate;

@end
