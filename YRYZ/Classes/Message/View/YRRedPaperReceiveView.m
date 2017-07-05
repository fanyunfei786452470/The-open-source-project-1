//
//  YRRedPaperReceiveView.m
//  YRYZ
//
//  Created by Rongzhong on 16/7/14.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRRedPaperReceiveView.h"



@interface YRRedPaperReceiveView()<UIScrollViewDelegate>

@property (strong,nonatomic)UIImageView *userPhoteImageView;
@property (strong,nonatomic)UILabel *nameLabel;
@property (strong,nonatomic)UILabel *moneyLabel;
@property (strong,nonatomic)UILabel *tintLabel;
@property (strong,nonatomic)UIButton *lookOtherButton;
@property (strong,nonatomic)YRRedListModel      *redModel;

@end

@implementation YRRedPaperReceiveView

- (instancetype)initWithFrame:(CGRect)frame  redModel:(YRRedListModel*)redModel
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.redModel = redModel;
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    UIScrollView *baseScrollView = [[UIScrollView alloc]init];
    baseScrollView.frame =  self.bounds;
    baseScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 63.5);
    baseScrollView.delegate = self;
    [self addSubview:baseScrollView];
    
    UIView *backView = [[UIView alloc]init];
    backView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    backView.backgroundColor = [UIColor whiteColor];
    [baseScrollView addSubview:backView];

    UIImageView *topBgView = [[UIImageView alloc]init];
    topBgView.userInteractionEnabled = YES;
    topBgView.frame = CGRectMake(0 , 0 ,SCREEN_WIDTH, 130);
    topBgView.image = [UIImage imageNamed:@"topBgImage"];
    [baseScrollView addSubview:topBgView];
    
    
    _userPhoteImageView = [[UIImageView alloc]init];
    _userPhoteImageView.userInteractionEnabled = YES;
    _userPhoteImageView.alpha = 0;
    [_userPhoteImageView setImageWithURL:[NSURL URLWithString:self.redModel.headImg] placeholder:[UIImage imageNamed:@"walletImage"]];
    [_userPhoteImageView setCircleHeadWithPoint:CGPointMake(68, 68) radius:34];
    _userPhoteImageView.frame = CGRectMake(SCREEN_WIDTH/2.0f -34, 56, 68, 68);
    [topBgView addSubview:_userPhoteImageView];
    
    NSMutableAttributedString *nameString= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@的红包",self.redModel.nickName]];
    
    [nameString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor themeColor]
                       range:NSMakeRange(0, nameString.length - 3)];
    
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.alpha = 0;
    _nameLabel.frame = CGRectMake(0, 146, SCREEN_WIDTH, 18);
    _nameLabel.textColor = [UIColor wordColor];
    _nameLabel.attributedText = nameString;
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:18];
    [baseScrollView addSubview:_nameLabel];

    
    float rcFee = [self.redModel.rcfee floatValue]*0.01;
//    NSMutableAttributedString *moneyString= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f",rcFee]];
//    
//    [moneyString addAttribute:NSFontAttributeName
//                       value:[UIFont systemFontOfSize:50]
//                       range:NSMakeRange(0, moneyString.length - 1)];
    
    NSString *moneyString  = [NSString stringWithFormat:@"%.2f",rcFee];
    _moneyLabel = [[UILabel alloc]init];
    _moneyLabel.alpha = 0;
    _moneyLabel.frame = CGRectMake(0, 214, SCREEN_WIDTH, 51);
    _moneyLabel.textColor = RGB_COLOR(250, 114, 111);
    _moneyLabel.font = [UIFont systemFontOfSize:50];
    _moneyLabel.text = moneyString;
    _moneyLabel.textAlignment = NSTextAlignmentCenter;
    [baseScrollView addSubview:_moneyLabel];
    
    
    _tintLabel = [[UILabel alloc]init];
    _tintLabel.alpha = 0;
    _tintLabel.frame = CGRectMake(0, 265, SCREEN_WIDTH, 16);
    _tintLabel.textColor = [UIColor grayColorTwo];
    _tintLabel.text = @"已存入“奖励积分”账户";
    _tintLabel.textAlignment = NSTextAlignmentCenter;
    _tintLabel.font = [UIFont systemFontOfSize:15];
    [baseScrollView addSubview:_tintLabel];
    
    
     _lookOtherButton =[UIButton buttonWithType:UIButtonTypeCustom];
     _lookOtherButton.alpha = 0;
     _lookOtherButton.frame = CGRectMake(SCREEN_WIDTH / 2.0f - 100, SCREEN_HEIGHT - 124, 200, 20);
     [_lookOtherButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
     [_lookOtherButton addTarget:self action:@selector(lookRedPaperRecord) forControlEvents:UIControlEventTouchUpInside];
     _lookOtherButton.titleLabel.font = [UIFont systemFontOfSize:15];
     [_lookOtherButton setTitle:@"查看我的红包记录>" forState:UIControlStateNormal];
     [baseScrollView addSubview:_lookOtherButton];
}

-(void)showAnimation
{
    [UIView animateWithDuration:0.4 animations:^{
        _userPhoteImageView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            _nameLabel.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                _moneyLabel.alpha = 1;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.15 animations:^{
                    _tintLabel.alpha = 1;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.15 animations:^{
                        _lookOtherButton.alpha = 1;
                    }];
                }];
            }];
        }];
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < 0) {
        scrollView.backgroundColor = RGB_COLOR(226, 57, 46);
    }else if(scrollView.contentOffset.y > 0){
        scrollView.backgroundColor = [UIColor whiteColor];
    }
}

-(void)lookRedPaperRecord
{
    if (_lookRecordBlock) {
        _lookRecordBlock();
    }
}

@end
