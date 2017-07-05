//
//  YRListenAndSayCell.h
//  YRYZ
//
//  Created by 易超 on 16/8/4.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YRProductListModel.h"

@protocol YRListenAndSayCellDelegate <NSObject>
- (void)listenAndSayCellDelegate:(BasicAction)basicAction productModel:(YRProductListModel*)productModel;
@end

@interface YRListenAndSayCell : UITableViewCell
- (void)setProductModel:(YRProductListModel *)productModel;
@property (weak, nonatomic) IBOutlet UIButton   *tranButton;
@property (nonatomic, assign) id<YRListenAndSayCellDelegate> delegate;
@end
