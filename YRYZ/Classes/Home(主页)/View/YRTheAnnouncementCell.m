//
//  YRTheAnnouncementCell.m
//  YRYZ
//
//  Created by Sean on 16/8/25.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRTheAnnouncementCell.h"

@implementation YRTheAnnouncementCell

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
    
    UILabel *announcement = [[UILabel alloc]init];   announcement.backgroundColor = RGB_COLOR(254, 207, 48);
    UILabel *time = [[UILabel alloc]init];
    UILabel *title = [[UILabel alloc]init];
    
    [self.contentView addSubview:announcement];
    [self.contentView addSubview:title];
    [self.contentView addSubview:time];
    
    [announcement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).mas_offset(8);
        make.left.equalTo(self.contentView.mas_left).mas_offset(5);
         make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(announcement);
        make.left.equalTo(announcement.mas_right).mas_offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(time);
        make.right.equalTo(self.contentView.mas_right).mas_offset(-5);
        make.top.equalTo(time.mas_bottom).mas_offset(8);
    }];
    
    title.text = @"案说法都是粉色按官方公布非把他和温柔哥的法国";
    title.numberOfLines = 0;
    title.font = [UIFont systemFontOfSize:14];
    [title sizeToFit];
    
    title.textColor = RGB_COLOR(72, 72, 72);
    
    time.textColor = RGB_COLOR(215, 215, 215);
    time.font = [UIFont systemFontOfSize:14];
    
    _title = title;
    time.text = @"06 - 24 17:20";
    announcement.text = @"公告";
    announcement.textColor = [UIColor whiteColor];
    announcement.textAlignment = NSTextAlignmentCenter;
    announcement.font = [UIFont boldSystemFontOfSize:15];
    announcement.layer.cornerRadius = 5;
    announcement.clipsToBounds = YES;
    
}

- (void)setMyTitleName:(NSString*)name{
    self.title.text = name;
    [self.title sizeToFit];
    
}



- (CGSize)sizeThatFits:(CGSize)size {
  CGFloat totalHeight =  [self.title sizeThatFits:size].height;
    return CGSizeMake(size.width, totalHeight);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
