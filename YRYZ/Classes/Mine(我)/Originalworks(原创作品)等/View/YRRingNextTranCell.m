//
//  YRRingNextTranCell.m
//  YRYZ
//
//  Created by Sean on 16/8/17.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRingNextTranCell.h"


@interface YRRingNextTranCell ()



@end

@implementation YRRingNextTranCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.shareBtn.backgroundColor = [UIColor themeColor];
    [self.shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shareBtn.layer.cornerRadius = 5;
    self.shareBtn.clipsToBounds = YES;
    
    
   
    [self.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)setUIWithModel:(YRCircleListModel *)model{
    NSString *type ;
    NSString *imageType ;
     NSString *placeImage;
    if (model.infoType == 1) {
        type = @"yr_msg_defaul";
        imageType = @"";
        self.bigType.alpha = 0;
         self.title.text = model.infoTitle;
          placeImage = @"yr_pic_default";
    }else if (model.infoType ==2){
        type = @"yr_mine_video_default";
        imageType = @"yr_mine_video";
        self.bigType.alpha = 1;
         self.title.text = model.infoTitle;
         placeImage = @"yr_video_default";
    }else{
        type = @"yr_mine_miuse_default";
//        imageType = @"yr_mine_miuse";
        self.title.text = model.infoIntroduction;
        self.bigType.alpha = 1;
          placeImage = @"yr_audio_default";
    }
    self.bigType.image = [UIImage imageNamed:imageType];
    self.imagType.image = [UIImage imageNamed:type];

    self.time.text = [NSString getTimeFormatterWithString:model.createDate];
    
    NSMutableAttributedString *forwardedText = [[NSMutableAttributedString alloc]initWithString:@"被转发" attributes:@{NSForegroundColorAttributeName:RGB_COLOR(121, 121, 121)}];
    
    
    NSAttributedString *text = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld",model.transferCount] attributes:@{NSForegroundColorAttributeName:[UIColor themeColor]}];
    
    [forwardedText appendAttributedString:text];
    
    self.forwarded.attributedText = forwardedText;
    
    NSMutableAttributedString *moneyText = [[NSMutableAttributedString alloc]initWithString:@"奖励" attributes:@{NSForegroundColorAttributeName:RGB_COLOR(121, 121, 121)}];
    
    
    NSAttributedString *text2 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",model.transferBonud*0.01]  attributes:@{NSForegroundColorAttributeName:[UIColor themeColor]}];
    
    [moneyText appendAttributedString:text2];
    
    self.money.attributedText = moneyText;
    
    [self.myImge setImageWithURL:[NSURL URLWithString:model.infoThumbnail] placeholder:[UIImage imageNamed:placeImage]];

    if (model.auditStatus==4) {
        self.downImage.hidden = NO;
    }else{
        self.downImage.hidden = YES;
    }
    
    self.title.font = [UIFont titleFont17];
  
    self.money.font = [UIFont titleFont15];
    self.forwarded.font = [UIFont titleFont15];
    
}
- (void)shareBtnClick:(UIButton *)sender{
    
    if (self.chooseBtn) {
        self.chooseBtn(YES);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end








