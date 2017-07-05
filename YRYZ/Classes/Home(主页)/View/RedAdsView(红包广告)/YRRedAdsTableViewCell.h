//
//  YRRedAdsTableViewCell.h
//  YRYZ
//
//  Created by Sean on 16/8/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol YRRedAdsTableViewCellDelegate <NSObject>
- (void)redAdsTableViewCellDelegate:(BasicAction)basicAction;
@end




@interface YRRedAdsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIButton *num;
@property (weak, nonatomic) IBOutlet UIImageView *redPack;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIButton *imageNum;
@property (weak, nonatomic) IBOutlet UIButton *redPackButton;
- (IBAction)redPackButtonClick:(id)sender;


@property (nonatomic, assign) id<YRRedAdsTableViewCellDelegate> delegate;


@end
