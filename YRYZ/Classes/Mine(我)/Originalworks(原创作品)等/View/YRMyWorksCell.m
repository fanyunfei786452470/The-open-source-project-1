//
//  YRMyWorksCell.m
//  YRYZ
//
//  Created by 易超 on 16/7/19.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRMyWorksCell.h"

@implementation YRMyWorksCell

- (void)awakeFromNib {
    
    self.title.backgroundColor = RGB_COLOR(245, 245, 245);
    self.staueLabel.layer.cornerRadius = 8;
    self.staueLabel.clipsToBounds = YES;
    [super awakeFromNib];
    // Initialization code
}
- (void)setUIWithModle:(YRProductListModel *)model{
    
    NSString *type ;
    NSString *imageType ;
        NSString *placeImage;
    if (model.type == 1) {
        type = @"yr_msg_defaul";
        imageType = @"";
        self.title.text = model.desc;
          placeImage = @"yr_pic_default";
        
    }else if (model.type ==2){
        type = @"yr_mine_video_default";
         self.title.text = model.desc;
        imageType = @"yr_mine_video";
         placeImage = @"yr_video_default";
    }else if (model.type ==3){
        type = @"yr_mine_miuse_default";
        imageType = @"yr_mine_miuse";
          self.title.text = model.infoIntroduction;
          placeImage = @"yr_audio_default";
    }
    self.typeImage.image = [UIImage imageNamed:type];
    self.bigTypeImage.image = [UIImage imageNamed:imageType];
//    self.time.text = [NSString getDateStringWithTimestamp:model.createDate];
    self.time.text = [NSString getTimeFormatterWithString:model.createDate];
    [self.backImage setImageWithURL:[NSURL URLWithString:model.urlThumbnail] placeholder:[UIImage imageNamed:placeImage]];
    
    if (model.auditStatus==1||model.auditStatus==0) {
        self.staueLabel.text = @"审核中";
        self.downImage.hidden = YES;
          self.staueLabel.backgroundColor = RGB_COLOR(255, 96, 96);
    }else if (model.auditStatus==4){
        self.staueLabel.text = @"";
         self.staueLabel.backgroundColor = [UIColor whiteColor];
        self.downImage.hidden = NO;
    }else{
        self.staueLabel.text = @"";
        self.staueLabel.backgroundColor = [UIColor whiteColor];
        self.downImage.hidden = YES;
    }
    
    if (model.forwardStatus==1) {
        self.fowardImage.hidden = NO;
         self.staueLabel.text = @" ";
        self.staueLabel.backgroundColor = [UIColor whiteColor];
    }else{
        self.fowardImage.hidden = YES;
    }
    
    self.title.font = [UIFont titleFont17];
    self.time.font = [UIFont titleFont16];
    self.title.textColor = [UIColor wordColor];
    self.time.textColor = [UIColor grayColorTwo];
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
