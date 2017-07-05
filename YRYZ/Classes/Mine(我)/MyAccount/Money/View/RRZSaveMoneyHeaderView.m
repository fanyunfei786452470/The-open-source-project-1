//
//  RRZSaveMoneyHeaderView.m
//  Rrz
//
//  Created by 易超 on 16/5/2.
//  Copyright © 2016年 rongzhongwang. All rights reserved.
//

#import "RRZSaveMoneyHeaderView.h"

@interface RRZSaveMoneyHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@end

@implementation RRZSaveMoneyHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImageView.layer.cornerRadius = 5;
    _headImageView.layer.masksToBounds = YES;
    
    if ([YRUserInfoManager manager].currentUser.custId) {
        [_headImageView setImageWithURL:[NSURL URLWithString:[YRUserInfoManager manager].currentUser.custImg] placeholder:[UIImage defaultHead]];
        _subTitleLabel.text = [YRUserInfoManager manager].currentUser.custNname;
//        _subTitleLabel.text = [YRUserInfoManager sharedController].currentUser.custPhone;
    }
}

@end
