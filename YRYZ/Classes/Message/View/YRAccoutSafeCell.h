//
//  YRAccoutSafeCell.h
//  YRYZ
//
//  Created by weishibo on 16/8/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRUserInfoLoginModel.h"
@interface YRAccoutSafeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLable;
@property (weak, nonatomic) IBOutlet UIButton *bageBtn;
- (void)setUIWithModel:(YRUserInfoLoginModel *)model;
@end
