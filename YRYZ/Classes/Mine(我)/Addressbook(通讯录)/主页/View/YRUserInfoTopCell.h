//
//  YRUserInfoTopCell.h
//  YRYZ
//
//  Created by 易超 on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRUserDetail.h"
@interface YRUserInfoTopCell : UITableViewCell
@property (nonatomic,copy) void(^choose)(BOOL click);
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
- (void)serUIWithModel:(YRUserDetail *)model;

@end
