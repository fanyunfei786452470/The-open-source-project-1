//
//  YRCollectCell.m
//  YRYZ
//
//  Created by 易超 on 16/7/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRCollectCell.h"
#import "BaseViewController.h"
@interface YRCollectCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *infoHeadImageView;
@property (weak, nonatomic) IBOutlet UILabel *infoTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bigType;

@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,weak) YRProductListModel *model;

@end

@implementation YRCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconImageView.layer.cornerRadius = 4;
    self.iconImageView.layer.masksToBounds = YES;
    self.collectBtn.selected = NO;
    self.infoHeadImageView.layer.cornerRadius = 4;
    self.infoHeadImageView.layer.masksToBounds = YES;
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
}

- (IBAction)cancelCollectBtnClick:(UIButton *)sender {
    if (self.cancelCollectBtnBlock) {
        self.cancelCollectBtnBlock(sender);
    }
}
- (void)setUIWithModel:(YRProductListModel *)model{
    NSString *name;
    self.model = model;
    if ([model.sysType integerValue]==2) {
        name = [NSString stringWithFormat:@"%@  转发了",model.nameNotes?model.nameNotes:model.custNname];
    }else{
        name = model.nameNotes?model.nameNotes:model.custNname;
    }
    self.nameLabel.text = name;
    self.collectBtn.selected =NO;
    if (model.infoType==kInfoTypeVoice) {
        self.infoTitleLabel.text = model.infoIntroduction;
    }else{
        self.infoTitleLabel.text = model.infoTitle;
    }
    
    NSString *type ;
    NSString *imageType ;
    NSString *placeImage;
    if (model.infoType == 1) {
        type = @"yr_msg_defaul";
        imageType = @"";
        self.bigType.alpha = 0;
        self.infoTitleLabel.text = model.infoTitle;
        placeImage = @"yr_pic_default";
    }else if (model.infoType ==2){
        type = @"yr_mine_video_default";
        imageType = @"yr_mine_video";
        self.bigType.alpha = 1;
        self.infoTitleLabel.text = model.infoTitle;
        placeImage = @"yr_video_default";
    }else{
        type = @"yr_mine_miuse_default";
        //        imageType = @"yr_mine_miuse";
        self.infoTitleLabel.text = model.infoIntroduction;
        self.bigType.alpha = 1;
        placeImage = @"yr_audio_default";
    }
    
    self.bigType.image = [UIImage imageNamed:imageType];
    if (model.auditStatus==4) {
        self.downImage.hidden = NO;
    }else{
        self.downImage.hidden = YES;
    }
    
    
    [self.iconImageView addGestureRecognizer:self.tap];
    [self.nameLabel addTapGesturesTarget:self selector:@selector(tapClick:)];
    self.iconImageView.userInteractionEnabled = YES;
    self.nameLabel.userInteractionEnabled = YES;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:model.custImg] placeholder:[UIImage defaultHead]];
    [self.infoHeadImageView setImageWithURL:[NSURL URLWithString:model.infoThumbnail] placeholder:[UIImage imageNamed:placeImage]];
    NSString *time = [NSString getTimeFormatterWithString:model.createDate];
    self.timeLabel.text = time;
    
    
    self.nameLabel.font = [UIFont titleFont15];
    self.nameLabel.textColor = [UIColor wordColor];
    
    self.infoTitleLabel.font = [UIFont titleFont17];
    self.infoTitleLabel.textColor = [UIColor wordColor];
    
    self.timeLabel.font = [UIFont titleFont14];
    self.timeLabel.textColor = [UIColor grayColorTwo];
    
    
}
- (void)tapClick:(UITapGestureRecognizer *)tap{
//    BaseViewController *appRootVC = (BaseViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    BaseViewController *appRootVC = (BaseViewController *)[BaseViewController getCurrentVC];
    [appRootVC pushUserInfoViewController:self.model.custId withIsFriend:NO];
}





@end
