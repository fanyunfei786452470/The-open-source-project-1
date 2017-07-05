//
//  YRCommentTableViewCell.h
//  YRYZ
//
//  Created by weishibo on 16/8/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRProuductCommentModel.h"

@protocol YRCommentTableViewCellDelegate <NSObject>

- (void)didClickLongPressGestureRecognizerCellWithIndexPath:(NSIndexPath *)indexPath;

@end



@interface YRCommentTableViewCell : UITableViewCell


- (void)setCommentModel:(YRProuductCommentModel *)commentModel;


@property (nonatomic,weak) id<YRCommentTableViewCellDelegate> delegate;


@property (nonatomic,strong) NSIndexPath* indexPath;


@end
