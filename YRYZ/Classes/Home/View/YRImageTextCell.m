//
//  YRImageTextCell.m
//  YRYZ
//
//  Created by 易超 on 16/7/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRImageTextCell.h"

@interface YRImageTextCell ()


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ImageHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ImageWidth;
@property(nonatomic ,strong)YRProductListModel          *productModel;
@property(nonatomic ,strong)YRCircleListModel           *circleModel;


@end

@implementation YRImageTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.font = [UIFont titleFont15];
}
- (void)setProductModel:(YRProductListModel *)productModel{
    self.iconImageView.userInteractionEnabled = YES;
    _productModel = productModel;
    [self.iconImageView addTapGesturesTarget:self selector:@selector(userImageClick)];
    [self.iconImageView setImageWithURL:[NSURL URLWithString:productModel.headImg] placeholder:[UIImage defaultHead]];
    [self.infoImageView setImageWithURL:[NSURL URLWithString:productModel.urlThumbnail] placeholder:[UIImage imageNamed:@"yr_pic_default"]];
    
    self.nameLabel.text = productModel.custNname ? productModel.custNname : @"";
    self.timeLabel.text = [NSString getTimeFormatterWithString:productModel.createDate];
    [self.nameLabel addTapGesturesTarget:self selector:@selector(userImageClick)];
    self.infoTitleLabel.text = productModel.desc;
    self.tranCountLabel.text = productModel.transferCount;
    self.lucreLabel.text = [NSString stringWithFormat:@"%.2f",[productModel.transferBonud floatValue]*0.01];
    
    
    [self.tranCountLabel addTapGesturesTarget:self selector:@selector(tranNumLabelClick)];
    [self.lucreLabel addTapGesturesTarget:self selector:@selector(earningsLabelClick)];
    
    [self.tranTipLabel addTapGesturesTarget:self selector:@selector(tranNumLabelClick)];
    [self.earningTipLabel addTapGesturesTarget:self selector:@selector(earningsLabelClick)];
    
    
    
    if (productModel.recommand) {
        self.prouductRecommendImageView.hidden = NO;
    }else{
        self.prouductRecommendImageView.hidden = YES;
    }
    
    if (productModel.forwardStatus) {
        self.productTranSate.hidden = NO;
        [self.tranBtn setTitle:@" 已转发" forState:UIControlStateNormal];
        [self.tranBtn setTitleColor:RGB_COLOR(153, 153, 153) forState:UIControlStateNormal];
    }else{
        self.productTranSate.hidden = YES;
        [self.tranBtn setTitle:@" 转发得奖励" forState:UIControlStateNormal];
        [self.tranBtn setTitleColor:RGB_COLOR(102, 102, 102) forState:UIControlStateNormal];
    }
    
}


- (void)setCircleModel:(YRCircleListModel *)circleModel   indexPosition:(NSInteger)indexPosition{
    
    _circleModel = circleModel;
    _indexPosition = indexPosition;
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:circleModel.headPath] placeholder:[UIImage defaultHead]];
    
    //     1-图文 2-视频 3-音频
    NSString  *defaultImageName = @"yr_pic_default";
    switch (circleModel.infoType) {
        case 1:
            defaultImageName = @"yr_pic_default";
            self.videoBgImage.hidden = YES;
            self.infoTitleLabel.text = circleModel.infoTitle;
            break;
        case 2:
            defaultImageName = @"yr_video_default";
            self.videoBgImage.hidden = NO;
            self.infoTitleLabel.text = circleModel.infoTitle;
            break;
        case 3:
            defaultImageName = @"yr_audio_default";
            self.videoBgImage.hidden = YES;
            self.infoTitleLabel.text = circleModel.infoIntroduction;
            break;
        default:
            break;
    }
    [self.iconImageView addTapGesturesTarget:self selector:@selector(userImageClick)];
    [self.infoImageView setImageWithURL:[NSURL URLWithString:circleModel.infoThumbnail] placeholder:[UIImage imageNamed:defaultImageName]];
    self.nameLabel.text = circleModel.nameNotes ? circleModel.nameNotes :circleModel.custNname ;
    [self.nameLabel addTapGesturesTarget:self selector:@selector(userImageClick)];
    self.timeLabel.text = [NSString getTimeFormatterWithString:circleModel.createDate];

    self.tranCountLabel.text = [NSString stringWithFormat:@"%ld",(long)self.circleModel.transferCount];
    self.lucreLabel.text = [NSString stringWithFormat:@"%.2f",(float)self.circleModel.transferBonud * 0.01];;
    
    
    
    [self.tranCountLabel addTapGesturesTarget:self selector:@selector(tranNumLabelClick)];
    [self.lucreLabel addTapGesturesTarget:self selector:@selector(earningsLabelClick)];
    
    [self.tranTipLabel addTapGesturesTarget:self selector:@selector(tranNumLabelClick)];
    [self.earningTipLabel addTapGesturesTarget:self selector:@selector(earningsLabelClick)];
    
    
    self.prouductRecommendImageView.hidden = YES;
    
    
    
    if([circleModel.custId isEqualToString:[YRUserInfoManager manager].currentUser.custId] && !circleModel.forwardStatus ){
        self.productTranSate.hidden = YES;
        [self.tranBtn setTitle:@" 邀请转发" forState:UIControlStateNormal];
        
    }else if (circleModel.forwardStatus) {
        self.productTranSate.hidden = NO;
        [self.tranBtn setTitle:@" 已转发" forState:UIControlStateNormal];
        
    }else{
        self.productTranSate.hidden = YES;
        [self.tranBtn setTitle:@" 转发得奖励" forState:UIControlStateNormal];
    }
    
    
    
    if (circleModel.redpacketId) {
        self.redButton.hidden = NO;
    }else{
        self.redButton.hidden = YES;
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (void)userImageClick{
    if (self.delegate){
        [self.delegate imageTextCellDelegate:kHeadImage productModel:self.productModel];
    }
    if (self.circledelegate) {
        [self.circledelegate imageTextCellDelegate:kHeadImage circleModel:self.circleModel indexPosition:0];
    }
}
- (IBAction)redButtonClick:(id)sender {
    
    
    if (self.delegate){
        [self.delegate imageTextCellDelegate:kRedBag productModel:self.productModel];
    }
    if (self.circledelegate) {
        [self.circledelegate imageTextCellDelegate:kRedBag circleModel:self.circleModel indexPosition:0];
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
        [self.circledelegate imageTextCellDelegate:kReward circleModel:self.circleModel indexPosition:0];
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
    
    //取消此方法
//    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(doSth:) object:sender];
//    [self performSelector:@selector(doSth:) withObject:sender afterDelay:0.5f];
    [self doSth:sender];
}

- (void)doSth:(UIButton*)sender{
    
    
    if (self.delegate){
        
        if ([sender.titleLabel.text isEqualToString:@" 邀请转发"]) {
            [self.delegate imageTextCellDelegate:kInvitationForwarding productModel:self.productModel];
        }else  if ([sender.titleLabel.text isEqualToString:@" 已转发"]) {
            
        }else{
            [self.delegate imageTextCellDelegate:kTran productModel:self.productModel];
        }
        
    }
    if (self.circledelegate) {
        
        if ([sender.titleLabel.text isEqualToString:@" 邀请转发"]) {
            [self.circledelegate imageTextCellDelegate:kInvitationForwarding circleModel:self.circleModel indexPosition:0];
        }else  if ([sender.titleLabel.text isEqualToString:@" 已转发"]) {
            
        }else{
            [self.circledelegate imageTextCellDelegate:kTran circleModel:self.circleModel indexPosition:self.indexPosition];
        }
    }
    
    
}


- (void)tranNumLabelClick{
    if (self.delegate){
        [self.delegate imageTextCellDelegate:kEarningsRule productModel:self.productModel];
    }
    
    if (self.circledelegate) {
        [self.circledelegate imageTextCellDelegate:kEarningsRule circleModel:self.circleModel indexPosition:0];
    }
    
}
- (void)earningsLabelClick{
    if (self.delegate){
        [self.delegate imageTextCellDelegate:kEarningsRule productModel:self.productModel];
    }
    
    if (self.circledelegate) {
        [self.circledelegate imageTextCellDelegate:kEarningsRule circleModel:self.circleModel indexPosition:0];
    }
    
}


@end
