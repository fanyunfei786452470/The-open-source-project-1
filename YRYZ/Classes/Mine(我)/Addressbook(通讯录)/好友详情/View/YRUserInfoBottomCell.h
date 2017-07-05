//
//  YRUserInfoBottomCell.h
//  YRYZ
//
//  Created by 易超 on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRUserInfoBottomCell : UITableViewCell

@property (nonatomic,copy) NSString *custId;
@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (nonatomic,copy) void (^choose)(BOOL ischoose);
@end
