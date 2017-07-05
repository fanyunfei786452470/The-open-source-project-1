//
//  YRVideoCollectionViewCell.h
//  YRYZ
//
//  Created by Sean on 16/8/13.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRProductListModel.h"

@interface YRVideoCollectionViewCell : UICollectionViewCell

@property (nonatomic,copy) void(^choose)(BOOL isChoose) ;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
- (void)setProductModel:(YRProductListModel *)productModel;



@end
