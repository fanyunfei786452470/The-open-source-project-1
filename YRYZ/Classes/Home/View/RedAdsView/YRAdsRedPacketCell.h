//
//  YRAdsRedPacketCell.h
//  YRYZ
//
//  Created by 21.5 on 16/10/14.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRRedAdsModel.h"
@protocol YRAdsRedPacketCellDelegate <NSObject>
- (void)redAdsTableViewCellDelegate:(BasicAction)basicAction  redModel:(YRRedAdsModel*)redModel;
@end
@interface YRAdsRedPacketCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *userImage;
@property (strong, nonatomic)  UILabel *userName;
@property (strong, nonatomic)  UILabel *time;
@property (strong, nonatomic)  UILabel *num;
@property (strong, nonatomic)  UIImageView *redPack;
@property (strong, nonatomic)  UILabel *text;
@property (strong, nonatomic)  UIImageView *mainImage;
@property (strong, nonatomic)  UIButton *imageNum;
@property (strong, nonatomic)  UIButton *redPackButton;
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UIImageView *playImage;
@property (strong,nonatomic)   UIImageView * adsImage;
@property (strong,nonatomic)   UILabel * readCount;
@property (nonatomic, assign) id<YRAdsRedPacketCellDelegate> delegate;

@property(nonatomic,strong)YRRedAdsModel  *redModel;
@end
