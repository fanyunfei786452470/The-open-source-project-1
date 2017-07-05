//
//  YRPlainTextCell.m
//  YRYZ
//
//  Created by 21.5 on 16/9/29.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRPlainTextCell.h"

@interface YRPlainTextCell()
@property (strong, nonatomic)  UIImageView        *iconImageView;
@property (strong, nonatomic)  UILabel            *nameLabel;
@property (strong, nonatomic)  UILabel            *timeLabel;

@property (strong, nonatomic)  UILabel            *tranCountLabel;
@property (strong, nonatomic)  UILabel            *lucreLabel;

@property (strong, nonatomic)  UIImageView        *infoImageView;
@property (strong, nonatomic)  UILabel            *infoTitleLabel;
@property (strong, nonatomic)  UILabel            *infoSubTitleLabel;

@property (strong, nonatomic)  UIButton           *awardBtn;

@property (strong, nonatomic)  UIImageView        *prouductRecommendImageView;
@property (strong, nonatomic)  UIImageView        *productTranSate;

@property (strong,nonatomic)   UILabel            * line1;
@property (strong,nonatomic)   UILabel            * line2;
@property (strong,nonatomic)   UILabel            * line3;
@property (strong,nonatomic)   UILabel            * line4;

@property (strong, nonatomic)  UILabel            *tranTipLabel;
@property (strong, nonatomic)  UILabel            *earningTipLabel;


@property (strong,nonatomic)   UIView             *bgView;

@property(nonatomic ,strong)YRProductListModel          *productModel;
@property(nonatomic ,strong)YRCircleListModel           *circleModel;

@end
@implementation YRPlainTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
        [self setFrame];
    }
    return self;
}
//添加控件 
- (void)setupView{
    
    [self.contentView  addSubview:self.line1];
    [self.contentView  addSubview:self.iconImageView];
    [self.contentView  addSubview:self.nameLabel];
    [self.contentView  addSubview:self.timeLabel];
    [self.contentView  addSubview:self.productTranSate];
    [self.contentView  addSubview:self.redButton];
    [self.contentView  addSubview:self.line2];
    [self.contentView  addSubview:self.tranTipLabel];
    [self.contentView  addSubview:self.tranCountLabel];
    [self.contentView  addSubview:self.earningTipLabel];
    [self.contentView  addSubview:self.lucreLabel];
    [self.contentView  addSubview:self.prouductRecommendImageView];
    [self.contentView  addSubview:self.bgView];
    [self.bgView       addSubview:self.infoImageView];
    [self.bgView       addSubview:self.infoTitleLabel];
    [self.bgView       addSubview:self.infoSubTitleLabel];
    [self.contentView  addSubview:self.line3];
    [self.contentView  addSubview:self.awardBtn];
    [self.contentView  addSubview:self.line4];
    [self.contentView  addSubview:self.tranBtn];
    [self.tranCountLabel addTapGesturesTarget:self selector:@selector(tranNumLabelClick)];
    [self.lucreLabel addTapGesturesTarget:self selector:@selector(earningsLabelClick)];
    
    [self.tranTipLabel addTapGesturesTarget:self selector:@selector(tranNumLabelClick)];
    [self.earningTipLabel addTapGesturesTarget:self selector:@selector(earningsLabelClick)];
}

- (void)setType:(NSInteger)type{
}
- (UILabel *)line1{
    if (!_line1) {
        _line1 = [[UILabel alloc]init];
        _line1.backgroundColor = RGB_COLOR(245, 245, 245);
    }
    return _line1;
}
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}
- (UIImageView *)prouductRecommendImageView{
    if (!_prouductRecommendImageView) {
        _prouductRecommendImageView = [[UIImageView alloc]init];
        _prouductRecommendImageView.image = [UIImage imageNamed:@"yr_prouduct_ recommend"];
    }
    return _prouductRecommendImageView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = RGB_COLOR(51, 51, 51);
        _nameLabel.font = [UIFont titleFont15];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [_nameLabel setFont:[UIFont titleFont15]];
    }
    return _nameLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        [_timeLabel setFont:[UIFont titleFont13]];
        _timeLabel.textColor = RGB_COLOR(153, 153, 153);
    }
    return _timeLabel;
}
- (UIImageView *)productTranSate{
    if (!_productTranSate) {
        _productTranSate = [[UIImageView alloc]init];
        [_productTranSate setImage:[UIImage imageNamed:@"yr_prouduct_tran"]];
    }
    return _productTranSate;
}
- (UIButton *)redButton{
    if (!_redButton) {
        _redButton = [[UIButton alloc]init];
        [_redButton setBackgroundImage:[UIImage imageNamed:@"yr_button_havered"] forState:UIControlStateNormal];
        [_redButton addTarget:self action:@selector(redButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redButton;
}
- (UILabel *)line2{
    if (!_line2) {
        _line2 = [[UILabel alloc]init];
        _line2.backgroundColor = RGB_COLOR(229, 229, 229);
    }
    return _line2;
}
- (UILabel *)tranTipLabel{
    if (!_tranTipLabel) {
        _tranTipLabel = [[UILabel alloc]init];
        _tranTipLabel.text = @"被转发";
        [_tranTipLabel setFont:[UIFont titleFont12]];
        _tranTipLabel.adjustsFontSizeToFitWidth = YES;
        _tranTipLabel.textAlignment = NSTextAlignmentRight;
        _tranTipLabel.textColor = RGB_COLOR(51, 51, 51);
    }
    return _tranTipLabel;
}
- (UILabel *)tranCountLabel{
    if (!_tranCountLabel) {
        _tranCountLabel = [[UILabel alloc]init];
        [_tranCountLabel setFont:[UIFont titleFont12]];
        _tranCountLabel.adjustsFontSizeToFitWidth = YES;
        _tranCountLabel.textAlignment = NSTextAlignmentLeft;
        _tranCountLabel.textColor = [UIColor themeColor];
    }
    return _tranCountLabel;
}
- (UILabel *)earningTipLabel{
    if (!_earningTipLabel) {
        _earningTipLabel = [[UILabel alloc]init];
        _earningTipLabel.text = @"收益";
        [_earningTipLabel setFont:[UIFont titleFont12]];
        _earningTipLabel.adjustsFontSizeToFitWidth = YES;
        _earningTipLabel.textAlignment = NSTextAlignmentRight;
        _earningTipLabel.textColor = RGB_COLOR(51, 51, 51);
    }
    return _earningTipLabel;
}
- (UILabel *)lucreLabel{
    if (!_lucreLabel) {
        _lucreLabel = [[UILabel alloc]init];
        _lucreLabel.adjustsFontSizeToFitWidth = YES;
        [_lucreLabel setFont:[UIFont titleFont12]];
        _lucreLabel.textAlignment = NSTextAlignmentLeft;
        _lucreLabel.textColor = [UIColor themeColor];
    }
    return _lucreLabel;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor =  RGB_COLOR(245, 245, 245);
    }
    return _bgView;
}
- (UIImageView *)infoImageView{
    if (!_infoImageView) {
        _infoImageView = [[UIImageView alloc]init];
    }
    return _infoImageView;
}
-(UILabel *)infoTitleLabel{
    if (!_infoTitleLabel) {
        _infoTitleLabel = [[UILabel alloc]init];
        [_infoTitleLabel setFont:[UIFont titleFontBold17]];
        _infoTitleLabel.textColor = RGB_COLOR(51, 51, 51);
    }
    return _infoTitleLabel;
}
- (UILabel *)infoSubTitleLabel{
    if (!_infoSubTitleLabel) {
        _infoSubTitleLabel = [[UILabel alloc]init];
        _infoSubTitleLabel.numberOfLines = 0;
        [_infoSubTitleLabel sizeToFit];
        [_infoSubTitleLabel setFont:[UIFont titleFont16]];
        _infoSubTitleLabel.textColor = RGB_COLOR(102, 102, 102);
    }
    return _infoSubTitleLabel;
}
- (UILabel *)line3{
    if (!_line3) {
        _line3 = [[UILabel alloc]init];
        [_line3 setFont:[UIFont systemFontOfSize:15*SCREEN_H_POINT]];
        _line3.backgroundColor = RGB_COLOR(229, 229, 229);
    }
    return _line3;
}
- (UIButton *)awardBtn{
    if (!_awardBtn) {
        _awardBtn = [[UIButton alloc]init];
        [_awardBtn setImage:[UIImage imageNamed:@"yr_button_reward"] forState:UIControlStateNormal];
        [_awardBtn setTitle:@" 打赏" forState:UIControlStateNormal];
        _awardBtn.titleLabel.font = [UIFont titleFont16];
        [_awardBtn setTitleColor:RGB_COLOR(102, 102, 102) forState:UIControlStateNormal];
        [_awardBtn addTarget:self action:@selector(awardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _awardBtn;
}
- (UILabel *)line4{
    if (!_line4) {
        _line4 =[[UILabel alloc]init];
        [_line4 setFont:[UIFont systemFontOfSize:15*SCREEN_H_POINT]];
        _line4.backgroundColor = RGB_COLOR(229, 229, 229);
    }
    return _line4;
}
- (UIButton *)tranBtn{
    if (!_tranBtn) {
        _tranBtn = [[UIButton alloc]init];
        [_tranBtn setImage:[UIImage imageNamed:@"yr_button_tran"] forState:UIControlStateNormal];
        [_tranBtn setTitle:@" 转发得奖励" forState:UIControlStateNormal];
        _tranBtn.titleLabel.font = [UIFont titleFont16];
        [_tranBtn setTitleColor:RGB_COLOR(102, 102, 102) forState:UIControlStateNormal];
        [_tranBtn addTarget:self action:@selector(tranBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tranBtn;
}

//添加约束
- (void)setFrame{
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 10));
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1.mas_bottom).offset(15);
        make.left.mas_equalTo(self.mas_left).offset(10 *SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_top).offset(2);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(8*SCREEN_H_POINT);
        make.height.mas_equalTo(15);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(2);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(8*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(100*SCREEN_H_POINT, 15));
    }];
    [self.productTranSate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_top).offset(0);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(5*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(43*SCREEN_H_POINT, 13));
    }];
    [self.tranCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1.mas_bottom).offset(14);
        make.right.mas_equalTo(self.mas_right).offset(-10*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(30*SCREEN_H_POINT, 15));
    }];
    [self.lucreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tranCountLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(self.mas_right).offset(-10*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(30*SCREEN_H_POINT, 15));
    }];
    [self.tranTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1.mas_bottom).offset(15);
        make.right.mas_equalTo(self.tranCountLabel.mas_left).offset(-1*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(38*SCREEN_H_POINT, 14));
    }];
    [self.earningTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tranTipLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.tranTipLabel.mas_left).offset(0*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(27*SCREEN_H_POINT, 14));
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1.mas_bottom).offset(17);
        make.right.mas_equalTo(self.tranTipLabel.mas_left).offset(-5*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(1, 30));
    }];
    [self.redButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1.mas_bottom).offset(20);
        make.right.mas_equalTo(self.line2.mas_left).offset(-10*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(13*SCREEN_H_POINT, 20));
    }];
    
    
    
    [self.prouductRecommendImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(20, 21));
    } ];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconImageView.mas_bottom).offset(19);
        make.left.mas_equalTo(self.left).offset(10*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20*SCREEN_H_POINT, 85));
    }];
    
    
    [self.infoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).offset(10);
        make.left.mas_equalTo(self.bgView.mas_left).offset(10*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    [self.infoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).offset(10);
        make.left.mas_equalTo(self.infoImageView.mas_right).offset(10*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(255*SCREEN_H_POINT, 20));
    }];
    
    [self.infoSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoTitleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.infoImageView.mas_right).offset(10*SCREEN_H_POINT);
        make.size.mas_equalTo(CGSizeMake(255*SCREEN_H_POINT, 40));
    }];
    
    
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_bottom).offset(15);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
    }];
    [self.awardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line3.mas_bottom).offset(0);
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-1)/2, 35));
    }];

    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line3.mas_bottom).offset(5);
        make.left.mas_equalTo(self.awardBtn.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(1, 25));
    }];
    [self.tranBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line3.mas_bottom).offset(0);
        make.left.mas_equalTo(self.line4.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH-1)/2, 35));
    }];

    
    [self.iconImageView setCircleHeadWithPoint:CGPointMake(35, 35) radius:4];
    
}

- (void)setProductModel:(YRProductListModel *)productModel{
    self.iconImageView.userInteractionEnabled = YES;
    _productModel = productModel;
    [self.iconImageView addTapGesturesTarget:self selector:@selector(userImageClick)];
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:productModel.headImg] placeholder:[UIImage defaultHead]];
    
    [self.infoImageView setImageWithURL:[NSURL URLWithString:productModel.urlThumbnail] placeholder:[UIImage imageNamed:@"yr_pic_default"]];
    self.infoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.infoImageView.clipsToBounds = YES;
    self.nameLabel.text = productModel.nameNotes ? productModel.nameNotes : productModel.custNname;
    self.timeLabel.text = [NSString getTimeFormatterWithString:productModel.createDate];
    [self.nameLabel addTapGesturesTarget:self selector:@selector(userImageClick)];
    self.infoTitleLabel.text = productModel.desc;
    self.infoSubTitleLabel.text = productModel.infoIntroduction;
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
        [_tranBtn setImage:[UIImage imageNamed:@"yr_button_traned"] forState:UIControlStateNormal];
    }else{
        self.productTranSate.hidden = YES;
        [self.tranBtn setTitle:@" 转发得奖励" forState:UIControlStateNormal];
        [_tranBtn setTitleColor:RGB_COLOR(102, 102, 102) forState:UIControlStateNormal];
        [_tranBtn setImage:[UIImage imageNamed:@"yr_button_tran"] forState:UIControlStateNormal];
    }
    
    
//    if([productModel.custId isEqualToString:[YRUserInfoManager manager].currentUser.custId] && !circleModel.forwardStatus ){
//        self.productTranSate.hidden = YES;
//        [self.tranBtn setTitle:@" 邀请转发" forState:UIControlStateNormal];
//        
//    }
    

 
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    
}
- (void)userImageClick{
    if (self.delegate){
        [self.delegate imageTextCellDelegate:kHeadImage productModel:self.productModel];
    }
    if (self.circledelegate) {
        [self.circledelegate imageTextCellDelegate:kHeadImage circleModel:self.circleModel ];
    }
}

- (void)redButtonClick:(id)sender {
    
    
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
- (void)awardBtnClick:(UIButton *)sender {
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
- (void)tranBtnClick:(UIButton *)sender {
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

    
}


- (void)tranNumLabelClick{
    if (self.delegate){
        [self.delegate imageTextCellDelegate:kEarningsRule productModel:self.productModel];
    }
    
    if (self.circledelegate) {
        [self.circledelegate imageTextCellDelegate:kEarningsRule circleModel:self.circleModel ];
    }
    
}
- (void)earningsLabelClick{
    if (self.delegate){
        [self.delegate imageTextCellDelegate:kEarningsRule productModel:self.productModel];
    }
    
    if (self.circledelegate) {
        [self.circledelegate imageTextCellDelegate:kEarningsRule circleModel:self.circleModel ];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
