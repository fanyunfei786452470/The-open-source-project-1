//
//  YRCollectCell.h
//  YRYZ
//
//  Created by 易超 on 16/7/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRProductListModel.h"
@interface YRCollectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *downImage;

/** <#注释#>*/
@property (copy, nonatomic) void(^cancelCollectBtnBlock)(UIButton *);
- (void)setUIWithModel:(YRProductListModel *)model;
@end
