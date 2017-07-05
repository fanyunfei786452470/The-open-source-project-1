//
//  YRListenAndSayCell.m
//  YRYZ
//
//  Created by 易超 on 16/8/4.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRListenAndSayCell.h"


@interface  YRListenAndSayCell()


@property(nonatomic ,strong)YRProductListModel   *productModel;
@property (weak, nonatomic) IBOutlet UIButton *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tranStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *IntroductionLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *tranNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *earningsLabel; //收益
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *awardButton;
@property (weak, nonatomic) IBOutlet UIButton *tranButton;

- (IBAction)headImageClick:(id)sender;
- (IBAction)userImageClick:(id)sender;

@end
@implementation YRListenAndSayCell



- (void)setProductModel:(YRProductListModel *)productModel{

    _productModel = productModel;
    
    [self.headImageView setImageWithURL:[NSURL URLWithString:productModel.headImg] forState:UIControlStateNormal placeholder:[UIImage defaultHead]];
    [self.nameLabel setTitle:productModel.desc forState:UIControlStateNormal];
    self.timeLabel.text = productModel.desc;
    self.contentLabel.text = productModel.desc;
    self.tranNumLabel.text = @"已转发";
    self.tranNumLabel.text = productModel.transferCount;
    self.earningsLabel.text = productModel.transferBonud;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)tranButtonClick:(id)sender {
    if (self.delegate){
        [self.delegate listenAndSayCellDelegate:kTran productModel:self.productModel];
    }
}

- (IBAction)awardButtonClick:(id)sender {
    if (self.delegate){
        [self.delegate listenAndSayCellDelegate:kReward productModel:self.productModel];
    }
}

- (IBAction)headImageClick:(id)sender {
    if (self.delegate){
        [self.delegate listenAndSayCellDelegate:kHeadImage productModel:self.productModel];
    }
}

- (IBAction)userImageClick:(id)sender {
    if (self.delegate){
        [self.delegate listenAndSayCellDelegate:kHeadImage productModel:self.productModel];
    }
}
@end
