//
//  YRTranTableViewCell.h
//  YRYZ
//
//  Created by weishibo on 16/8/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRProudTranModel.h"
@interface YRTranTableViewCell : UITableViewCell
@property (nonatomic,copy) void(^choose)(BOOL isChoose) ;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (void)setTranModel:(YRProudTranModel *)tranModel;
@end
