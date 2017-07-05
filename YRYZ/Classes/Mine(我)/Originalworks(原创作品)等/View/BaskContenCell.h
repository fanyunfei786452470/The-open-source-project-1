//
//  BaskContenCell.h
//  TimeDemo
//
//  Created by 21.5 on 16/7/20.
//  Copyright © 2016年 21.5. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRUserBaskSunModel.h"
@interface BaskContenCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
- (CGFloat)cellHeight:(NSDictionary *)model;
@end
