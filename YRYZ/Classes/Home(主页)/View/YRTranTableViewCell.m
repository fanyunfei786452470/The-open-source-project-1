//
//  YRTranTableViewCell.m
//  YRYZ
//
//  Created by weishibo on 16/8/15.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRTranTableViewCell.h"

@interface YRTranTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (nonatomic ,strong)YRProudTranModel *tranModel;


@end

@implementation YRTranTableViewCell


- (void)setTranModel:(YRProudTranModel *)tranModel{
    
    _tranModel = tranModel;
    
    [_headImageView setImageWithURL:[NSURL URLWithString:tranModel.custImg] placeholder:[UIImage defaultHead]];
    _nameLabel.text = tranModel.custName ? tranModel.custName : tranModel.custNname;
    _timeLabel.text = @"????";
    
    self.headImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userImageClick)];
    [self.headImageView addGestureRecognizer:tap];
    
}
- (void)userImageClick{
    if (self.choose) {
        self.choose(YES);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.headImageView.layer.cornerRadius = 4;
    self.headImageView.layer.masksToBounds = YES;
    
    self.nameLabel.textColor = [UIColor themeColor];
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
