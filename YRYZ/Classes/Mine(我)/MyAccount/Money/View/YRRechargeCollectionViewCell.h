//
//  YRRechargeCollectionViewCell.h
//  YRYZ
//
//  Created by 21.5 on 16/10/10.
//  Copyright © 2016年 yryz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YRRechargeCollectionViewCell : UICollectionViewCell
@property (strong,nonatomic)UIImageView * bgImage;
@property (strong,nonatomic)UIImageView * cionImage;
@property (strong,nonatomic)UIView * labelView;
@property (strong,nonatomic)UILabel * cionLabel;
@property (strong,nonatomic)UILabel * ciontext;
@property (strong,nonatomic)UILabel * moneyImage;
@property (strong,nonatomic)UILabel * moneyLabel;
@property (strong,nonatomic)NSString * ciontitle;
@property (strong,nonatomic)NSString * moneytitle;
@property (strong,nonatomic)NSString * ciontip;
@end
