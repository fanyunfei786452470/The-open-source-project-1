//
//  YRAdsRedPacketCell.m
//  YRYZ
//
//  Created by 21.5 on 16/10/14.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRAdsRedPacketCell.h"

@implementation YRAdsRedPacketCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
            [self setnewUpView];
            [self setNewFrame];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setnewUpView{
    
    [self addSubview:self.userImage];
    [self addSubview:self.userName];
    [self addSubview:self.time];
    [self addSubview:self.num];
//    [self addSubview:self.readCount];
    [self addSubview:self.redPackButton];
    [self addSubview:self.redPack];
    [self addSubview:self.titleLabel];
    [self addSubview:self.text];
    [self addSubview:self.adsImage];
}

- (UIImageView *)userImage{
    if (!_userImage) {
        _userImage = [[UIImageView alloc]init];
    }
    return _userImage;
}
- (UILabel *)userName{
    if (!_userName) {
        _userName = [[UILabel alloc]init];
        _userName.font = [UIFont titleFont15];
        _userName.adjustsFontSizeToFitWidth =YES;
        _userName.textColor = RGB_COLOR(51, 51, 51);
    }
    return _userName;
}
- (UILabel *)time{
    if (!_time) {
        _time = [[UILabel alloc]init];
        _time.adjustsFontSizeToFitWidth=YES;
        _time.font = [UIFont titleFont13];
        _time.textColor = RGB_COLOR(153, 153, 153);
    }
    return _time;
}
- (UILabel *)num{
    if (!_num) {
        _num = [[UILabel alloc]init];
        _num.textColor = RGB_COLOR(153, 153, 153);
        _num.font = [UIFont titleFont13];
        
    }
    return _num;
}
//- (UILabel *)readCount{
//    if (!_readCount) {
//        _readCount = [[UILabel alloc]init];
//        _readCount.font = [UIFont titleFont13];
//        _readCount.adjustsFontSizeToFitWidth = YES;
//        _readCount.textColor = RGB_COLOR(153,153,153);
//    }
//    return _readCount;
//}
- (UIButton *)redPackButton{
    if (!_redPackButton) {
        _redPackButton = [[UIButton alloc]init];
        [_redPackButton addTarget:self action:@selector(redPackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redPackButton;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = RGB_COLOR(51, 51, 51);
        _titleLabel.font = [UIFont titleFont20];
//        _titleLabel.backgroundColor = [UIColor redColor];
    }
    return _titleLabel;
}
- (UILabel *)text{
    if (!_text) {
        _text = [[UILabel alloc]init];
        _text.font = [UIFont titleFont18];
        _text.textColor = RGB_COLOR(102, 102, 102);
//        _text.backgroundColor = [UIColor redColor];
    }
    return _text;
}
- (UIImageView *)mainImage{
    if (!_mainImage) {
        _mainImage = [[UIImageView alloc]init];
    }
    return _mainImage;
}
- (UIImageView *)playImage{
    if (!_playImage) {
        _playImage = [[UIImageView alloc]init];
        _playImage.image = [UIImage imageNamed:@"yr_show_video"];
    }
    return _playImage;
}
- (UIImageView *)adsImage{
    if (!_adsImage) {
        _adsImage = [[UIImageView alloc]init];
        _adsImage.image = [UIImage imageNamed:@"adsicon"];
    }
    return _adsImage;
}

- (void)setNewFrame{
    [self.userImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(5);
        make.left.mas_equalTo(self.mas_left).offset(5);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userImage.mas_top).offset(0);
        make.left.mas_equalTo(self.userImage.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userName.mas_bottom).offset(3);
        make.left.mas_equalTo(self.userImage.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(80, 14));
    }];
    [self.num mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.time.mas_top).offset(0);
        make.left.mas_equalTo(self.time.mas_right).offset(15);
        make.size.mas_equalTo(CGSizeMake(90, 14));
    }];
//    [self.readCount mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.num.mas_top).offset(0);
//        make.left.mas_equalTo(self.num.mas_right).offset(2);
//        make.size.mas_equalTo(CGSizeMake(20, 14));
//    }];
    [self.redPackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userImage.mas_top);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(56, 63));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userImage.mas_bottom).offset(10);
        make.left.mas_equalTo(self.userImage.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-10, 30));
    }];
//    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
//        make.left.mas_equalTo(self.titleLabel.mas_left).offset(0);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH -10, 70));
//    }];
    [self.adsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
        make.right.mas_equalTo(self.mas_right).offset(-5);
        make.size.mas_equalTo(CGSizeMake(24, 14));
    }];
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.titleLabel.mas_left).offset(0);
        make.bottom.mas_equalTo(self.adsImage.mas_top).offset(-5);
        make.width.mas_equalTo(SCREEN_WIDTH -10);
    }];
}

- (void)setRedModel:(YRRedAdsModel *)model{
    _redModel = model;
    [self.userImage setImageWithURL:[NSURL URLWithString:model.headImg] placeholder:[UIImage defaultHead]];
    [self.userImage addTapGesturesTarget:self selector:@selector(userImageClick)];
    [self.userName addTapGesturesTarget:self selector:@selector(userImageClick)];
    [self.userImage setCircleHeadWithPoint:CGPointMake(35, 35) radius:4];
    [self.redPackButton setImage:[UIImage imageNamed:@"yr_button_havered"] forState:UIControlStateNormal];
    [self.time setFont:[UIFont titleFont13]];
    self.time.textColor = RGB_COLOR(153, 153, 153);
    self.time.text = [NSString getDateStringWithTimestamp:model.upedTime];
    self.titleLabel.textColor = RGB_COLOR(51, 51, 51);
    self.titleLabel.text = model.title;
    self.titleLabel.font = [UIFont titleFont20];
    self.num.text = [NSString stringWithFormat:@"浏览次数 %@",model.readCount?model.readCount:@""];
//    [self.num setImage:[UIImage imageNamed:@"yr_see_nor"] forState:UIControlStateNormal];
//    self.num.titleLabel.font = [UIFont titleFont13];
//    self.readCount.text =[NSString stringWithFormat:@" %@",model.readCount?model.readCount:@""];
//    self.readCount.textColor = RGB_COLOR(153, 153, 153);
//    self.readCount.font = [UIFont titleFont13];
    self.text.numberOfLines = 3;
    self.text.textColor = RGB_COLOR(102, 102, 102);
    [self.text sizeToFit];
    [self.text setFont:[UIFont titleFont18]];
    self.text.textColor = RGB_COLOR(102, 102, 102);
    NSString * content = model.adsDesc;
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if ([model.adsDesc isEqualToString:@""]) {
        self.text.text = @"";
    }else{
        if (content.length>=60) {
            self.text.text = [NSString stringWithFormat:@"%@...",[content substringToIndex:59]];
        }
//        if (content.length<=20) {
//            self.text.text = [NSString stringWithFormat:@"%@\n\n",content];
//        }
        else{
            self.text.text = [NSString stringWithFormat:@"%@",content];
        }
    }
    self.userName.text = [NSString stringWithFormat:@"%@",model.nickName];
    self.userName.font = [UIFont titleFont15];
    self.userName.textColor = RGB_COLOR(51, 51, 51);
    [self.mainImage setImageWithURL:[NSURL URLWithString:model.smallPic] placeholder:[UIImage defaultImage]];
    
    [self.imageNum setTitle:[NSString stringWithFormat:@"%ld",model.picCount] forState:UIControlStateNormal];
    [self.imageNum setBackgroundImage:[UIImage imageNamed:@"yr_mark_angle"] forState:UIControlStateNormal];
    [self.imageNum setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (model.type == 0 ) {
        self.playImage.hidden = YES;
        
        self.imageNum.hidden = NO;
    }else{
        self.imageNum.hidden = YES;
        self.playImage.hidden = NO;
    }
    
    if (model.picCount == 0) {
        self.imageNum.hidden = YES;
    }
}
- (void)redPackButtonClick:(id)sender {
    if (self.delegate){
        [self.delegate redAdsTableViewCellDelegate:kRedBag redModel:self.redModel ];
    }
}
- (void)userImageClick{
    
    if (self.delegate){
        [self.delegate redAdsTableViewCellDelegate:kHeadImage redModel:self.redModel];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
