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

@property (weak, nonatomic) IBOutlet UIButton *userImage;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UIButton *shareNum;
@property (weak, nonatomic) IBOutlet UIImageView *tranStateImageView;

@property (weak, nonatomic) IBOutlet UIImageView *recommendedImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@end
@implementation YRVideoCollectionViewCell

- (void)setProductModel:(YRProductListModel *)productModel{

    _productModel = productModel;

      [self.bgImage setImageWithURL:[NSURL URLWithString:productModel.urlThumbnail] placeholder:nil];
    [self.userImage setImageWithURL:[NSURL URLWithString:productModel.headImg] forState:UIControlStateNormal placeholder:nil];
    self.bgImage.backgroundColor = RGB_COLOR(245, 245, 245);

    self.userName.text = productModel.custNname;

    [self.userImage setImageWithURL:[NSURL URLWithString:productModel.headImg] forState:UIControlStateNormal placeholder:[UIImage defaultHead]];
    self.userName.text = productModel.nameNotes ? productModel.nameNotes : productModel.custNname;

    [self.userName addTapGesturesTarget:self selector:@selector(userImageClick)];
    self.bgImage.contentMode = UIViewContentModeScaleAspectFill;
    self.bgImage.clipsToBounds = YES;
   
    [self.shareNum setTitle:[NSString stringWithFormat:@" %@",productModel.transferCount] forState:UIControlStateNormal];
    [self.shareNum setImage:[UIImage imageNamed:@"yr_button_video_tran"] forState:UIControlStateNormal];
    self.title.text = productModel.desc;
    [self.userImage addTarget:self action:@selector(userImageClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (productModel.recommand) {
        self.recommendedImageView.hidden = NO;
    }else{
        self.recommendedImageView.hidden = YES;
    }
    
    if (productModel.forwardStatus) {
        self.tranStateImageView.hidden = NO;
    }else{
        self.tranStateImageView.hidden = YES;
    }
}
- (void)userImageClick{
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
    
    self.userImage.layer.cornerRadius = 15;
    self.userImage.clipsToBounds = YES;
}

@end
