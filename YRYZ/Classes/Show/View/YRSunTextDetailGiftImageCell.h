//
//  YRSunTextDetailGiftImageCell.h
//  YRYZ
//
//  Created by Mrs_zhang on 16/8/2.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YRGiftListModel;

@interface YRSunTextDetailGiftImageCell : UICollectionViewCell
@property (nonatomic,weak) UIImageView *iconImg;

@property (nonatomic,weak) UILabel *countLab;

@property (nonatomic,strong) YRGiftListModel *model;


@end
