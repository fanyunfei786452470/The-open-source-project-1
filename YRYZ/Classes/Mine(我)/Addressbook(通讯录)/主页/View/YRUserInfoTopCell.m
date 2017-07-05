//
//  YRUserInfoTopCell.m
//  YRYZ
//
//  Created by 易超 on 16/7/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRUserInfoTopCell.h"
//#import <YYImage.h>
@interface YRUserInfoTopCell()


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *nikName;

@end

@implementation YRUserInfoTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.nameLabel.textColor = RGB_COLOR(175, 175, 175);
     self.nikName.textColor = RGB_COLOR(136, 136, 136);
//    self.signLabel.textColor = RGB_COLOR(175, 175, 175);
    // Initialization code
    self.iconImageView.userInteractionEnabled = YES;
    [self.iconImageView addTapGesturesTarget:self selector:@selector(iconImageViewClick)];
}
- (void)serUIWithModel:(YRUserDetail *)model{
    [self.iconImageView setImageWithURL:[NSURL URLWithString:model.custImg] placeholder:[UIImage imageNamed:@"yr_user_defaut"]];
    NSString *nikName = model.nameNotes;
    if (nikName.length>0) {
        self.nameLabel.text = nikName;
        self.nikName.text = [NSString stringWithFormat:@"昵称:%@",model.custNname];
        self.nikName.hidden = NO;
    }else{
        self.nameLabel.text = model.custNname;
        self.nikName.hidden = YES;
    }
    self.signLabel.text = [NSString stringWithFormat:@"个人签名:%@",model.custSignature?model.custSignature:@""];
    self.address.text = model.custLocation;
    [model.custSex boolValue]?[self.sexImageView setImage:[UIImage imageNamed:@"yr_man"]]:[self.sexImageView setImage:[UIImage imageNamed:@"yr_women"]];
    
}
- (void)iconImageViewClick{
    if (self.choose) {
            self.choose(YES);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
