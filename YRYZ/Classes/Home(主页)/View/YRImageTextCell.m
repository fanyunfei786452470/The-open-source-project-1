//
//  YRImageTextCell.m
//  YRYZ
//
//  Created by 易超 on 16/7/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRImageTextCell.h"

@interface YRImageTextCell ()

@property (weak, nonatomic) IBOutlet UIImageView        *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel            *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel            *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel            *tranCountLabel;
@property (weak, nonatomic) IBOutlet UILabel            *lucreLabel;

@property (weak, nonatomic) IBOutlet UIImageView        *infoImageView;
@property (weak, nonatomic) IBOutlet UILabel            *infoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel            *infoSubTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton           *awardBtn;
@property (weak, nonatomic) IBOutlet UIButton           *tranBtn;
@property (weak, nonatomic) IBOutlet UIImageView *prouductRecommendImageView;
@property (weak, nonatomic) IBOutlet UIImageView *productTranSate;

@property(nonatomic ,strong)YRProductListModel          *productModel;
@property(nonatomic ,strong)YRCircleListModel           *circleModel;
@end

@implementation YRImageTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)setProductModel:(YRProductListModel *)productModel{
    self.iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userImageClick)];
    [self.iconImageView addGestureRecognizer:tap];
    
    _productModel = productModel;
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:productModel.headImg] placeholder:[UIImage defaultHead]];
    [self.infoImageView setImageWithURL:[NSURL URLWithString:productModel.urlThumbnail] placeholder:[UIImage imageNamed:@"yr_pic_default"]];
    self.nameLabel.text = @"??????";
    self.timeLabel.text = @"?????????";
    self.infoTitleLabel.text = productModel.desc;
     self.infoSubTitleLabel.text = productModel.desc;
//    self.tranNumLabel.text = @"已转发";
    self.tranCountLabel.text = productModel.transferCount;
    self.lucreLabel.text = productModel.transferBonud;
    
    
    if (productModel.recommand) {
        self.prouductRecommendImageView.hidden = NO;
    }else{
        self.prouductRecommendImageView.hidden = YES;
    }
    
    
    if (productModel.forwardStatus) {
        self.productTranSate.hidden = NO;
    }else{
        self.productTranSate.hidden = YES;
    }
}


- (void)setCircleModel:(YRCircleListModel *)circleModel{

    _circleModel = circleModel;
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:circleModel.headPath] placeholder:[UIImage defaultHead]];
    [self.infoImageView setImageWithURL:[NSURL URLWithString:circleModel.headPath] placeholder:[UIImage imageNamed:@"yr_pic_default"]];
    self.nameLabel.text = circleModel.custName ? circleModel.custName : circleModel.custNname;
    self.timeLabel.text = circleModel.timeDif;
    self.infoTitleLabel.text = circleModel.infoTitle;
    self.infoSubTitleLabel.text = circleModel.custSignature;
//    self.tranNumLabel.text = @"已转发";
    self.tranCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.circleModel.transferCount];
    self.lucreLabel.text = [NSString stringWithFormat:@"%ld",(long)self.circleModel.transferBonud];;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)userImageClick{
    if (self.delegate){
        [self.delegate imageTextCellDelegate:kHeadImage productModel:self.productModel];
    }
    if (self.circledelegate) {
        [self.circledelegate imageTextCellDelegate:kHeadImage circleModel:self.circleModel ];
    }
}
- (IBAction)redButtonClick:(id)sender {
    
    
    if (self.delegate){
        [self.delegate imageTextCellDelegate:kRedBag productModel:self.productModel];
    }
    if (self.circledelegate) {
        [self.circledelegate imageTextCellDelegate:kRedBag circleModel:self.circleModel ];
    }
    
}





/**
 *  @author yichao, 16-07-19 10:07:05
 *
 *  打赏
 *
 *  @param sender <#sender description#>
 */
- (IBAction)awardBtnClick:(UIButton *)sender {
    if (self.delegate){
        [self.delegate imageTextCellDelegate:kReward productModel:self.productModel];
    }
    if (self.circledelegate) {
        [self.circledelegate imageTextCellDelegate:kReward circleModel:self.circleModel ];
    }
}

/**
 *  @author yichao, 16-07-19 10:07:14
 *
 *  转发
 *
 *  @param sender <#sender description#>
 */
- (IBAction)tranBtnClick:(UIButton *)sender {
    if (self.delegate){
        [self.delegate imageTextCellDelegate:kTran productModel:self.productModel];
    }
    if (self.circledelegate) {
        [self.circledelegate imageTextCellDelegate:kTran circleModel:self.circleModel ];
    }
}


@end
