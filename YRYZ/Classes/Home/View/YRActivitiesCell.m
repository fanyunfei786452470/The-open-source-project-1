//
//  YRActivitiesCell.m
//  YRYZ
//
//  Created by Sean on 16/8/25.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRActivitiesCell.h"

@implementation YRActivitiesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}
- (void)configUI{

        UIImageView *userImage = [[UIImageView alloc]init];   // userImage.backgroundColor = [UIColor randomColor];
            UILabel *activitiesLabel = [[UILabel alloc]init];  activitiesLabel.backgroundColor = [UIColor themeColor];
            UILabel *title = [[UILabel alloc]init];           // title.backgroundColor = [UIColor randomColor];
            UILabel *timeLabel = [[UILabel alloc]init];       //  timeLabel.backgroundColor = [UIColor randomColor];
            UILabel *nameLabel = [[UILabel alloc]init];        // nameLabel.backgroundColor = [UIColor randomColor];
            UIImageView *myImage = [[UIImageView alloc]init];    //   myImage.backgroundColor = [UIColor randomColor];
            UIView *grayView = [[UIView alloc]init];           // grayView.backgroundColor = [UIColor randomColor];
            UILabel *subtitle = [[UILabel alloc]init];         // subtitle.backgroundColor = [UIColor randomColor];


            [self.contentView addSubview:userImage];
            activitiesLabel.text = @"活动";
            [self.contentView addSubview:activitiesLabel];
            [self.contentView addSubview:title];
            [self.contentView addSubview:timeLabel];
            [self.contentView addSubview:nameLabel];
            [self.contentView addSubview:myImage];
            [self.contentView addSubview:grayView];
            [self.contentView addSubview:subtitle];

        [userImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).mas_equalTo(10);
            make.left.equalTo(self.contentView.mas_left).mas_equalTo(5);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
    
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userImage.mas_right).mas_offset(10);
            make.top.equalTo(userImage.mas_top);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userImage.mas_right).mas_offset(5);
            make.top.equalTo(nameLabel.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(100, 20));
        }];
    
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userImage.mas_right).mas_offset(5);
            make.top.equalTo(userImage.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-5);
            make.height.mas_equalTo(30);
        }];
    
       [myImage mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(title.mas_bottom).mas_offset(8);
           make.left.equalTo(title.mas_left);
           make.size.mas_equalTo(CGSizeMake(50, 50));
       }];
    
       [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(myImage.mas_right).mas_offset(-1);
           make.right.equalTo(self.contentView.mas_right).mas_offset(-5);
           make.top.equalTo(myImage.mas_top);
           make.height.equalTo(myImage);
       }];

       [subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(myImage.mas_right).mas_offset(5);
           make.right.equalTo(grayView);
           make.top.equalTo(myImage.mas_top).mas_offset(1);
           make.bottom.equalTo(myImage.mas_bottom).mas_offset(1);
           
       }];

    [activitiesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userImage);
        make.top.equalTo(title.mas_top).mas_offset(-3);
        make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
  
    activitiesLabel.layer.cornerRadius = 10;
    activitiesLabel.clipsToBounds = YES;
    
    activitiesLabel.textAlignment = NSTextAlignmentCenter;
    activitiesLabel.textColor = [UIColor whiteColor];
    activitiesLabel.font = [UIFont boldSystemFontOfSize:13];
    
    userImage.image = [UIImage imageNamed:@"yr_user_defaut"];
    
    nameLabel.text = @"悠然一指小编";
    nameLabel.textColor = RGB_COLOR(72, 72, 72);
    nameLabel.font = [UIFont systemFontOfSize:13];
    
    
    
    timeLabel.text = @"06 - 24 17:20";
    timeLabel.textColor = RGB_COLOR(215, 215, 215);
    timeLabel.font = [UIFont systemFontOfSize:13];
    
    
    title.numberOfLines = 2;
    
    subtitle.numberOfLines = 2;
    
    myImage.image = [UIImage imageNamed:@"cLINSHI"];
    
    title.font = [UIFont systemFontOfSize:14];
    
    title.text = @"周五,中国将在人们对中国经济放缓和中国金融体系健康状态的担忧之中体系将康";
    
    subtitle.text = @"周五,中国将在人们对中国经济放缓和中国金融体系健康状态的担忧之中体系将康";
    subtitle.font = [UIFont systemFontOfSize:14];
    grayView.backgroundColor = RGB_COLOR(245, 245, 245);
    
    _time = timeLabel;
    _title = title;
    _subtitle = subtitle;
    _myImage = myImage;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
