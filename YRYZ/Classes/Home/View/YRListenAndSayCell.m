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
@property (weak, nonatomic) IBOutlet UIButton   *headImageView;
@property (weak, nonatomic) IBOutlet UIButton   *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel    *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel    *IntroductionLabel;
@property (weak, nonatomic) IBOutlet UIButton   *playButton;
@property (weak, nonatomic) IBOutlet UILabel    *tranNumLabel;
@property (weak, nonatomic) IBOutlet UILabel    *earningsLabel; //收益
@property (weak, nonatomic) IBOutlet UILabel    *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton   *awardButton;


@property (weak, nonatomic) IBOutlet UIImageView *prouductRecommendImageView;
@property (weak, nonatomic) IBOutlet UIImageView *productTranSate;
@property (weak, nonatomic) IBOutlet UILabel *relaseTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *tranTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *earningTipLabel;

@end
@implementation YRListenAndSayCell



- (void)setProductModel:(YRProductListModel *)productModel{
    
    _productModel = productModel;
    
    
    self.playButton.userInteractionEnabled = NO;
    
    NSInteger time = productModel.infoTime/1000;
    [self.headImageView setImageWithURL:[NSURL URLWithString:productModel.headImg] forState:UIControlStateNormal placeholder:[UIImage defaultHead]];
 
    [self.headImageView.layer setMasksToBounds:YES];
    [self.headImageView.layer setCornerRadius:4.0];


    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 255, 255, 255, 1 });
    [self.headImageView.layer setBorderColor:colorref]; //边框颜色
    
    
    [self.nameLabel setTitle:productModel.nameNotes ? productModel.nameNotes : productModel.custNname  forState:UIControlStateNormal];
    [self.nameLabel addTapGesturesTarget:self selector:@selector(headImageClick)];
    self.timeLabel.text = [NSString stringWithFormat:@"%ld\"",time];
    self.contentLabel.text = productModel.infoIntroduction;
    self.IntroductionLabel.text = productModel.custDesc;
    self.tranNumLabel.text = productModel.transferCount;
    self.earningsLabel.text = productModel.transferBonud;
    self.earningsLabel.text = [NSString stringWithFormat:@"%.2f",[productModel.transferBonud  floatValue]* 0.01];
    self.relaseTimeLabel.text = [NSString getTimeFormatterWithString:productModel.createDate];
    [self.tranNumLabel addTapGesturesTarget:self selector:@selector(tranNumLabelClick)];
    [self.earningsLabel addTapGesturesTarget:self selector:@selector(earningsLabelClick)];
    
    [self.tranTipLabel addTapGesturesTarget:self selector:@selector(tranNumLabelClick)];
    [self.earningTipLabel addTapGesturesTarget:self selector:@selector(earningsLabelClick)];
    if (productModel.recommand) {
        self.prouductRecommendImageView.hidden = NO;
    }else{
        self.prouductRecommendImageView.hidden = YES;
    }
    
    if (productModel.forwardStatus) {
 
        self.productTranSate.hidden = NO;
        [self.tranButton setTitle:@" 已转发" forState:UIControlStateNormal];
        [self.tranButton setTitleColor:RGB_COLOR(153, 153, 153) forState:UIControlStateNormal];
        [self.tranButton setImage:[UIImage imageNamed:@"yr_button_traned"] forState:UIControlStateNormal];
        
    }else{
        self.productTranSate.hidden = YES;
        [self.tranButton setTitle:@" 转发得奖励" forState:UIControlStateNormal];
        [self.tranButton setTitleColor:RGB_COLOR(102, 102, 102) forState:UIControlStateNormal];
        [self.tranButton setImage:[UIImage imageNamed:@"yr_button_tran"] forState:UIControlStateNormal];
    }

    
    
//
    
//    if([productModel.custId isEqualToString:[YRUserInfoManager manager].currentUser.custId] && !productModel.forwardStatus ){
//        self.productTranSate.hidden = YES;
//        [self.tranButton setTitle:@" 邀请转发" forState:UIControlStateNormal];
//    } else if (productModel.forwardStatus) {
//        self.productTranSate.hidden = NO;
//        [self.tranButton setTitle:@" 已转发" forState:UIControlStateNormal];
//    }else{
//        self.productTranSate.hidden = YES;
//        [self.tranButton setTitle:@" 转发得奖励" forState:UIControlStateNormal];
//    }
    
    NSString  *imageStr = @"";
    NSString  *playImageStr = @"";
    UIColor  *coror = [UIColor whiteColor];
    if (productModel.readStatus) {
        imageStr = @"yr_button_playaudionBg";
        playImageStr = @"yr_circle_audioRePlay_3";
        coror = [UIColor themeColor];
    }else{
        imageStr = @"yr_button_audionBg";
        playImageStr = @"yr_circle_audioplay_3";
        coror = [UIColor whiteColor];
    }
    

    if (productModel.readStatus) {
        [self.playButton setImage:[UIImage imageNamed:@"yr_circle_audioRePlay_3"] forState:UIControlStateNormal];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"yr_button_playaudionBg"] forState:UIControlStateNormal];
        [self.playButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        self.timeLabel.textColor = [UIColor themeColor];
    }else{
        [self.playButton setImage:[UIImage imageNamed:@"yr_circle_audioplay_3"] forState:UIControlStateNormal];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"yr_button_audionBg"] forState:UIControlStateNormal];
        [self.playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.timeLabel.textColor = [UIColor whiteColor];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameLabel.titleLabel.font = [UIFont titleFont15];
}

- (IBAction)tranButtonClick:(UIButton*)sender {

    //取消此方法
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(doSth:) object:sender];
    [self performSelector:@selector(doSth:) withObject:sender afterDelay:0.5f];
    
}

- (void)doSth:(UIButton*)sender{
    if (self.delegate){
        
        if ([sender.titleLabel.text isEqualToString:@" 邀请转发"]) {
            [self.delegate listenAndSayCellDelegate:kInvitationForwarding productModel:self.productModel];
        }else  if ([sender.titleLabel.text isEqualToString:@" 已转发"]) {
            
        }else{
            [self.delegate listenAndSayCellDelegate:kTran productModel:self.productModel];
        }
    }

}

- (IBAction)awardButtonClick:(id)sender {
    if (self.delegate){
        [self.delegate listenAndSayCellDelegate:kReward productModel:self.productModel];
    }
}

- (IBAction)headImageClick{
    if (self.delegate){
        [self.delegate listenAndSayCellDelegate:kHeadImage productModel:self.productModel];
    }
}
- (IBAction)audioPlayButton:(id)sender {
    if (self.delegate){
        [self.delegate listenAndSayCellDelegate:kAudioPlay productModel:self.productModel];
    }
}


- (void)tranNumLabelClick{
    if (self.delegate){
        [self.delegate listenAndSayCellDelegate:kIsforwarded productModel:self.productModel];
    }
    
}
- (void)earningsLabelClick{
    if (self.delegate){
        [self.delegate listenAndSayCellDelegate:kEarningsRule productModel:self.productModel];
    }
    
}

@end
