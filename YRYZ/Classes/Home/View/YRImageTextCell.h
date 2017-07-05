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
- (void)imageTextCellDelegate:(BasicAction)basicAction circleModel:(YRCircleListModel*)circleModel  indexPosition:(NSInteger)indexPosition;
@end


@interface YRImageTextCell : UITableViewCell


- (void)setProductModel:(YRProductListModel *)productModel;
- (void)setCircleModel:(YRCircleListModel *)circleModel  indexPosition:(NSInteger)indexPosition;
@property (nonatomic, assign) id<YRImageTextCellDelegate> delegate;

@property (nonatomic, assign) id<YRImageTextCircleCellDelegate> circledelegate;
@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet UIImageView        *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel            *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel            *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView        *videoBgImage;//视频标记

@property (weak, nonatomic) IBOutlet UILabel            *tranCountLabel;
@property (weak, nonatomic) IBOutlet UILabel            *lucreLabel;

@property (weak, nonatomic) IBOutlet UIImageView        *infoImageView;
@property (weak, nonatomic) IBOutlet UILabel            *infoTitleLabel;


@property (weak, nonatomic) IBOutlet UIButton           *awardBtn;
@property (weak, nonatomic) IBOutlet UIButton           *tranBtn;
@property (weak, nonatomic) IBOutlet UIImageView        *prouductRecommendImageView;
@property (weak, nonatomic) IBOutlet UIImageView        *productTranSate;


@property (weak, nonatomic) IBOutlet UILabel            *tranTipLabel;
@property (weak, nonatomic) IBOutlet UILabel            *earningTipLabel;

@property (nonatomic,assign) NSInteger                  indexPosition;

@end
