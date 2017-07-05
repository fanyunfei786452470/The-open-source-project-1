//
//  BaskImageCell.h
//  TimeDemo
//
//  Created by 21.5 on 16/7/20.
//  Copyright © 2016年 21.5. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRUserBaskSunModel.h"

@interface BaskImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
//@property (weak, nonatomic) IBOutlet UIImageView *heaaimage;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *sumLab;
@property (weak, nonatomic) IBOutlet UIButton *headImageBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLyout;

@property (weak, nonatomic) IBOutlet UIImageView *typeImage;

- (void)setUIWithModel:(YRUserBaskSunModel *)model;
@end
