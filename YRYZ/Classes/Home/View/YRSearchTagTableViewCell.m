//
//  YRSearchTagTableViewCell.m
//  YRYZ
//
//  Created by weishibo on 16/9/3.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRSearchTagTableViewCell.h"

@interface YRSearchTagTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property(nonatomic ,strong)YRProductListModel          *productModel;
@end

@implementation YRSearchTagTableViewCell



- (void)setProductModel:(YRProductListModel *)productModel{

    _productModel = productModel;
    

    [self.headImageView setImageWithURL:[NSURL URLWithString:productModel.urlThumbnail] placeholder:[UIImage imageNamed:@"yr_pic_default"]];
    [self.headImageView setCircleHeadWithPoint:CGPointMake(65, 65) radius:4];
    self.titleLable.text = productModel.desc;
    self.subtitleLabel.text = productModel.infoIntroduction ;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];

    self.titleLable.font = [UIFont boldSystemFontOfSize:18];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
