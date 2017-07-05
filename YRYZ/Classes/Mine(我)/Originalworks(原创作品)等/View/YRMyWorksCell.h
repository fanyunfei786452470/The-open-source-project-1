//
//  YRMyWorksCell.h
//  YRYZ
//
//  Created by 易超 on 16/7/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRProductListModel.h"
@interface YRMyWorksCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bigTypeImage;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIImageView *typeImage;

@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *staueLabel;

@property (weak, nonatomic) IBOutlet UIImageView *downImage;

@property (weak, nonatomic) IBOutlet UIImageView *fowardImage;

- (void)setUIWithModle:(YRProductListModel *)model;
@end
