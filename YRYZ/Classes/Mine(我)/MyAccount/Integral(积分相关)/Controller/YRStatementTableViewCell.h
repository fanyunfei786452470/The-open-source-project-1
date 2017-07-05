//
//  YRStatementTableViewCell.h
//  YRYZ
//
//  Created by Sean on 16/8/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRStatementTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *money;

@property (weak, nonatomic) IBOutlet UILabel *time;

@end
