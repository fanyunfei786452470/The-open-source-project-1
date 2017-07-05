//
//  YRPhoneContactCell.h
//  tabeldataSource
//
//  Created by Sean on 16/8/19.
//  Copyright © 2016年 Sean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRPhoneContactCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@property (weak, nonatomic) IBOutlet UIButton *isFocus;

@property (nonatomic,copy) void(^choose)(BOOL isClick);

@end
