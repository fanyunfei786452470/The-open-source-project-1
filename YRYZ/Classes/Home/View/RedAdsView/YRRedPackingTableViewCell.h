//
//  YRRedPackingTableViewCell.h
//  YRYZ
//
//  Created by Sean on 16/8/12.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRRedPackingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *adsNumber;

@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UILabel *time;
/***退款*/
@property (weak, nonatomic) IBOutlet UIButton *redBack;
/***修改*/
@property (weak, nonatomic) IBOutlet UIButton *isBacking;
@property (weak, nonatomic) IBOutlet UILabel *titles;
/** state==0  退款中  state==1 退款完成 state==2 显示两个按钮 红包退款和修改按钮 **/
@property (nonatomic,assign) NSInteger state;

@property (nonatomic,copy) void(^backMoney)(BOOL back);

@property (nonatomic,copy) void(^change) (BOOL isChange);

@end
