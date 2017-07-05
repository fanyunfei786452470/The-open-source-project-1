//
//  YRImageTextCell.h
//  YRYZ
//
//  Created by 易超 on 16/7/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRProductListModel.h"
#import "YRCircleListModel.h"




@protocol YRImageTextCellDelegate <NSObject>
- (void)imageTextCellDelegate:(BasicAction)basicAction productModel:(YRProductListModel*)productModel;
@end


@protocol YRImageTextCircleCellDelegate <NSObject>
- (void)imageTextCellDelegate:(BasicAction)basicAction circleModel:(YRCircleListModel*)circleModel;
@end


@interface YRImageTextCell : UITableViewCell


- (void)setProductModel:(YRProductListModel *)productModel;
- (void)setCircleModel:(YRCircleListModel *)circleModel;
@property (nonatomic, assign) id<YRImageTextCellDelegate> delegate;

@property (nonatomic, assign) id<YRImageTextCircleCellDelegate> circledelegate;
@property (weak, nonatomic) IBOutlet UIButton *redButton;

@end
