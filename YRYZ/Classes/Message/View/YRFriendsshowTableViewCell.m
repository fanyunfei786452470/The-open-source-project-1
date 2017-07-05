//
//  YRFriendsshowTableViewCell.m
//  YRYZ
//
//  Created by Mrs_zhang on 16/7/14.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRFriendsshowTableViewCell.h"

@implementation YRFriendsshowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headerImg.layer.cornerRadius = 3.f;
    self.headerImg.clipsToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(YRFriendsModel *)model{
    NSDictionary *dataDic = model.dic;
    
    DLog(@"数据：%@",dataDic);
    
    NSString *context;
    if (dataDic[@"data"][@"context"] != nil && dataDic[@"data"][@"context"]) {
        context = dataDic[@"data"][@"context"];
    }else{
        context = @"";
    }
    NSString *time = dataDic[@"data"][@"sendTime"]?dataDic[@"data"][@"sendTime"]:@"";
    
    NSString *tampTime = [self timesTampWithTime:time];
    NSString *sendTime = [NSString getMsgTimeFormatterWithString:tampTime];
    NSString *name = dataDic[@"data"][@"name"]?dataDic[@"data"][@"name"]:@"";
    NSString *headImg = dataDic[@"data"][@"headImg"]?dataDic[@"data"][@"headImg"]:@"";
    [self.headerImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",headImg]] placeholder:[UIImage imageNamed:@"yr_user_defaut"]];
    self.nameLab.text = [NSString stringWithFormat:@"%@",name];
    self.contextLab.text = [NSString stringWithFormat:@"%@",context];
    self.contextLab.numberOfLines = 3;
    self.timeLab.text = [NSString stringWithFormat:@"%@",sendTime];

    NSInteger msgType = [dataDic[@"msgType"] integerValue];
    switch (msgType) {
        case 2001://好友发布晒一晒
        {
            self.typeImg.image = [UIImage imageNamed:@"yr_msg_sun"];
        }
            break;
        case 2002://好友转发作品
        {
            self.typeImg.image = [UIImage imageNamed:@"yr_msg_trans"];
        }
            break;
        case 2003://好友发布作品(文字)
        {
            self.typeImg.image = [UIImage imageNamed:@"yr_msg_defaul"];
        }
            break;
        case 2004://好友发布作品(声音)
        {
            self.typeImg.image = [UIImage imageNamed:@"yr_mine_miuse_default"];
        }
            break;
        case 2005://好友发布作品(视频)
        {
            self.typeImg.image = [UIImage imageNamed:@"yr_mine_video_default"];
        }
            break;
        default:
            break;
    }

}
@end
