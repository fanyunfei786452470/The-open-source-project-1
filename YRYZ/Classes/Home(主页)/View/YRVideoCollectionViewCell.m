//
//  YRVideoCollectionViewCell.m
//  YRYZ
//
//  Created by Sean on 16/8/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import "YRVideoCollectionViewCell.h"

@interface  YRVideoCollectionViewCell()

@property(nonatomic , strong)YRProductListModel   *productModel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIButton *userImage;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UIButton *shareNum;

@property (weak, nonatomic) IBOutlet UILabel *title;
@end
@implementation YRVideoCollectionViewCell


- (void)setProductModel:(YRProductListModel *)productModel{

    _productModel = productModel;
    
    
    [self.userImage setImageWithURL:[NSURL URLWithString:productModel.headImg] forState:UIControlStateNormal placeholder:[UIImage defaultHead]];
    self.userName.text = @"?????";
    self.bgImage.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImage.clipsToBounds = YES;
    [self.bgImage setImageWithURL:[NSURL URLWithString:@"http://ww3.sinaimg.cn/mw690/9cb86cb9gw1f5oy52rvpbj20i20ma76e.jpg"] placeholder:[UIImage defaultHead]];
    [self.shareNum setTitle:@" 1111" forState:UIControlStateNormal];
    [self.shareNum setImage:[UIImage imageNamed:@"yr_button_tran"] forState:UIControlStateNormal];
    self.title.text = productModel.desc;
    [self.userImage addTarget:self action:@selector(userImageClick:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)userImageClick:(UIButton *)sender{
    if (self.choose) {
        self.choose(YES);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.userName.textColor = RGB_COLOR(27, 194, 184);
    [self.shareNum setTitleColor:RGB_COLOR(102, 102, 102) forState:UIControlStateNormal];
    self.title.textColor = RGB_COLOR(102, 102, 102);
    self.userName.font = [UIFont boldSystemFontOfSize:12];
    
    self.userImage.layer.cornerRadius = 15;
    self.userImage.clipsToBounds = YES;
}

@end
