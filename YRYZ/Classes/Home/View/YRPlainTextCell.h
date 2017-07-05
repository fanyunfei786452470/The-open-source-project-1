//
//  YRPlainTextCell.h
//  YRYZ
//
//  Created by 21.5 on 16/9/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRCircleListModel.h"
#import "YRProductListModel.h"
@protocol YRPlainTextCellDelegate <NSObject>
- (void)imageTextCellDelegate:(BasicAction)basicAction productModel:(YRProductListModel*)productModel;
@end
@protocol YRPlainTextCircleCellDelegate <NSObject>
- (void)imageTextCellDelegate:(BasicAction)basicAction circleModel:(YRCircleListModel*)circleModel;
@end
@interface YRPlainTextCell :UITableViewCell
- (void)setProductModel:(YRProductListModel *)productModel;
@property (nonatomic, assign) id<YRPlainTextCellDelegate> delegate;

@property (nonatomic, assign) id<YRPlainTextCircleCellDelegate> circledelegate;
@property (strong, nonatomic) UIButton *redButton;
@property (assign,nonatomic) NSInteger type;
//转发按钮
@property (strong, nonatomic)  UIButton           *tranBtn;
@end
