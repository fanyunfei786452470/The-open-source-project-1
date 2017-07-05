//
//  YRRedAdsTableViewCell.m
//  YRYZ
//
//  Created by Sean on 16/8/11.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedAdsTableViewCell.h"

@implementation YRRedAdsTableViewCell
//- (instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [ self setupView];
//    }
//    return self;
//}
//- (void)setupView{
//    _playImage = [[UIImageView alloc]init];
//    _playImage.image = [UIImage imageNamed:@""];
//    _playImage.backgroundColor = [UIColor redColor];
//    [_playImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.mas_bottom).offset(-44);
//        make.left.mas_equalTo(self.mas_left).offset((SCREEN_WIDTH-50)/2);
//        make.size.mas_equalTo(CGSizeMake(50, 44));
//    }];
//    [self.contentView addSubview:_playImage];
//
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.backgroundColor = [UIColor randomColor];
    self.time.textColor = RGB_COLOR(153, 153, 153);
    
    //[self.num setTitleColor:RGB_COLOR(153, 153, 153) forState:UIControlStateNormal];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _playImage = [[UIImageView alloc]init];
    [self.mainImage addSubview:_playImage];
    _mainImage.contentMode = UIViewContentModeScaleAspectFill;
    _mainImage.clipsToBounds = YES;
    _mainImage.backgroundColor = RGB_COLOR(245, 245, 245);
    _playImage.image = [UIImage imageNamed:@"yr_show_video"];
    [_playImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset((30-220)/2);
        make.left.mas_equalTo(self).offset((SCREEN_WIDTH - 60)/2);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];
    UIImageView * adsImage = [[UIImageView alloc]init];
    [self.contentView addSubview:adsImage];
    adsImage.image = [UIImage imageNamed:@"adsicon"];
    [adsImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self).offset(-5);
        make.left.mas_equalTo(self).offset((SCREEN_WIDTH -28));
        make.size.mas_equalTo(CGSizeMake(24, 14));
    }];
}

- (void)setPlaceholderhidden:(NSInteger)Placeholderhidden{
    if (Placeholderhidden == 0) {
        
    }
}

- (void)setRedModel:(YRRedAdsModel *)model{
    _redModel = model;
    [self.userImage setImageWithURL:[NSURL URLWithString:model.headImg] placeholder:[UIImage defaultHead]];
    [self.userImage addTapGesturesTarget:self selector:@selector(userImageClick)];
    [self.userName addTapGesturesTarget:self selector:@selector(userImageClick)];
    
    [self.userImage setCircleHeadWithPoint:CGPointMake(35, 35) radius:4];
    self.redPack.image = [UIImage imageNamed:@"yr_red_pack"];
    [self.time setFont:[UIFont titleFont13]];
    self.time.adjustsFontSizeToFitWidth =YES;
    self.time.text = [NSString getDateStringWithTimestamp:model.upedTime];
    self.time.textColor = RGB_COLOR(153, 153, 153);
    self.titleLabel.textColor = RGB_COLOR(51, 51, 51);
    self.titleLabel.text = model.title;
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
//    [self.num setImage:[UIImage imageNamed:@"yr_see_nor"] forState:UIControlStateNormal];
//    [self.num setTitle:[NSString stringWithFormat:@" %@",model.readCount?model.readCount:@""] forState:UIControlStateNormal];
//    self.num.titleLabel.font = [UIFont titleFont13];
//    self.num.titleLabel.textColor = RGB_COLOR(153, 153, 153);
//    self.num.adjustsImageWhenDisabled = YES;
    self.browseLabel.textColor = RGB_COLOR(153, 153, 153);
    self.browseLabel.font = [UIFont titleFont13];
    self.browseLabel.textAlignment = NSTextAlignmentLeft;
    self.browseLabel.text = [NSString stringWithFormat:@"浏览次数 %@",model.readCount?model.readCount:@""];
    self.browseLabel.adjustsFontSizeToFitWidth = YES;
    self.text.numberOfLines = 3;
    [self.text setFont:[UIFont titleFont17]];
    self.text.textColor = RGB_COLOR(102, 102, 102);
    [self.text sizeToFit];
    NSString * content = model.adsDesc;
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if ([model.adsDesc isEqualToString:@""]) {
        self.text.text = @"";
    }else{
        if (content.length>=60) {
            self.text.text = [NSString stringWithFormat:@"%@...",[content substringToIndex:59]];
        }else{
            self.text.text = [NSString stringWithFormat:@"%@",content];
        }
    }
    self.userName.adjustsFontSizeToFitWidth =YES;
    self.userName.textColor = RGB_COLOR(51, 51, 51);
    [self.userName setFont:[UIFont titleFont15]];
    self.userName.text = [NSString stringWithFormat:@"%@",model.nickName];
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
    
//    if (model.picCount == 0) {
//        
//        self.imageNum.hidden = YES;
//        
//        self.mainImageH.constant = 0;
//        
//    }

//    if ([model.smallPic isEqualToString:@""]&&model.type ==0) {
//        [self removeConstraint:_mainImageHeight];
//        [self.mainImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(1);
//        }];
    
//    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)redPackButtonClick:(id)sender {
    if (self.delegate){
        [self.delegate redAdsTableViewCellDelegate:kRedBag redModel:self.redModel ];
    }
}

- (void)userImageClick{

    if (self.delegate){
        [self.delegate redAdsTableViewCellDelegate:kHeadImage redModel:self.redModel];
    }

}
@end
