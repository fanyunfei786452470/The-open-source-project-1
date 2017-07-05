//
//  YRMine_mineCell.h
//  YRYZ
//
//  Created by 易超 on 16/7/18.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YRMine_mineCell : UITableViewCell

/** <#注释#>*/
@property (copy, nonatomic) void(^mineCellButtonClickBlock)(NSInteger);

@property (weak, nonatomic) IBOutlet UIButton *BtnB;

@property (weak, nonatomic) IBOutlet UIButton *BtnC;

@property (weak, nonatomic) IBOutlet UIButton *BtnA;

@property (weak, nonatomic) IBOutlet UIButton *BtnD;

@end
