//
//  YRTheAnnouncementCell.h
//  YRYZ
//
//  Created by Sean on 16/8/25.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRTheAnnouncementCell : UITableViewCell
@property (strong,nonatomic)NSString * titleStr;
@property (strong,nonatomic)NSString * contentStr;
//- (void)setMyTitleName:(NSString*)name;
//@property (nonatomic,weak) UILabel *title;

@property (strong,nonatomic)UILabel * titleLabel;
@property (strong,nonatomic)UILabel * contentLabel;
@property (strong,nonatomic)UILabel * timeLabel;
@end
